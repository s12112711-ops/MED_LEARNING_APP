import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorAnalyticsScreen extends StatefulWidget {
  const DoctorAnalyticsScreen({super.key});

  @override
  State<DoctorAnalyticsScreen> createState() => _DoctorAnalyticsScreenState();
}

class _DoctorAnalyticsScreenState extends State<DoctorAnalyticsScreen> {
  bool isLoading = true;

  int announcementsCount = 0;
  int pinnedAnnouncementsCount = 0;
  int materialsCount = 0;
  int publishedMaterialsCount = 0;
  int questionsCount = 0;
  int quizzesCount = 0;
  int publishedQuizzesCount = 0;
  int messagesCount = 0;
  int quizResultsCount = 0;
  double averageQuestionsPerQuiz = 0.0;

  final String announcementsUrl = "http://127.0.0.1:5000/api/announcements";
  final String materialsUrl = "http://127.0.0.1:5000/api/materials";
  final String questionsUrl = "http://127.0.0.1:5000/api/questions";
  final String quizzesUrl = "http://127.0.0.1:5000/api/quizzes";
  final String messagesUrl = "http://127.0.0.1:5000/api/messages/all";
  final String quizResultsUrl = "http://127.0.0.1:5000/api/quiz-results/all";

  Future<List> fetchList(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Request failed: $url");
    }

    final contentType = response.headers["content-type"] ?? "";
    if (!contentType.contains("application/json")) {
      throw Exception("Non-JSON response from: $url");
    }

    final data = jsonDecode(response.body);
    return data is List ? data : [];
  }

  @override
  void initState() {
    super.initState();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        fetchList(announcementsUrl),
        fetchList(materialsUrl),
        fetchList(questionsUrl),
        fetchList(quizzesUrl),
        fetchList(messagesUrl),
        fetchList(quizResultsUrl),
      ]);

      if (!mounted) return;

      final List announcementsList = results[0];
      final List materialsList = results[1];
      final List questionsList = results[2];
      final List quizzesList = results[3];
      final List messagesList = results[4];
      final List quizResultsList = results[5];

      int pinnedCount = 0;
      for (final item in announcementsList) {
        if (item["isPinned"] == true) {
          pinnedCount++;
        }
      }

      int publishedMaterials = 0;
      for (final item in materialsList) {
        if (item["isPublished"] == true) {
          publishedMaterials++;
        }
      }

      int publishedQuizzes = 0;
      int totalQuestionsInsideQuizzes = 0;

      for (final item in quizzesList) {
        if (item["isPublished"] == true) {
          publishedQuizzes++;
        }

        final questions = item["questions"];
        if (questions is List) {
          totalQuestionsInsideQuizzes += questions.length;
        }
      }

      double avgQuestions = 0.0;
      if (quizzesList.isNotEmpty) {
        avgQuestions = totalQuestionsInsideQuizzes / quizzesList.length;
      }

      setState(() {
        announcementsCount = announcementsList.length;
        pinnedAnnouncementsCount = pinnedCount;
        materialsCount = materialsList.length;
        publishedMaterialsCount = publishedMaterials;
        questionsCount = questionsList.length;
        quizzesCount = quizzesList.length;
        publishedQuizzesCount = publishedQuizzes;
        messagesCount = messagesList.length;
        quizResultsCount = quizResultsList.length;
        averageQuestionsPerQuiz = avgQuestions;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load analytics: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required String subtitle,
  }) {
    const blue = Color(0xFF0E4A6B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEAF4FA),
            child: Icon(icon, color: blue, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: blue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    final screenWidth = MediaQuery.of(context).size.width;

    int crossCount;
    if (screenWidth < 700) {
      crossCount = 1;
    } else if (screenWidth < 1000) {
      crossCount = 2;
    } else if (screenWidth < 1300) {
      crossCount = 3;
    } else {
      crossCount = 4;
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Doctor Analytics"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: fetchAnalytics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Analytics Overview",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Quick summary of announcements, materials, question bank, quizzes, messages, and quiz results.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withAlpha(235),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                GridView.count(
                  crossAxisCount: crossCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.45,
                  children: [
                    buildStatCard(
                      title: "Announcements",
                      value: announcementsCount.toString(),
                      icon: Icons.campaign_outlined,
                      subtitle: "Pinned: $pinnedAnnouncementsCount",
                    ),
                    buildStatCard(
                      title: "Materials",
                      value: materialsCount.toString(),
                      icon: Icons.upload_file_outlined,
                      subtitle: "Published: $publishedMaterialsCount",
                    ),
                    buildStatCard(
                      title: "Question Bank",
                      value: questionsCount.toString(),
                      icon: Icons.quiz_outlined,
                      subtitle: "All saved questions",
                    ),
                    buildStatCard(
                      title: "Quizzes",
                      value: quizzesCount.toString(),
                      icon: Icons.fact_check_outlined,
                      subtitle: "Published: $publishedQuizzesCount",
                    ),
                    buildStatCard(
                      title: "Messages",
                      value: messagesCount.toString(),
                      icon: Icons.chat_bubble_outline,
                      subtitle: "Doctor-student messages",
                    ),
                    buildStatCard(
                      title: "Quiz Results",
                      value: quizResultsCount.toString(),
                      icon: Icons.bar_chart_rounded,
                      subtitle: "Submitted attempts",
                    ),
                    buildStatCard(
                      title: "Avg Questions / Quiz",
                      value: averageQuestionsPerQuiz.toStringAsFixed(1),
                      icon: Icons.functions,
                      subtitle: "Average generated questions",
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}