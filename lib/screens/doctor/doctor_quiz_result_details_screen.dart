import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorQuizResultDetailsScreen extends StatefulWidget {
  final Map quiz;

  const DoctorQuizResultDetailsScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<DoctorQuizResultDetailsScreen> createState() =>
      _DoctorQuizResultDetailsScreenState();
}

class _DoctorQuizResultDetailsScreenState
    extends State<DoctorQuizResultDetailsScreen> {
  bool isLoading = true;
  List results = [];

  final String baseUrl = "http://127.0.0.1:5000/api/quiz-results";

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    setState(() {
      isLoading = true;
    });

    try {
      final quizId = widget.quiz["_id"]?.toString() ?? "";

      if (quizId.isEmpty) {
        setState(() {
          isLoading = false;
          results = [];
        });
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/quiz/$quizId"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          results = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load quiz results"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    final title = widget.quiz["title"] ?? "Quiz Results";
    final totalQuizQuestions = (widget.quiz["questions"] is List)
        ? (widget.quiz["questions"] as List).length
        : 0;

    double averageScore = 0;
    if (results.isNotEmpty) {
      final total = results.fold<num>(
        0,
        (sum, item) => sum + ((item["score"] ?? 0) as num),
      );
      averageScore = total / results.length;
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text("$title Results"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blue,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Total submissions: ${results.length}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Quiz questions: $totalQuizQuestions",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Average score: ${averageScore.toStringAsFixed(1)} / $totalQuizQuestions",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : results.isEmpty
                    ? const Center(
                        child: Text(
                          "No student results yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchResults,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final item = results[index];
                            final studentName =
                                item["studentName"] ?? "Unknown student";
                            final score = item["score"] ?? 0;
                            final totalQuestions = item["totalQuestions"] ?? 0;
                            final submittedAt = item["submittedAt"];

                            final double percentage = totalQuestions == 0
                                ? 0
                                : (score / totalQuestions) * 100;

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
                                    studentName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: blue,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Score: $score / $totalQuestions",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Percentage: ${percentage.toStringAsFixed(1)}%",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Submitted: ${formatDate(submittedAt)}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}