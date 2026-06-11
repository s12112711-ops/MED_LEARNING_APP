import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorEvaluationReviewScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const DoctorEvaluationReviewScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  State<DoctorEvaluationReviewScreen> createState() =>
      _DoctorEvaluationReviewScreenState();
}

class _DoctorEvaluationReviewScreenState
    extends State<DoctorEvaluationReviewScreen> {
  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Colors.white;
  static const Color heading = Color(0xFF102A43);
  static const Color muted = Color(0xFF627D98);
  static const Color border = Color(0xFFE3EBF2);
  static const Color navy = Color(0xFF0F3554);
  static const Color steel = Color(0xFF355C7D);

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  bool isLoading = true;
  List cases = [];
  String selectedFilter = "all";

  @override
  void initState() {
    super.initState();
    fetchDoctorCases();
  }

  Future<void> fetchDoctorCases() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor-evaluations/doctor/${widget.doctorId}"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          cases = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          cases = [];
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        cases = [];
        isLoading = false;
      });
    }
  }

  List get filteredCases {
    if (selectedFilter == "pending") {
      return cases.where((c) => (c["status"] ?? "pending") == "pending").toList();
    }
    if (selectedFilter == "reviewed") {
      return cases.where((c) => (c["status"] ?? "") == "reviewed").toList();
    }
    return cases;
  }

  int get pendingCount =>
      cases.where((c) => (c["status"] ?? "pending") == "pending").length;

  int get reviewedCount =>
      cases.where((c) => (c["status"] ?? "") == "reviewed").length;

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "reviewed":
        return const Color(0xFF2F855A);
      default:
        return const Color(0xFFB7791F);
    }
  }

  Widget _sectionCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _metricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11.8,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [navy, steel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E0F3554),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.fact_check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Clinical Review Station",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctorName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Review submitted student analyses, provide specialist feedback, assign structured scores, and complete the academic evaluation workflow.",
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip("Specialist review"),
              _heroChip("Academic feedback"),
              _heroChip("Clinical scoring"),
              _heroChip("Case supervision"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String value, String label) {
    final isSelected = selectedFilter == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? navy : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? navy : border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : heading,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _detailBlock(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: heading,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content.isEmpty ? "Not provided." : content,
            style: const TextStyle(
              fontSize: 13.2,
              color: muted,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openReviewDialog(Map caseItem) async {
    final feedbackController = TextEditingController(
      text: (caseItem["doctorFeedback"] ?? "").toString(),
    );
    final scoreController = TextEditingController(
      text: caseItem["doctorScore"] != null
          ? caseItem["doctorScore"].toString()
          : "",
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isSaving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Review Student Analysis",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: heading,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Student: ${(caseItem["studentName"] ?? "").toString()}",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Case Title: ${(caseItem["caseTitle"] ?? "").toString()}",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Specialty: ${(caseItem["specialty"] ?? "").toString()}",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _detailBlock(
                      "Student Symptoms / Case Context",
                      (caseItem["symptoms"] ?? "").toString(),
                    ),
                    const SizedBox(height: 12),
                    _detailBlock(
                      "Clinical Impression / History",
                      (caseItem["history"] ?? "").toString(),
                    ),
                    const SizedBox(height: 12),
                    _detailBlock(
                      "Provisional Diagnosis",
                      (caseItem["provisionalDiagnosis"] ?? "").toString(),
                    ),
                    const SizedBox(height: 12),
                    _detailBlock(
                      "Student Plan",
                      (caseItem["studentPlan"] ?? "").toString(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: feedbackController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Doctor Feedback",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Doctor Score (0 - 100)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSaving
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSaving
                                ? null
                                : () async {
                                    final feedback =
                                        feedbackController.text.trim();
                                    final score = int.tryParse(
                                      scoreController.text.trim(),
                                    );

                                    if (feedback.isEmpty ||
                                        score == null ||
                                        score < 0 ||
                                        score > 100) {
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please enter valid feedback and a score between 0 and 100.",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    setDialogState(() {
                                      isSaving = true;
                                    });

                                    try {
                                      final response = await http.put(
                                        Uri.parse(
                                          "$baseUrl/api/doctor-evaluations/${caseItem["_id"]}/review",
                                        ),
                                        headers: {
                                          "Content-Type": "application/json",
                                        },
                                        body: jsonEncode({
                                          "doctorFeedback": feedback,
                                          "doctorScore": score,
                                        }),
                                      );

                                      if (!mounted) return;

                                      if (response.statusCode == 200) {
                                        Navigator.pop(context);
                                        await fetchDoctorCases();

                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Case reviewed successfully.",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } else {
                                        final data = jsonDecode(response.body);
                                        ScaffoldMessenger.of(this.context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              data["message"] ??
                                                  "Failed to save review.",
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(this.context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text("Connection error: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } finally {
                                      if (context.mounted) {
                                        setDialogState(() {
                                          isSaving = false;
                                        });
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navy,
                              foregroundColor: Colors.white,
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Save Review"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _caseCard(Map caseItem) {
    final status = (caseItem["status"] ?? "pending").toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  (caseItem["caseTitle"] ?? "Untitled Case").toString(),
                  style: const TextStyle(
                    fontSize: 16.2,
                    fontWeight: FontWeight.w800,
                    color: heading,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor(status),
                    fontWeight: FontWeight.w700,
                    fontSize: 11.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Student: ${(caseItem["studentName"] ?? "").toString()}",
            style: const TextStyle(
              fontSize: 13,
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Specialty: ${(caseItem["specialty"] ?? "").toString()}",
            style: const TextStyle(
              fontSize: 13,
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Submitted diagnosis: ${(caseItem["provisionalDiagnosis"] ?? "").toString().isEmpty ? "Not provided" : (caseItem["provisionalDiagnosis"] ?? "").toString()}",
            style: const TextStyle(
              fontSize: 13.2,
              color: heading,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => openReviewDialog(caseItem),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.rate_review_rounded),
              label: Text(
                status == "reviewed" ? "Open Review" : "Review Case",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 760;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Doctor Evaluation Review"),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchDoctorCases,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _hero(),
                  const SizedBox(height: 18),
                  if (isTablet)
                    Row(
                      children: [
                        Expanded(
                          child: _metricTile(
                            title: "Assigned Cases",
                            value: "${cases.length}",
                            subtitle: "All student submissions",
                            icon: Icons.inventory_2_rounded,
                            color: navy,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _metricTile(
                            title: "Pending",
                            value: "$pendingCount",
                            subtitle: "Awaiting review",
                            icon: Icons.pending_actions_rounded,
                            color: const Color(0xFFB7791F),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _metricTile(
                            title: "Reviewed",
                            value: "$reviewedCount",
                            subtitle: "Completed cases",
                            icon: Icons.verified_rounded,
                            color: const Color(0xFF2F855A),
                          ),
                        ),
                      ],
                    ),
                  if (isTablet) const SizedBox(height: 18),
                  _sectionCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filter Cases",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _filterButton("all", "All"),
                            _filterButton("pending", "Pending"),
                            _filterButton("reviewed", "Reviewed"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _sectionCard(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Assigned Student Cases",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Review submitted analyses, assess the student’s interpretation, and complete the specialist evaluation with feedback and score.",
                          style: TextStyle(
                            fontSize: 13.4,
                            color: muted,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (filteredCases.isEmpty)
                          const Text(
                            "No cases found for this filter.",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: muted,
                            ),
                          )
                        else
                          Column(
                            children:
                                filteredCases.map((c) => _caseCard(c)).toList(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}