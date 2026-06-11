import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'SmartFeatures_screen.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  final TextEditingController studentNameController =
      TextEditingController(text: "Student 1");

  bool isLoading = false;
  List results = [];

  int quizzesCompleted = 0;
  double averageScore = 0;
  String strongestTopic = "-";
  String weakestTopic = "-";
  String lastQuizTitle = "-";
  int lastScore = 0;

  final String baseUrl = "http://127.0.0.1:5000/api/quiz-results";

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    final studentName = studentNameController.text.trim();

    if (studentName.isEmpty) {
      _showMessage("Please enter a student name");
      return;
    }

    setState(() {
      isLoading = true;
      results = [];
      quizzesCompleted = 0;
      averageScore = 0;
      strongestTopic = "-";
      weakestTopic = "-";
      lastQuizTitle = "-";
      lastScore = 0;
    });

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/student/$studentName"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          _calculateProgress(data);

          setState(() {
            results = data;
            isLoading = false;
          });
        } else {
          setState(() {
            results = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showMessage("Failed to load student progress");
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      _showMessage("Error: $e");
    }
  }

  void _calculateProgress(List data) {
    if (data.isEmpty) {
      quizzesCompleted = 0;
      averageScore = 0;
      strongestTopic = "-";
      weakestTopic = "-";
      lastQuizTitle = "-";
      lastScore = 0;
      return;
    }

    quizzesCompleted = data.length;

    double totalScore = 0;
    Map<String, List<double>> topicScores = {};

    for (var item in data) {
      final double score = ((item["scorePercentage"] ?? 0) as num).toDouble();
      final String topic = (item["topic"] ?? "-").toString();

      totalScore += score;

      if (!topicScores.containsKey(topic)) {
        topicScores[topic] = [];
      }
      topicScores[topic]!.add(score);
    }

    averageScore = totalScore / data.length;

    final latestResult = data.first;
    lastQuizTitle = (latestResult["quizTitle"] ?? "-").toString();
    lastScore = ((latestResult["scorePercentage"] ?? 0) as num).toInt();

    String bestTopic = "-";
    String worstTopic = "-";
    double bestAverage = -1;
    double worstAverage = 101;

    topicScores.forEach((topic, scores) {
      final double avg = scores.reduce((a, b) => a + b) / scores.length;

      if (avg > bestAverage) {
        bestAverage = avg;
        bestTopic = topic;
      }

      if (avg < worstAverage) {
        worstAverage = avg;
        worstTopic = topic;
      }
    });

    strongestTopic = bestTopic;
    weakestTopic = worstTopic;
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String formatDate(String? submittedAt) {
    if (submittedAt == null || submittedAt.isEmpty) return "No date";
    try {
      final date = DateTime.parse(submittedAt).toLocal();
      return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return submittedAt;
    }
  }

  Widget buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withAlpha(31),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultCard(Map item) {
    final int percentage = ((item["scorePercentage"] ?? 0) as num).toInt();
    final String quizTitle = (item["quizTitle"] ?? "Quiz").toString();
    final String topic = (item["topic"] ?? "-").toString();
    final String subject = (item["subject"] ?? "-").toString();
    final int totalQuestions = ((item["totalQuestions"] ?? 0) as num).toInt();
    final int correctAnswers = ((item["correctAnswers"] ?? 0) as num).toInt();
    final String submittedAt = (item["submittedAt"] ?? "").toString();

    final bool highScore = percentage >= 80;
    final bool mediumScore = percentage >= 50 && percentage < 80;

    Color badgeColor;
    Color badgeBg;

    if (highScore) {
      badgeColor = Colors.green.shade700;
      badgeBg = Colors.green.shade50;
    } else if (mediumScore) {
      badgeColor = Colors.orange.shade700;
      badgeBg = Colors.orange.shade50;
    } else {
      badgeColor = Colors.red.shade700;
      badgeBg = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.shade50),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.quiz, color: Colors.blue.shade700),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  quizTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$percentage%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Subject: $subject",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Topic: $topic",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Correct: $correctAnswers / $totalQuestions",
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Submitted: ${formatDate(submittedAt)}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopHeader() {
    const primary = Color(0xFF0E4A6B);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Track Student Performance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Check quiz history, average score, strongest topic, and weak areas.",
            style: TextStyle(
              color: Colors.white.withAlpha(230),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: studentNameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter student name",
              hintStyle: TextStyle(color: Colors.white.withAlpha(179)),
              prefixIcon: const Icon(Icons.person, color: Colors.white),
              filled: true,
              fillColor: Colors.white.withAlpha(31),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : fetchProgress,
              icon: const Icon(Icons.analytics),
              label: Text(isLoading ? "Loading..." : "Get Progress"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsSection() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: [
        buildStatCard(
          icon: Icons.fact_check,
          title: "Quizzes Completed",
          value: "$quizzesCompleted",
          color: Colors.blue,
        ),
        buildStatCard(
          icon: Icons.bar_chart,
          title: "Average Score",
          value: "${averageScore.toStringAsFixed(1)}%",
          color: Colors.green,
        ),
        buildStatCard(
          icon: Icons.emoji_events,
          title: "Strongest Topic",
          value: strongestTopic,
          color: Colors.purple,
        ),
        buildStatCard(
          icon: Icons.trending_down,
          title: "Weakest Topic",
          value: weakestTopic,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget buildLastQuizSection() {
    return buildStatCard(
      icon: Icons.history_edu,
      title: "Last Quiz",
      value: "$lastQuizTitle ($lastScore%)",
      color: Colors.orange,
    );
  }

  Widget buildSmartFeaturesButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: quizzesCompleted == 0
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SmartFeaturesScreen(
                      studentName: studentNameController.text.trim(),
                      averageScore: averageScore,
                      strongestTopic: strongestTopic,
                      weakestTopic: weakestTopic,
                      quizzesCompleted: quizzesCompleted,
                      lastScore: lastScore,
                    ),
                  ),
                );
              },
        icon: const Icon(Icons.auto_awesome),
        label: const Text("Open Smart Features"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0E4A6B),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget buildResultsSection() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (results.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            "No results yet",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Column(
      children: results.map((item) => buildResultCard(item as Map)).toList(),
    );
  }

  @override
  void dispose() {
    studentNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF4F8FC);
    const primary = Color(0xFF0E4A6B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Student Progress"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildTopHeader(),
          const SizedBox(height: 18),
          buildStatsSection(),
          const SizedBox(height: 16),
          buildLastQuizSection(),
          const SizedBox(height: 16),
          buildSmartFeaturesButton(context),
          const SizedBox(height: 22),
          const Text(
            "Quiz Results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          buildResultsSection(),
        ],
      ),
    );
  }
}