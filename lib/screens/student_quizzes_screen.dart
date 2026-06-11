import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_take_quiz_screen.dart';

class StudentQuizzesScreen extends StatefulWidget {
  final String currentUserId;
  const StudentQuizzesScreen({super.key, required this.currentUserId});

  @override
  State<StudentQuizzesScreen> createState() => _StudentQuizzesScreenState();
}

class _StudentQuizzesScreenState extends State<StudentQuizzesScreen> {
  bool isLoading = true;
  List quizzes = [];

  final String baseUrl = "http://127.0.0.1:5000/api/quizzes";

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allQuizzes = data is List ? data : [];

        final publishedQuizzes = allQuizzes.where((quiz) {
          return quiz["isPublished"] == true;
        }).toList();

        setState(() {
          quizzes = publishedQuizzes;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "No date";
    try {
      final date = DateTime.parse(createdAt).toLocal();
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return createdAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Available Quizzes"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizzes.isEmpty
              ? const Center(
                  child: Text("No published quizzes available"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    final title = quiz["title"] ?? "Quiz";
                    final subject = quiz["subject"] ?? "";
                    final topic = quiz["topic"] ?? "";
                    final description = quiz["description"] ?? "";
                    final durationMinutes = quiz["durationMinutes"] ?? 0;
                    final createdByName = quiz["createdByName"] ?? "Doctor";
                    final createdAt = quiz["createdAt"];
                    final questions = quiz["questions"] is List
                        ? quiz["questions"] as List
                        : [];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 14,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (subject.toString().trim().isNotEmpty)
                            Text("Subject: $subject"),
                          if (topic.toString().trim().isNotEmpty)
                            Text("Topic: $topic"),
                          const SizedBox(height: 6),
                          Text("Questions: ${questions.length}"),
                          Text("Duration: $durationMinutes minutes"),
                          Text("Created by: $createdByName"),
                          Text(formatDate(createdAt)),
                          if (description.toString().trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(description),
                          ],
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                  // Inject current user ID into quiz data
                                  final quizData = Map<String, dynamic>.from(quiz);
                                  quizData["studentId"] = widget.currentUserId;
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          StudentTakeQuizScreen(quiz: quizData),
                                    ),
                                  );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blue,
                              ),
                              child: const Text(
                                "Start Quiz",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}