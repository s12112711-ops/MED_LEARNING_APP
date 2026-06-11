import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'specialty_evaluation_details_screen.dart';

class EvaluationDepartmentModel {
  final String title;
  final String subtitle;
  final String description;
  final String specialtyKey;
  final IconData icon;
  final Color accent;
  final List<String> focusAreas;
  final String educationalGoal;
  final String supervisionModel;
  final int trainingCasesCount;
  final String imageAsset;

  const EvaluationDepartmentModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.specialtyKey,
    required this.icon,
    required this.accent,
    required this.focusAreas,
    required this.educationalGoal,
    required this.supervisionModel,
    required this.trainingCasesCount,
    required this.imageAsset,
  });
}

class DoctorEvaluationPanelScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const DoctorEvaluationPanelScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<DoctorEvaluationPanelScreen> createState() =>
      _DoctorEvaluationPanelScreenState();
}

class _DoctorEvaluationPanelScreenState
    extends State<DoctorEvaluationPanelScreen> {
  bool isLoading = true;
  List doctors = [];

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  static const Color background = Color(0xFFF4F7FA);
  static const Color surface = Colors.white;
  static const Color heading = Color(0xFF102A43);
  static const Color muted = Color(0xFF627D98);
  static const Color border = Color(0xFFE3EBF2);
  static const Color navy = Color(0xFF0F3554);
  static const Color steel = Color(0xFF355C7D);

  final List<EvaluationDepartmentModel> departments = const [
    EvaluationDepartmentModel(
      title: "Cardiology",
      subtitle: "Cardiac interpretation and acute cardiovascular reasoning",
      description:
          "Department for ECG-centered interpretation, acute coronary syndromes, rhythm disorders, and heart failure analysis.",
      specialtyKey: "Cardiology",
      icon: Icons.favorite_rounded,
      accent: Color(0xFF8B2332),
      focusAreas: ["ECG", "ACS", "Arrhythmia", "Heart Failure"],
      educationalGoal:
          "Train students to recognize urgent cardiovascular patterns and justify safe first-line decisions.",
      supervisionModel:
          "Reviewed by cardiology supervisors focusing on interpretation quality and clinical prioritization.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/cardiology.jpg",
    ),
    EvaluationDepartmentModel(
      title: "Emergency Medicine",
      subtitle: "Triage, instability, and urgent first response",
      description:
          "Department for triage logic, unstable patients, shock patterns, emergency escalation, and time-sensitive presentations.",
      specialtyKey: "Emergency Medicine",
      icon: Icons.emergency_rounded,
      accent: Color(0xFF9B5C18),
      focusAreas: ["Triage", "Shock", "Instability", "Urgent Care"],
      educationalGoal:
          "Strengthen urgency recognition and safe escalation thinking in acute clinical situations.",
      supervisionModel:
          "Reviewed by emergency physicians focusing on red flags, triage judgment, and early response logic.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/emergency.jpg",
    ),
    EvaluationDepartmentModel(
      title: "Internal Medicine",
      subtitle: "System-based adult medicine and integrated analysis",
      description:
          "Department for multisystem complaints, chronic disease interpretation, adult medical reasoning, and broad case synthesis.",
      specialtyKey: "Internal Medicine",
      icon: Icons.medical_services_rounded,
      accent: Color(0xFF295C87),
      focusAreas: ["Adult Medicine", "System Review", "Chronic Disease"],
      educationalGoal:
          "Develop structured reasoning across symptoms, history, clinical clues, and differential interpretation.",
      supervisionModel:
          "Reviewed by internal medicine doctors for depth, organization, and academic medical quality.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/internal_medicine.jpg",
    ),
    EvaluationDepartmentModel(
      title: "Pulmonology",
      subtitle: "Respiratory assessment and pulmonary interpretation",
      description:
          "Department for dyspnea, oxygenation problems, airway disease, pulmonary embolism suspicion, and respiratory review.",
      specialtyKey: "Pulmonology",
      icon: Icons.air_rounded,
      accent: Color(0xFF176B63),
      focusAreas: ["Dyspnea", "PE", "COPD", "Oxygenation"],
      educationalGoal:
          "Improve respiratory reasoning by linking symptom severity to pulmonary-focused clinical judgment.",
      supervisionModel:
          "Reviewed by pulmonology specialists with emphasis on respiratory severity assessment and interpretation.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/pulmonology.jpg",
    ),
    EvaluationDepartmentModel(
      title: "Neurology",
      subtitle: "Neurological red flags and focused assessment",
      description:
          "Department for focal deficits, stroke suspicion, high-risk headache patterns, and neuro-focused structured interpretation.",
      specialtyKey: "Neurology",
      icon: Icons.psychology_alt_rounded,
      accent: Color(0xFF5A4A93),
      focusAreas: ["Stroke", "Headache", "Deficits", "Neuro Exam"],
      educationalGoal:
          "Teach students to identify neurological warning signs and present a careful early interpretation.",
      supervisionModel:
          "Reviewed by neurology supervisors who assess pattern recognition and urgency awareness.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/neurology.jpg",
    ),
    EvaluationDepartmentModel(
      title: "General Assessment",
      subtitle: "Foundational case presentation and supervised review",
      description:
          "Department for improving case structure, presentation quality, early impression writing, and supervised clinical reasoning.",
      specialtyKey: "General Assessment",
      icon: Icons.assignment_turned_in_rounded,
      accent: Color(0xFF356EAA),
      focusAreas: ["Presentation", "Reasoning", "Feedback", "Foundations"],
      educationalGoal:
          "Build stronger academic case presentation habits before deeper specialty review.",
      supervisionModel:
          "Reviewed by general clinical supervisors focusing on clarity, structure, and educational growth.",
      trainingCasesCount: 2,
      imageAsset: "assets/medical_departments/general_assessment.jpg",
    ),
  ];

  final Map<String, List<Map<String, dynamic>>> fallbackDoctorsBySpecialty = const {
    "Cardiology": [
      {
        "_id": "doc_cardio_1",
        "fullName": "Dr Ahmad Al-Khatib",
        "email": "ahmad.cardio@medilearn.com",
        "specialization": "Cardiology",
      },
      {
        "_id": "doc_cardio_2",
        "fullName": "Dr Lina Salim",
        "email": "lina.cardio@medilearn.com",
        "specialization": "Cardiology",
      },
    ],
    "Emergency Medicine": [
      {
        "_id": "doc_em_1",
        "fullName": "Dr Omar Nasser",
        "email": "omar.emergency@medilearn.com",
        "specialization": "Emergency Medicine",
      },
      {
        "_id": "doc_em_2",
        "fullName": "Dr Rania Khalil",
        "email": "rania.emergency@medilearn.com",
        "specialization": "Emergency Medicine",
      },
    ],
    "Internal Medicine": [
      {
        "_id": "doc_im_1",
        "fullName": "Dr Sara Hamdan",
        "email": "sara.internal@medilearn.com",
        "specialization": "Internal Medicine",
      },
      {
        "_id": "doc_im_2",
        "fullName": "Dr Yousef Qasem",
        "email": "yousef.internal@medilearn.com",
        "specialization": "Internal Medicine",
      },
    ],
    "Pulmonology": [
      {
        "_id": "doc_pulm_1",
        "fullName": "Dr Noor Haddad",
        "email": "noor.pulm@medilearn.com",
        "specialization": "Pulmonology",
      },
      {
        "_id": "doc_pulm_2",
        "fullName": "Dr Basel Taha",
        "email": "basel.pulm@medilearn.com",
        "specialization": "Pulmonology",
      },
    ],
    "Neurology": [
      {
        "_id": "doc_neuro_1",
        "fullName": "Dr Huda Samara",
        "email": "huda.neuro@medilearn.com",
        "specialization": "Neurology",
      },
      {
        "_id": "doc_neuro_2",
        "fullName": "Dr Kareem Eid",
        "email": "kareem.neuro@medilearn.com",
        "specialization": "Neurology",
      },
    ],
    "General Assessment": [
      {
        "_id": "doc_general_1",
        "fullName": "Dr Maha Zaid",
        "email": "maha.general@medilearn.com",
        "specialization": "General Assessment",
      },
      {
        "_id": "doc_general_2",
        "fullName": "Dr Ali Darwish",
        "email": "ali.general@medilearn.com",
        "specialization": "General Assessment",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/doctor-evaluations/doctors"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          doctors = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          doctors = [];
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        doctors = [];
        isLoading = false;
      });
    }
  }

  List getDoctorsForSpecialty(String specialtyKey) {
    if (doctors.isNotEmpty) {
      if (specialtyKey.toLowerCase() == "general assessment") {
        return doctors;
      }

      final matched = doctors.where((doctor) {
        final specialization =
            (doctor["specialization"] ?? "").toString().trim().toLowerCase();
        return specialization.contains(specialtyKey.toLowerCase());
      }).toList();

      if (matched.isNotEmpty) return matched;
    }

    return fallbackDoctorsBySpecialty[specialtyKey] ?? [];
  }

  int get totalDoctorsCount {
    if (doctors.isNotEmpty) return doctors.length;
    return fallbackDoctorsBySpecialty.values.expand((e) => e).length;
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
            color: Color(0x1E113A5C),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Clinical Evaluation Departments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Select the correct clinical department before starting your review pathway. Each department contains specialty-specific cases and is supervised by doctors responsible for academic feedback and clinical evaluation.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip("${6} departments"),
              _heroChip("$totalDoctorsCount specialist doctors"),
              _heroChip("Case-based learning"),
              _heroChip("Academic supervision"),
            ],
          ),
        ],
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

  Widget _statsRow() {
    final urgentTracks = departments
        .where((e) =>
            e.title == "Cardiology" ||
            e.title == "Emergency Medicine" ||
            e.title == "Pulmonology")
        .length;

    return Row(
      children: [
        Expanded(
          child: _metricTile(
            title: "Departments",
            value: "${departments.length}",
            subtitle: "Clinical tracks",
            icon: Icons.apartment_rounded,
            color: navy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricTile(
            title: "Doctors",
            value: "$totalDoctorsCount",
            subtitle: "Review supervisors",
            icon: Icons.groups_rounded,
            color: steel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricTile(
            title: "Urgent Tracks",
            value: "$urgentTracks",
            subtitle: "High-acuity focus",
            icon: Icons.emergency_rounded,
            color: const Color(0xFF8E2430),
          ),
        ),
      ],
    );
  }

  Widget _workflow() {
    return _sectionCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "How the department model works",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "1. Select the most appropriate specialty.\n"
            "2. Enter the department workspace.\n"
            "3. Review the available training cases.\n"
            "4. Choose one case and build your own analysis.\n"
            "5. Submit that analysis for specialist feedback.",
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

  Widget _departmentImage(EvaluationDepartmentModel department) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Stack(
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Image.asset(
              department.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: department.accent.withOpacity(0.10),
                  alignment: Alignment.center,
                  child: Icon(
                    department.icon,
                    size: 44,
                    color: department.accent,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.52),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(
                    department.icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    department.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
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

  Widget _departmentCard(EvaluationDepartmentModel department) {
    final doctorsInDepartment = getDoctorsForSpecialty(department.specialtyKey);

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SpecialtyEvaluationDetailsScreen(
              studentId: widget.studentId,
              studentName: widget.studentName,
              specialtyTitle: department.title,
              specialtyKey: department.specialtyKey,
              specialtyDescription: department.description,
              specialtyColor: department.accent,
              doctors: doctorsInDepartment,
              focusAreas: department.focusAreas,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(28),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            _departmentImage(department),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    department.subtitle,
                    style: TextStyle(
                      fontSize: 12.8,
                      fontWeight: FontWeight.w700,
                      color: department.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    department.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.2,
                      height: 1.6,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _softChip("${doctorsInDepartment.length} doctors", department.accent),
                      _softChip(
                        "${department.trainingCasesCount} training cases",
                        navy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFCFE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Educational objective",
                          style: TextStyle(
                            fontSize: 12.2,
                            fontWeight: FontWeight.w800,
                            color: heading,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          department.educationalGoal,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: department.focusAreas
                        .map((e) => _softChip(e, department.accent))
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      Text(
                        "Open Department",
                        style: TextStyle(
                          color: navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: navy,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _cardWidth(double screenWidth) {
    if (screenWidth >= 1200) {
      return (screenWidth - 26 * 2 - 16 * 2) / 3;
    }
    if (screenWidth >= 760) {
      return (screenWidth - 18 * 2 - 16) / 2;
    }
    return screenWidth - 18 * 2;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 760;
    final bool isDesktop = screenWidth >= 1200;
    final double cardWidth = _cardWidth(screenWidth);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Doctor Evaluation Panel"),
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 26 : 18,
                vertical: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(),
                  const SizedBox(height: 18),
                  if (isTablet) _statsRow(),
                  if (isTablet) const SizedBox(height: 18),
                  _workflow(),
                  const SizedBox(height: 22),
                  const Text(
                    "Clinical Departments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Each department below represents a supervised clinical learning track with its own cases, specialist doctors, and feedback pathway.",
                    style: TextStyle(
                      fontSize: 13.5,
                      color: muted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: departments
                        .map(
                          (department) => SizedBox(
                            width: cardWidth,
                            child: _departmentCard(department),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}