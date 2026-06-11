import 'package:flutter/material.dart';
import '../services/clinical_result_service.dart';

class ClinicalHistoryScreen extends StatefulWidget {
  const ClinicalHistoryScreen({super.key});

  @override
  State<ClinicalHistoryScreen> createState() => _ClinicalHistoryScreenState();
}

class _ClinicalHistoryScreenState extends State<ClinicalHistoryScreen> {
  bool isLoading = true;
  List results = [];
  String studentName = "Amal";

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
      final data = await ClinicalResultService.getStudentResults(studentName);

      if (!mounted) return;
      setState(() {
        results = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Fetch results error: $e");
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Color performanceColor(String label) {
    switch (label.toLowerCase()) {
      case "excellent":
        return Colors.green;
      case "good":
        return Colors.blue;
      case "needs improvement":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData performanceIcon(String label) {
    switch (label.toLowerCase()) {
      case "excellent":
        return Icons.emoji_events_rounded;
      case "good":
        return Icons.thumb_up_alt_rounded;
      case "needs improvement":
        return Icons.trending_up_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  String formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}   ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return rawDate;
    }
  }

  double averageScore() {
    if (results.isEmpty) return 0;
    double total = 0;
    for (final item in results) {
      total += (item["score"] ?? 0).toDouble();
    }
    return total / results.length;
  }

  int highestScore() {
    if (results.isEmpty) return 0;
    int maxScore = 0;
    for (final item in results) {
      final score = item["score"] ?? 0;
      if (score > maxScore) maxScore = score;
    }
    return maxScore;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF14314B),
        ),
        title: Text(
          "Clinical History",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF14314B),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchResults,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : results.isEmpty
              ? Center(
                  child: Text(
                    "No clinical results found yet.",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchResults,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildTopSummary(isDark),
                      const SizedBox(height: 18),
                      ...results.map((item) {
                        final label = item["performanceLabel"] ?? "Unknown";
                        final color = performanceColor(label);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF111827) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFFDDE6EF),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  isDark ? 0.12 : 0.04,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: color.withOpacity(0.12),
                                    child: Icon(
                                      performanceIcon(label),
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item["caseTitle"] ?? "-",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF102033),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _infoRow(
                                isDark,
                                "Score",
                                "${item["score"] ?? 0} / 100",
                              ),
                              _infoRow(
                                isDark,
                                "Diagnosis",
                                item["diagnosisSelected"] ?? "-",
                              ),
                              _infoRow(
                                isDark,
                                "First Action",
                                item["firstActionSelected"] ?? "-",
                              ),
                              _infoRow(
                                isDark,
                                "Investigations",
                                ((item["selectedInvestigations"] as List?) ?? [])
                                    .join(", "),
                              ),
                              _infoRow(
                                isDark,
                                "Submitted At",
                                formatDate(item["submittedAt"] ?? ""),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildTopSummary(bool isDark) {
    final avg = averageScore();
    final max = highestScore();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F3D63),
            Color(0xFF1F6AA5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3D63).withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Clinical Performance Overview",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Track your clinical training performance across all completed cardiovascular simulation cases.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _summaryBox(
                  "Cases",
                  "${results.length}",
                  Icons.folder_copy_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryBox(
                  "Average",
                  avg.toStringAsFixed(1),
                  Icons.auto_graph_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryBox(
                  "Best",
                  "$max",
                  Icons.emoji_events_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(bool isDark, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              "$title:",
              style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF334155),
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}