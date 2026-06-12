import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StudentReportScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentReportScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Colors.white;
  static const Color heading = Color(0xFF102A43);
  static const Color muted = Color(0xFF627D98);
  static const Color border = Color(0xFFE3EBF2);
  static const Color navy = Color(0xFF0F3554);

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  bool isLoading = true;
  Map<String, dynamic>? reportData;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/student-report/${widget.studentId}"),
      );
      if (response.statusCode == 200) {
        setState(() {
          reportData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _downloadPdf() {
    final url = "$baseUrl/api/student-report/${widget.studentId}/pdf";
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(fontSize: 12.5, color: muted)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800, color: navy)),
    );
  }

  Widget _accuracyBar(int accuracy) {
    Color barColor;
    String label;
    if (accuracy >= 80) {
      barColor = const Color(0xFF38A169);
      label = "Excellent";
    } else if (accuracy >= 60) {
      barColor = const Color(0xFFD69E2E);
      label = "Good";
    } else {
      barColor = const Color(0xFFE53E3E);
      label = "Needs Improvement";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("AI Accuracy",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: heading)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: barColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: barColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: accuracy / 100,
              minHeight: 12,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$accuracy% correct answers",
            style: const TextStyle(fontSize: 13, color: muted),
          ),
        ],
      ),
    );
  }

  Widget _doctorCaseCard(Map<String, dynamic> c) {
    final score = c["doctorScore"] ?? 0;
    Color scoreColor;
    if (score >= 80) {
      scoreColor = const Color(0xFF38A169);
    } else if (score >= 60) {
      scoreColor = const Color(0xFFD69E2E);
    } else {
      scoreColor = const Color(0xFFE53E3E);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  c["caseTitle"] ?? "",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: heading),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$score/100",
                  style: TextStyle(
                      color: scoreColor, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text("Specialty: ${c["specialty"] ?? ""}",
              style: const TextStyle(color: muted, fontSize: 12.5)),
          const SizedBox(height: 6),
          if ((c["provisionalDiagnosis"] ?? "").toString().isNotEmpty)
            Text(
              "Diagnosis: ${c["provisionalDiagnosis"]}",
              style: const TextStyle(
                  fontSize: 13, color: heading, height: 1.4),
            ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Doctor Feedback:",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: navy)),
                const SizedBox(height: 6),
                Text(
                  (c["doctorFeedback"] ?? "").toString().isEmpty
                      ? "No feedback provided."
                      : c["doctorFeedback"],
                  style: const TextStyle(
                      fontSize: 13, color: muted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ai = reportData?["aiPerformance"];
    final doctor = reportData?["doctorEvaluations"];
    final List doctorCases = doctor?["cases"] ?? [];
    final int accuracy = ai?["accuracy"] ?? 0;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("${widget.studentName} - Report"),
        backgroundColor: navy,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: "Download PDF",
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchReport,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F3554), Color(0xFF355C7D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.insert_chart_rounded,
                            color: Colors.white, size: 36),
                        const SizedBox(height: 12),
                        Text(
                          widget.studentName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Complete performance overview across AI training and doctor-evaluated cases.",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.5,
                              height: 1.6),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Quick Stats"),
                  Row(
                    children: [
                      _statCard(
                          "AI Score",
                          "${ai?["score"] ?? 0}",
                          Icons.psychology_rounded,
                          const Color(0xFF3182CE)),
                      const SizedBox(width: 12),
                      _statCard(
                          "AI Cases",
                          "${ai?["totalCases"] ?? 0}",
                          Icons.biotech_rounded,
                          const Color(0xFF38A169)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statCard(
                          "Reviewed by Dr.",
                          "${doctor?["totalReviewed"] ?? 0}",
                          Icons.fact_check_rounded,
                          const Color(0xFF805AD5)),
                      const SizedBox(width: 12),
                      _statCard(
                          "Avg Dr. Score",
                          "${doctor?["averageScore"] ?? 0}/100",
                          Icons.star_rounded,
                          const Color(0xFFD69E2E)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statCard(
                          "Best Score",
                          "${doctor?["maxScore"] ?? 0}/100",
                          Icons.emoji_events_rounded,
                          const Color(0xFF38A169)),
                      const SizedBox(width: 12),
                      _statCard(
                          "Lowest Score",
                          "${doctor?["minScore"] ?? 0}/100",
                          Icons.trending_down_rounded,
                          const Color(0xFFE53E3E)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _accuracyBar(accuracy),
                  const SizedBox(height: 24),

                  _sectionTitle("Doctor Evaluated Cases"),
                  if (doctorCases.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: border),
                      ),
                      child: const Center(
                        child: Text("No reviewed cases yet.",
                            style: TextStyle(color: muted)),
                      ),
                    )
                  else
                    ...doctorCases
                        .map((c) =>
                            _doctorCaseCard(Map<String, dynamic>.from(c)))
                        .toList(),
                ],
              ),
            ),
    );
  }
}
