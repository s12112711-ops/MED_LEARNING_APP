import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpecialtyEvaluationDetailsScreen extends StatefulWidget {
  final String studentId;
  final String studentName;
  final String specialtyTitle;
  final String specialtyKey;
  final String specialtyDescription;
  final Color specialtyColor;
  final List doctors;
  final List<String> focusAreas;

  const SpecialtyEvaluationDetailsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
    required this.specialtyTitle,
    required this.specialtyKey,
    required this.specialtyDescription,
    required this.specialtyColor,
    required this.doctors,
    required this.focusAreas,
  });

  @override
  State<SpecialtyEvaluationDetailsScreen> createState() =>
      _SpecialtyEvaluationDetailsScreenState();
}

class _SpecialtyEvaluationDetailsScreenState
    extends State<SpecialtyEvaluationDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController impressionController = TextEditingController();
  final TextEditingController firstActionController = TextEditingController();
  final TextEditingController planController = TextEditingController();
  final TextEditingController reasoningController = TextEditingController();

  bool isSubmitting = false;
  bool isLoadingCases = true;
  List studentCases = [];

  String? selectedDoctorId;
  String? selectedDoctorName;
  Map<String, String>? selectedCase;

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Colors.white;
  static const Color heading = Color(0xFF102A43);
  static const Color muted = Color(0xFF627D98);
  static const Color border = Color(0xFFE3EBF2);
  static const Color navy = Color(0xFF0F3554);
  static const Color steel = Color(0xFF355C7D);

  final Map<String, String> specialtyImageByKey = const {
    "Cardiology": "assets/medical_departments/cardiology.jpg",
    "Emergency Medicine": "assets/medical_departments/emergency.jpg",
    "Internal Medicine": "assets/medical_departments/internal_medicine.jpg",
    "Pulmonology": "assets/medical_departments/pulmonology.jpg",
    "Neurology": "assets/medical_departments/neurology.jpg",
    "General Assessment": "assets/medical_departments/general_assessment.jpg",
  };

  final Map<String, IconData> specialtyIconByKey = const {
    "Cardiology": Icons.favorite_rounded,
    "Emergency Medicine": Icons.emergency_rounded,
    "Internal Medicine": Icons.medical_services_rounded,
    "Pulmonology": Icons.air_rounded,
    "Neurology": Icons.psychology_alt_rounded,
    "General Assessment": Icons.assignment_turned_in_rounded,
  };

  final Map<String, List<Map<String, String>>> starterCasesBySpecialty = {
    "Cardiology": [
      {
        "title": "Acute Chest Pain with ST Elevation",
        "summary":
            "A middle-aged patient presents with severe chest pain, diaphoresis, and ECG findings suggestive of STEMI.",
        "focus":
            "Interpret the ECG pattern, define urgency, identify the likely diagnosis, and recommend the correct first cardiac action.",
        "level": "High Priority",
      },
      {
        "title": "Progressive Dyspnea with Heart Failure Pattern",
        "summary":
            "An older patient presents with orthopnea, edema, and pulmonary congestion features.",
        "focus":
            "Connect the presentation to decompensated heart failure and organize an academically structured first response.",
        "level": "Moderate Priority",
      },
    ],
    "Emergency Medicine": [
      {
        "title": "Undifferentiated Shock at Triage",
        "summary":
            "A patient arrives hypotensive and tachycardic, requiring immediate prioritization and early stabilization thinking.",
        "focus":
            "Identify immediate threats, explain triage level, and justify the first urgent clinical actions.",
        "level": "Critical",
      },
      {
        "title": "Early Sepsis Recognition",
        "summary":
            "An elderly patient presents with fever, confusion, and systemic instability requiring urgent escalation.",
        "focus":
            "Recognize sepsis warning signs and explain why this patient needs urgent escalation and early treatment planning.",
        "level": "High Priority",
      },
    ],
    "Internal Medicine": [
      {
        "title": "Chronic Multisystem Fatigue Review",
        "summary":
            "A patient presents with fatigue, weight changes, and broad systemic complaints requiring integrated adult medicine reasoning.",
        "focus":
            "Structure an internal medicine impression and justify the leading possibilities using organized reasoning.",
        "level": "Academic Review",
      },
      {
        "title": "Diabetes with Renal Function Concern",
        "summary":
            "A known diabetic patient presents with poor control and findings suggesting early end-organ impact.",
        "focus":
            "Link chronic disease background to current findings and propose a clinically coherent medical assessment.",
        "level": "Academic Review",
      },
    ],
    "Pulmonology": [
      {
        "title": "Pulmonary Embolism Suspicion",
        "summary":
            "A patient presents with sudden dyspnea, pleuritic chest pain, and thromboembolic risk factors.",
        "focus":
            "Recognize a dangerous respiratory presentation and explain the urgency of pulmonary-focused evaluation.",
        "level": "High Priority",
      },
      {
        "title": "COPD Exacerbation Review",
        "summary":
            "A chronic smoker presents with worsening cough, hypoxia, and increased work of breathing.",
        "focus":
            "Assess respiratory severity, define the likely diagnosis, and explain the early management priorities.",
        "level": "Moderate Priority",
      },
    ],
    "Neurology": [
      {
        "title": "Acute Focal Neurological Deficit",
        "summary":
            "A patient develops sudden unilateral weakness and speech changes concerning for stroke activation.",
        "focus":
            "Identify neurological red flags, justify urgency, and present a focused early neurological impression.",
        "level": "Critical",
      },
      {
        "title": "High-Risk Headache Review",
        "summary":
            "A patient presents with severe headache and additional warning features requiring careful neurological assessment.",
        "focus":
            "Distinguish dangerous headache features from lower-risk patterns and define what makes the presentation concerning.",
        "level": "High Priority",
      },
    ],
    "General Assessment": [
      {
        "title": "Initial Clinical Reasoning Exercise",
        "summary":
            "A supervised general case intended to evaluate how the student structures symptoms, impression, diagnosis, and plan.",
        "focus":
            "Improve academic case presentation, organization, and the clarity of reasoning.",
        "level": "Foundation",
      },
      {
        "title": "Doctor-Guided Feedback Submission",
        "summary":
            "A broad educational case used to strengthen case structure, interpretation quality, and presentation style.",
        "focus":
            "Focus on clarity, safe first-line thinking, and the quality of written medical analysis.",
        "level": "Foundation",
      },
    ],
  };

  @override
  void initState() {
    super.initState();

    if (widget.doctors.isNotEmpty) {
      selectedDoctorId = (widget.doctors.first["_id"] ?? "").toString();
      selectedDoctorName = (widget.doctors.first["fullName"] ?? "").toString();
    }

    final starterCases =
        starterCasesBySpecialty[widget.specialtyKey] ?? const <Map<String, String>>[];

    if (starterCases.isNotEmpty) {
      selectedCase = starterCases.first;
    }

    fetchStudentCases();
  }

  Future<void> fetchStudentCases() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor-evaluations/student/${widget.studentId}"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final allItems = data is List ? data : [];

        final filtered = allItems.where((item) {
          final specialty =
              (item["specialty"] ?? "").toString().trim().toLowerCase();
          return specialty == widget.specialtyKey.trim().toLowerCase();
        }).toList();

        setState(() {
          studentCases = filtered;
          isLoadingCases = false;
        });
      } else {
        setState(() => isLoadingCases = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoadingCases = false);
    }
  }

  Future<void> submitCaseAnalysis() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDoctorId == null || selectedDoctorName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a doctor."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedCase == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a training case first."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => isSubmitting = true);

    final composedSymptoms =
        "Selected training case: ${selectedCase!["title"]}\n\nCase summary: ${selectedCase!["summary"]}\n\nAnalysis focus: ${selectedCase!["focus"]}";

    final composedHistory = impressionController.text.trim();

    final composedPlan =
        "First action: ${firstActionController.text.trim()}\n\nManagement plan: ${planController.text.trim()}\n\nClinical reasoning notes: ${reasoningController.text.trim()}";

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/doctor-evaluations"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "studentId": widget.studentId,
          "studentName": widget.studentName,
          "assignedDoctorId": selectedDoctorId,
          "assignedDoctorName": selectedDoctorName,
          "caseTitle": selectedCase!["title"],
          "specialty": widget.specialtyKey,
          "symptoms": composedSymptoms,
          "history": composedHistory,
          "provisionalDiagnosis": diagnosisController.text.trim(),
          "studentPlan": composedPlan,
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;
      setState(() => isSubmitting = false);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ?? "Case analysis submitted successfully.",
            ),
            backgroundColor: Colors.green,
          ),
        );

        diagnosisController.clear();
        impressionController.clear();
        firstActionController.clear();
        planController.clear();
        reasoningController.clear();

        await fetchStudentCases();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to submit analysis."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "reviewed":
        return const Color(0xFF2F855A);
      default:
        return const Color(0xFFB7791F);
    }
  }

  Widget _heroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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

  Widget _softChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.2,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
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

  Widget _heroImage() {
    final imageAsset = specialtyImageByKey[widget.specialtyKey];
    final icon = specialtyIconByKey[widget.specialtyKey] ?? Icons.local_hospital;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Stack(
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: imageAsset != null
                ? Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: widget.specialtyColor.withOpacity(0.10),
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          size: 56,
                          color: widget.specialtyColor,
                        ),
                      );
                    },
                  )
                : Container(
                    color: widget.specialtyColor.withOpacity(0.10),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      size: 56,
                      color: widget.specialtyColor,
                    ),
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    Colors.black.withOpacity(0.60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.specialtyTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _heroImage(),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specialtyDescription,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13.8,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.focusAreas
                      .map((item) => _softChip(item, widget.specialtyColor))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _workflow() {
    return _sectionCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Clinical learning workflow",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. Review the scope of this specialty.\n"
            "2. Identify the supervising doctors.\n"
            "3. Select one case from the training library.\n"
            "4. Build your own structured interpretation.\n"
            "5. Submit your analysis for specialist feedback.",
            style: TextStyle(
              fontSize: 13.5,
              height: 1.7,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorCard(Map doctor) {
    final name = (doctor["fullName"] ?? "Doctor").toString();
    final specialization = (doctor["specialization"] ?? "").toString();
    final email = (doctor["email"] ?? "").toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: widget.specialtyColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.medical_services_rounded,
              color: widget.specialtyColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: heading,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialization.isEmpty ? widget.specialtyTitle : specialization,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: widget.specialtyColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _caseCard(Map<String, String> item, bool isSelected) {
    final level = item["level"] ?? "Training";

    return InkWell(
      onTap: () {
        setState(() {
          selectedCase = item;
        });
      },
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? widget.specialtyColor.withOpacity(0.05) : surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? widget.specialtyColor : border,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item["title"] ?? "Training Case",
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: heading,
                    ),
                  ),
                ),
                if (isSelected)
                  _softChip("Selected", widget.specialtyColor)
                else
                  _softChip(level, navy),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item["summary"] ?? "",
              style: const TextStyle(
                fontSize: 13.2,
                height: 1.55,
                color: muted,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFCFE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Analysis focus",
                    style: TextStyle(
                      fontSize: 12.2,
                      fontWeight: FontWeight.w800,
                      color: heading,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["focus"] ?? "",
                    style: const TextStyle(
                      fontSize: 12.6,
                      height: 1.5,
                      color: muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedCasePreview() {
    if (selectedCase == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.specialtyColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: widget.specialtyColor.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _softChip("Selected case", widget.specialtyColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            selectedCase!["title"] ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: heading,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedCase!["summary"] ?? "",
            style: const TextStyle(
              fontSize: 13.2,
              height: 1.55,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submittedCaseCard(Map item) {
    final status = (item["status"] ?? "pending").toString();
    final feedback = (item["doctorFeedback"] ?? "").toString();
    final score = item["doctorScore"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  (item["caseTitle"] ?? "Untitled Case").toString(),
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Assigned Doctor: ${(item["assignedDoctorName"] ?? "").toString()}",
            style: const TextStyle(
              fontSize: 13,
              color: muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Submitted analysis stored under this specialty for specialist review.",
            style: const TextStyle(
              fontSize: 13.2,
              color: heading,
              height: 1.5,
            ),
          ),
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "Doctor Feedback: $feedback",
              style: const TextStyle(
                fontSize: 13.2,
                color: heading,
                height: 1.55,
              ),
            ),
          ],
          if (score != null) ...[
            const SizedBox(height: 8),
            Text(
              "Score: $score / 100",
              style: const TextStyle(
                fontSize: 13.2,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2F855A),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    diagnosisController.dispose();
    impressionController.dispose();
    firstActionController.dispose();
    planController.dispose();
    reasoningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final starterCases =
        starterCasesBySpecialty[widget.specialtyKey] ?? const <Map<String, String>>[];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text(widget.specialtyTitle),
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(),
            const SizedBox(height: 18),
            _workflow(),
            const SizedBox(height: 18),

            _sectionCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Specialist Team",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.doctors.isEmpty)
                    const Text(
                      "No doctors are currently assigned to this specialty.",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: muted,
                      ),
                    )
                  else
                    Column(
                      children:
                          widget.doctors.map((doctor) => _doctorCard(doctor)).toList(),
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
                    "Training Case Library",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Select one case from the specialty library. Your submitted work will be evaluated as an analysis of the selected case rather than a free-form unrelated submission.",
                    style: TextStyle(
                      fontSize: 13.4,
                      color: muted,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: starterCases.map((item) {
                      final isSelected =
                          selectedCase != null && selectedCase!["title"] == item["title"];
                      return _caseCard(item, isSelected);
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            _sectionCard(
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Case Analysis Workspace",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Build a structured academic analysis of the selected case. The assigned doctor will review the quality of your interpretation, diagnosis, first action, plan, and reasoning.",
                      style: TextStyle(
                        fontSize: 13.4,
                        color: muted,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _selectedCasePreview(),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedDoctorId,
                      decoration: const InputDecoration(
                        labelText: "Assign Specialist Doctor",
                        border: OutlineInputBorder(),
                      ),
                      items: widget.doctors.map<DropdownMenuItem<String>>((doctor) {
                        final id = (doctor["_id"] ?? "").toString();
                        final name = (doctor["fullName"] ?? "Doctor").toString();
                        final specialization =
                            (doctor["specialization"] ?? "").toString();

                        return DropdownMenuItem<String>(
                          value: id,
                          child: Text(
                            specialization.isEmpty
                                ? name
                                : "$name • $specialization",
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        final selected = widget.doctors.firstWhere(
                          (d) => (d["_id"] ?? "").toString() == value,
                          orElse: () => {},
                        );

                        setState(() {
                          selectedDoctorId = value;
                          selectedDoctorName =
                              (selected["fullName"] ?? "").toString();
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: diagnosisController,
                      decoration: const InputDecoration(
                        labelText: "Most Likely Diagnosis",
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Diagnosis is required."
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: impressionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Clinical Impression",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Clinical impression is required."
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: firstActionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "First Safe Clinical Action",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "First action is required."
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: planController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Management Plan",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Management plan is required."
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: reasoningController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Clinical Reasoning Notes",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: isSubmitting ? null : submitCaseAnalysis,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navy,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.send_rounded),
                        label: isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Submit Analysis for Review",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            _sectionCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Evaluation Progress",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Track the analyses you submitted within this specialty and monitor whether they are still pending or already reviewed by the assigned doctor.",
                    style: TextStyle(
                      fontSize: 13.4,
                      color: muted,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingCases)
                    const Center(child: CircularProgressIndicator())
                  else if (studentCases.isEmpty)
                    const Text(
                      "No submitted analyses yet for this specialty.",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: muted,
                      ),
                    )
                  else
                    Column(
                      children: studentCases
                          .map((item) => _submittedCaseCard(item))
                          .toList(),
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