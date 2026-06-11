import 'package:flutter/material.dart';
import 'progressive_case_simulation_screen.dart';

import 'package:med_learning_app/services/ai_service.dart';
import 'package:med_learning_app/screens/ai_case_screen.dart';

class SimulationCaseModel {
  final String title;
  final String category;
  final String difficulty;
  final String urgency;
  final String patientName;
  final int age;
  final String gender;
  final String complaint;
  final String history;
  final String ecgClue;
  final String labClue;
  final String imagingClue;
  final String hint;
  final String redFlag;
  final String likelyComplication;
  final List<String> physicalExam;
  final Map<String, String> vitals;
  final List<String> triageOptions;
  final int correctTriageIndex;
  final List<String> impressionOptions;
  final int correctImpressionIndex;
  final List<String> diagnosisOptions;
  final int correctDiagnosisIndex;
  final List<String> actionOptions;
  final int correctActionIndex;
  final Color color;
  final IconData icon;
  final List<String> tags;
  final int estimatedMinutes;
  final List<String> learningGoals;
  final bool featured;

  final String cardImage;
  final String patientImage;
  final String ecgImage;
  final String xrayImage;
  final String reportImage;
  final String ctImage;
  final Map<String, String> labTable;

  const SimulationCaseModel({
    required this.title,
    required this.category,
    required this.difficulty,
    required this.urgency,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.complaint,
    required this.history,
    required this.ecgClue,
    required this.labClue,
    required this.imagingClue,
    required this.hint,
    required this.redFlag,
    required this.likelyComplication,
    required this.physicalExam,
    required this.vitals,
    required this.triageOptions,
    required this.correctTriageIndex,
    required this.impressionOptions,
    required this.correctImpressionIndex,
    required this.diagnosisOptions,
    required this.correctDiagnosisIndex,
    required this.actionOptions,
    required this.correctActionIndex,
    required this.color,
    required this.icon,
    required this.tags,
    required this.estimatedMinutes,
    required this.learningGoals,
    required this.cardImage,
    required this.patientImage,
    required this.ecgImage,
    required this.xrayImage,
    required this.reportImage,
    required this.ctImage,
    required this.labTable,
    this.featured = false,
  });
}

class SimulationCaseBankScreen extends StatefulWidget {
  const SimulationCaseBankScreen({super.key});

  @override
  State<SimulationCaseBankScreen> createState() =>
      _SimulationCaseBankScreenState();
}

class _SimulationCaseBankScreenState extends State<SimulationCaseBankScreen> {
  String selectedCategoryFilter = "All";
  String selectedDifficultyFilter = "All";
  String selectedUrgencyFilter = "All";
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  List<SimulationCaseModel> get allCases => const [
        SimulationCaseModel(
          title: "Acute Chest Pain",
          category: "Ischemic Heart Disease",
          difficulty: "Intermediate",
          urgency: "High",
          patientName: "Patient X",
          age: 59,
          gender: "Male",
          complaint: "Severe central chest pain for 35 minutes",
          history:
              "Known smoker with diabetes and hypertension. Pain started at rest and radiates to the left arm with sweating and nausea.",
          ecgClue:
              "ECG reveals ST-segment elevation in anterior leads with reciprocal changes.",
          labClue:
              "Troponin is elevated. Glucose is mildly elevated. BNP is not the main clue here.",
          imagingClue:
              "Portable chest imaging shows no dominant pulmonary cause for the acute presentation.",
          hint:
              "Pain at rest with radiation and diaphoresis strongly suggests acute coronary syndrome.",
          redFlag:
              "Persistent chest pain with autonomic symptoms and hypotension.",
          likelyComplication:
              "Myocardial infarction, cardiogenic shock, or malignant arrhythmia.",
          physicalExam: [
            "Patient looks pale and diaphoretic",
            "Cool extremities",
            "Mild distress",
          ],
          vitals: {
            "BP": "94/60 mmHg",
            "HR": "116 bpm",
            "RR": "24 /min",
            "SpO2": "92%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 2,
          impressionOptions: [
            "Likely acute cardiac ischemia",
            "Likely respiratory problem",
            "Likely metabolic issue",
            "Unclear but low risk",
          ],
          correctImpressionIndex: 0,
          diagnosisOptions: [
            "Acute coronary syndrome / STEMI pattern",
            "Acute decompensated heart failure",
            "Benign chest wall pain",
            "Mild anxiety episode",
          ],
          correctDiagnosisIndex: 0,
          actionOptions: [
            "Discharge with reassurance and outpatient follow-up",
            "Urgent cardiac escalation, monitoring, ECG-focused management pathway",
            "Treat as simple gastritis",
            "Wait without intervention",
          ],
          correctActionIndex: 1,
          color: Color(0xFFE11D48),
          icon: Icons.favorite_rounded,
          tags: ["ECG", "Troponin", "Emergency"],
          estimatedMinutes: 10,
          learningGoals: [
            "Recognize ACS red flags",
            "Interpret an emergency cardiac clue",
            "Choose urgent escalation pathway",
          ],
          cardImage: "assets/cases/chest_pain_card.png",
          patientImage: "assets/cases/chest_pain_patient.png",
          ecgImage: "assets/cases/stemi_ecg.png",
          xrayImage: "assets/cases/chest_xray_normal.png",
          reportImage: "assets/cases/troponin_report.png",
          ctImage: "assets/cases/chest_pain_ct.png",
          labTable: {
            "Troponin": "Elevated",
            "Glucose": "168 mg/dL",
            "BNP": "Normal",
            "WBC": "10.8 x10^9/L",
          },
          featured: true,
        ),
        SimulationCaseModel(
          title: "Decompensated Heart Failure",
          category: "Heart Failure",
          difficulty: "Intermediate",
          urgency: "Moderate",
          patientName: "Patient Y",
          age: 68,
          gender: "Female",
          complaint: "Progressive shortness of breath and leg swelling",
          history:
              "History of ischemic heart disease and hypertension. Sleeps on 3 pillows and reports worsening exercise intolerance.",
          ecgClue:
              "ECG shows chronic ischemic changes without a primary acute STEMI pattern.",
          labClue:
              "BNP is elevated. Troponin is not the dominant driver here. Renal function may be mildly affected.",
          imagingClue:
              "Chest imaging suggests pulmonary vascular congestion and possible fluid overload.",
          hint:
              "Orthopnea + edema + crackles is a classic congestive pattern.",
          redFlag: "Low oxygen saturation with congestion signs.",
          likelyComplication:
              "Pulmonary edema, worsening hypoxia, or acute decompensation.",
          physicalExam: [
            "Bilateral pitting edema",
            "Basal crackles",
            "Mild jugular venous distension",
          ],
          vitals: {
            "BP": "138/84 mmHg",
            "HR": "104 bpm",
            "RR": "22 /min",
            "SpO2": "91%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 1,
          impressionOptions: [
            "Likely acute cardiac ischemia",
            "Likely congestive heart failure pattern",
            "Likely simple viral illness",
            "Low-risk presentation",
          ],
          correctImpressionIndex: 1,
          diagnosisOptions: [
            "Acute coronary syndrome",
            "Decompensated heart failure",
            "Simple dehydration",
            "Benign palpitations",
          ],
          correctDiagnosisIndex: 1,
          actionOptions: [
            "Ignore edema and discharge",
            "Assess oxygenation and manage likely decompensated heart failure",
            "Treat as skin allergy",
            "No urgent action needed",
          ],
          correctActionIndex: 1,
          color: Color(0xFF2563EB),
          icon: Icons.air_rounded,
          tags: ["BNP", "Congestion", "Heart Failure"],
          estimatedMinutes: 12,
          learningGoals: [
            "Connect symptoms with congestion",
            "Identify classic CHF presentation",
            "Differentiate CHF from ACS",
          ],
          cardImage: "assets/cases/hf_card.png",
          patientImage: "assets/cases/hf_patient.png",
          ecgImage: "assets/cases/hf_ecg.png",
          xrayImage: "assets/cases/hf_xray.png",
          reportImage: "assets/cases/hf_report.png",
          ctImage: "assets/cases/hf_ct.png",
          labTable: {
            "BNP": "High",
            "Troponin": "Mild / Non-dominant",
            "Creatinine": "1.4 mg/dL",
            "Na+": "132 mmol/L",
          },
          featured: true,
        ),
        SimulationCaseModel(
          title: "Unstable Tachyarrhythmia",
          category: "Arrhythmia",
          difficulty: "Advanced",
          urgency: "Critical",
          patientName: "Patient Z",
          age: 47,
          gender: "Male",
          complaint: "Sudden palpitations, dizziness, and chest discomfort",
          history:
              "Symptoms began this morning. Prior ischemic disease and poor sleep. No trauma history.",
          ecgClue:
              "ECG demonstrates a rapid tachyarrhythmia with significant hemodynamic effect.",
          labClue:
              "Electrolytes may contribute. Potassium imbalance should be considered.",
          imagingClue:
              "No primary imaging abnormality explains the acute instability better than rhythm disturbance.",
          hint:
              "Tachycardia with hypotension and dizziness should always raise instability concerns.",
          redFlag: "Hemodynamic instability due to fast abnormal rhythm.",
          likelyComplication:
              "Syncope, shock, poor perfusion, or sudden deterioration.",
          physicalExam: [
            "Irregular pulse",
            "Patient looks unwell",
            "No focal neurological deficit",
          ],
          vitals: {
            "BP": "88/56 mmHg",
            "HR": "158 bpm",
            "RR": "23 /min",
            "SpO2": "94%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 2,
          impressionOptions: [
            "Likely acute cardiac rhythm emergency",
            "Likely benign stress response",
            "Likely mild hypertension issue",
            "Low-risk metabolic complaint",
          ],
          correctImpressionIndex: 0,
          diagnosisOptions: [
            "Benign anxiety episode",
            "Hemodynamically significant tachyarrhythmia",
            "Stable chest wall pain",
            "Simple gastritis",
          ],
          correctDiagnosisIndex: 1,
          actionOptions: [
            "Observe only and discharge",
            "Urgent rhythm assessment and escalation due to instability",
            "Treat with reassurance only",
            "Delay intervention until tomorrow",
          ],
          correctActionIndex: 1,
          color: Color(0xFF7C3AED),
          icon: Icons.timeline_rounded,
          tags: ["Arrhythmia", "ECG", "Critical"],
          estimatedMinutes: 14,
          learningGoals: [
            "Detect hemodynamic instability",
            "Interpret rhythm emergency pattern",
            "Prioritize urgent management",
          ],
          cardImage: "assets/cases/tachy_card.png",
          patientImage: "assets/cases/tachy_patient.png",
          ecgImage: "assets/cases/tachy_ecg.png",
          xrayImage: "assets/cases/tachy_xray.png",
          reportImage: "assets/cases/tachy_report.png",
          ctImage: "assets/cases/tachy_ct.png",
          labTable: {
            "K+": "Low / borderline",
            "Mg++": "Low possible",
            "Troponin": "Pending",
            "Lactate": "Mild elevation",
          },
          featured: true,
        ),
        SimulationCaseModel(
          title: "Hypertensive Emergency Pattern",
          category: "Hypertension",
          difficulty: "Advanced",
          urgency: "High",
          patientName: "Patient W",
          age: 63,
          gender: "Female",
          complaint: "Severe headache with visual blurring and chest tightness",
          history:
              "Long history of poorly controlled hypertension and inconsistent medication adherence.",
          ecgClue:
              "ECG may show strain changes but not necessarily the primary source of symptoms.",
          labClue:
              "Renal function may be affected. Urinalysis can show evidence of organ involvement.",
          imagingClue:
              "Imaging is secondary to confirming end-organ risk depending on symptom profile.",
          hint:
              "Very high blood pressure plus neurological or visual symptoms is never routine.",
          redFlag: "Possible end-organ damage from uncontrolled severe hypertension.",
          likelyComplication:
              "Stroke, acute heart failure, or renal injury.",
          physicalExam: [
            "Patient distressed by headache",
            "Visual complaints present",
            "Elevated blood pressure on repeated measurements",
          ],
          vitals: {
            "BP": "212/124 mmHg",
            "HR": "102 bpm",
            "RR": "20 /min",
            "SpO2": "96%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 2,
          impressionOptions: [
            "Likely severe hypertensive emergency pattern",
            "Likely simple migraine only",
            "Likely benign dehydration",
            "Low-risk outpatient issue",
          ],
          correctImpressionIndex: 0,
          diagnosisOptions: [
            "Simple tension headache",
            "Hypertensive emergency pattern",
            "Low-risk visual fatigue",
            "Benign arrhythmia",
          ],
          correctDiagnosisIndex: 1,
          actionOptions: [
            "Send home and advise rest",
            "Urgent evaluation for end-organ damage and controlled escalation",
            "Treat as simple eye strain",
            "Ignore the blood pressure reading",
          ],
          correctActionIndex: 1,
          color: Color(0xFFEA580C),
          icon: Icons.warning_amber_rounded,
          tags: ["BP", "Emergency", "End-Organ Risk"],
          estimatedMinutes: 11,
          learningGoals: [
            "Recognize hypertensive emergency",
            "Assess end-organ damage risk",
            "Distinguish severe vs routine hypertension",
          ],
          cardImage: "assets/cases/htn_card.png",
          patientImage: "assets/cases/htn_patient.png",
          ecgImage: "assets/cases/htn_ecg.png",
          xrayImage: "assets/cases/htn_xray.png",
          reportImage: "assets/cases/htn_report.png",
          ctImage: "assets/cases/brain_ct.png",
          labTable: {
            "Creatinine": "Elevated",
            "Urinalysis": "Protein present",
            "Troponin": "Check if indicated",
            "K+": "Normal",
          },
        ),
        SimulationCaseModel(
          title: "Pulmonary Embolism Suspicion",
          category: "Emergency",
          difficulty: "Advanced",
          urgency: "Critical",
          patientName: "Patient M",
          age: 41,
          gender: "Female",
          complaint: "Sudden shortness of breath and pleuritic chest pain",
          history:
              "Recent prolonged travel and oral contraceptive use. Symptoms developed abruptly with tachycardia.",
          ecgClue:
              "ECG may show sinus tachycardia and nonspecific strain signs.",
          labClue:
              "D-dimer may be elevated. ABG can suggest hypoxemia.",
          imagingClue:
              "CT pulmonary angiography would be strongly considered if clinically appropriate.",
          hint:
              "Acute dyspnea + pleuritic pain + risk factors should raise concern for PE.",
          redFlag: "Sudden hypoxia with thromboembolic risk factors.",
          likelyComplication: "Hemodynamic collapse or worsening hypoxemia.",
          physicalExam: [
            "Anxious appearance",
            "Tachypnea",
            "Mild calf tenderness may be present",
          ],
          vitals: {
            "BP": "102/68 mmHg",
            "HR": "128 bpm",
            "RR": "28 /min",
            "SpO2": "89%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 2,
          impressionOptions: [
            "Likely acute pulmonary embolic pattern",
            "Likely simple asthma only",
            "Likely minor viral illness",
            "Low-risk musculoskeletal pain",
          ],
          correctImpressionIndex: 0,
          diagnosisOptions: [
            "Acute pulmonary embolism suspicion",
            "Simple gastritis",
            "Benign anxiety attack only",
            "Stable sinus headache",
          ],
          correctDiagnosisIndex: 0,
          actionOptions: [
            "Discharge after reassurance",
            "Urgent emergency assessment with PE-focused workup",
            "Delay until outpatient clinic",
            "Treat only with rest",
          ],
          correctActionIndex: 1,
          color: Color(0xFF0F766E),
          icon: Icons.monitor_heart_rounded,
          tags: ["Emergency", "Dyspnea", "Critical"],
          estimatedMinutes: 13,
          learningGoals: [
            "Identify thromboembolic red flags",
            "Link history to acute presentation",
            "Escalate a hypoxic emergency appropriately",
          ],
          cardImage: "assets/cases/pe_card.png",
          patientImage: "assets/cases/pe_patient.png",
          ecgImage: "assets/cases/pe_ecg.png",
          xrayImage: "assets/cases/pe_xray.png",
          reportImage: "assets/cases/pe_report.png",
          ctImage: "assets/cases/pe_ctpa.png",
          labTable: {
            "D-dimer": "Elevated",
            "ABG": "Hypoxemia",
            "Troponin": "May be mildly elevated",
            "WBC": "Normal / mild rise",
          },
          featured: true,
        ),
        SimulationCaseModel(
          title: "Sepsis Early Recognition",
          category: "Emergency",
          difficulty: "Intermediate",
          urgency: "High",
          patientName: "Patient N",
          age: 72,
          gender: "Male",
          complaint: "Fever, confusion, and weakness",
          history:
              "Diabetic patient with urinary symptoms over the last 2 days. Family reports increasing confusion since morning.",
          ecgClue:
              "ECG is not the main clue but may show sinus tachycardia.",
          labClue:
              "Inflammatory markers may be elevated. Lactate would be clinically important.",
          imagingClue:
              "Imaging depends on suspected source but systemic signs are already concerning.",
          hint:
              "Confusion in an older febrile patient should never be underestimated.",
          redFlag:
              "Altered mental status with infection concern and borderline pressure.",
          likelyComplication: "Septic shock and multi-organ dysfunction.",
          physicalExam: [
            "Confused and lethargic",
            "Warm skin initially",
            "Suprapubic tenderness may be present",
          ],
          vitals: {
            "BP": "96/58 mmHg",
            "HR": "118 bpm",
            "RR": "26 /min",
            "SpO2": "93%",
          },
          triageOptions: ["Stable", "Urgent", "Critical"],
          correctTriageIndex: 2,
          impressionOptions: [
            "Likely infection with systemic instability",
            "Likely chronic fatigue only",
            "Likely minor dehydration only",
            "Low-risk presentation",
          ],
          correctImpressionIndex: 0,
          diagnosisOptions: [
            "Possible sepsis syndrome",
            "Simple age-related weakness",
            "Benign headache",
            "Stable arrhythmia",
          ],
          correctDiagnosisIndex: 0,
          actionOptions: [
            "Send home with reassurance",
            "Urgent sepsis-oriented assessment and escalation",
            "Ignore confusion because of age",
            "Wait several days first",
          ],
          correctActionIndex: 1,
          color: Color(0xFFDC2626),
          icon: Icons.coronavirus_rounded,
          tags: ["Emergency", "Infection", "High Risk"],
          estimatedMinutes: 9,
          learningGoals: [
            "Recognize early sepsis warning signs",
            "Assess altered mental status properly",
            "Practice urgent escalation logic",
          ],
          cardImage: "assets/cases/sepsis_card.png",
          patientImage: "assets/cases/sepsis_patient.png",
          ecgImage: "assets/cases/sepsis_ecg.png",
          xrayImage: "assets/cases/sepsis_xray.png",
          reportImage: "assets/cases/sepsis_report.png",
          ctImage: "assets/cases/sepsis_ct.png",
          labTable: {
            "WBC": "High",
            "Lactate": "Elevated",
            "CRP": "High",
            "Urinalysis": "Suggestive of infection",
          },
        ),
      ];

  List<SimulationCaseModel> get featuredCases =>
      allCases.where((c) => c.featured).toList();

  List<String> get categoryFilters {
    final categories = <String>{"All"};
    for (final c in allCases) {
      categories.add(c.category);
    }
    return categories.toList();
  }

  List<String> get difficultyFilters {
    final values = <String>{"All"};
    for (final c in allCases) {
      values.add(c.difficulty);
    }
    return values.toList();
  }

  List<String> get urgencyFilters {
    final values = <String>{"All"};
    for (final c in allCases) {
      values.add(c.urgency);
    }
    return values.toList();
  }

  List<SimulationCaseModel> get filteredCases {
    return allCases.where((c) {
      final q = searchQuery.trim().toLowerCase();

      final matchesSearch = q.isEmpty ||
          c.title.toLowerCase().contains(q) ||
          c.category.toLowerCase().contains(q) ||
          c.complaint.toLowerCase().contains(q) ||
          c.history.toLowerCase().contains(q) ||
          c.tags.any((e) => e.toLowerCase().contains(q));

      final matchesCategory =
          selectedCategoryFilter == "All" || c.category == selectedCategoryFilter;

      final matchesDifficulty = selectedDifficultyFilter == "All" ||
          c.difficulty == selectedDifficultyFilter;

      final matchesUrgency =
          selectedUrgencyFilter == "All" || c.urgency == selectedUrgencyFilter;

      return matchesSearch &&
          matchesCategory &&
          matchesDifficulty &&
          matchesUrgency;
    }).toList();
  }

  SimulationCaseModel get recommendedCase {
    final criticalFeatured = featuredCases
        .where((c) => c.urgency == "Critical" || c.urgency == "High")
        .toList();

    if (criticalFeatured.isNotEmpty) return criticalFeatured.first;
    if (featuredCases.isNotEmpty) return featuredCases.first;
    return allCases.first;
  }

  int get criticalCasesCount =>
      allCases.where((c) => c.urgency == "Critical").length;

  int get highRiskCasesCount =>
      allCases.where((c) => c.urgency == "High").length;

  int get advancedCasesCount =>
      allCases.where((c) => c.difficulty == "Advanced").length;

  int get emergencyCasesCount =>
      allCases.where((c) => c.tags.contains("Emergency")).length;

  Color _urgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case "critical":
        return const Color(0xFFDC2626);
      case "high":
        return const Color(0xFFEA580C);
      case "moderate":
        return const Color(0xFFD97706);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case "advanced":
        return const Color(0xFF7C3AED);
      case "intermediate":
        return const Color(0xFF2563EB);
      case "beginner":
        return const Color(0xFF059669);
      default:
        return const Color(0xFF64748B);
    }
  }

  Widget _softTag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11.4,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF113A5C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF113A5C)
                : const Color(0xFFD8E3EA),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF113A5C).withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF486581),
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16324A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF486581),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.8,
                    color: Color(0xFF829AB1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
        decoration: InputDecoration(
          hintText:
              "Search by case title, complaint, category, history, or clinical tag...",
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() => searchQuery = "");
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF16324A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF61758A),
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildCommandCenterHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C2F4A),
            Color(0xFF145A86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330C2F4A),
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
                  "Clinical Simulation Command Center",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "This environment is designed for structured clinical reasoning. Students do not merely open cases — they triage urgency, interpret clues, form impressions, confirm diagnoses, and choose the first safe medical action.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _darkTag("${allCases.length} simulation cases"),
              _darkTag("$criticalCasesCount critical"),
              _darkTag("$highRiskCasesCount high-acuity"),
              _darkTag("$advancedCasesCount advanced reasoning"),
              _darkTag("$emergencyCasesCount emergency focused"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiZone(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "AI Diagnostic Training Zone",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16324A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Generate a fresh AI-supported clinical case when the student wants an additional scenario beyond the prepared simulation bank. This is useful for repeated practice, self-testing, and richer exposure to variable medical presentations.",
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF61758A),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  final aiCase = await AiService.generateCase();

                  if (!mounted) return;
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiCaseScreen(caseData: aiCase),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  Navigator.pop(context);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Error"),
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text(
                "Generate AI Case",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCasePanel(BuildContext context) {
    final item = recommendedCase;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            item.color.withOpacity(0.95),
            item.color.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _darkTag("Clinical Priority Case"),
              _darkTag(item.difficulty),
              _darkTag(item.urgency),
              _darkTag("${item.estimatedMinutes} min"),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(item.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${item.category} • ${item.patientName}, ${item.age} y/o ${item.gender}",
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              item.cardImage,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 170,
                width: double.infinity,
                color: Colors.white12,
                alignment: Alignment.center,
                child: const Text(
                  "Clinical case preview",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.complaint,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.history,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.3,
              color: Colors.white70,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.learningGoals
                .map(
                  (goal) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      goal,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProgressiveCaseSimulationScreen(caseData: item),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: item.color,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                "Start Guided Simulation",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedStripCard(BuildContext context, SimulationCaseModel item) {
    return Container(
      width: 290,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: item.color.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item.cardImage,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                width: double.infinity,
                color: item.color.withOpacity(0.10),
                alignment: Alignment.center,
                child: Icon(item.icon, color: item.color, size: 34),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16324A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.complaint,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.1,
              color: Color(0xFF52606D),
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _softTag(item.urgency, _urgencyColor(item.urgency)),
              _softTag(item.difficulty, _difficultyColor(item.difficulty)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProgressiveCaseSimulationScreen(caseData: item),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: item.color,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Open Case",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseTriageCard(BuildContext context, SimulationCaseModel item) {
    final urgencyColor = _urgencyColor(item.urgency);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: item.color.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              item.cardImage,
              height: 138,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 138,
                width: double.infinity,
                color: item.color.withOpacity(0.10),
                alignment: Alignment.center,
                child: Icon(item.icon, color: item.color, size: 36),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(item.icon, color: item.color, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF16324A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${item.patientName} • ${item.age} y/o ${item.gender}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF61758A),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 12.7,
                    color: Color(0xFF61758A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item.complaint,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF52606D),
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _softTag(
                      item.difficulty,
                      _difficultyColor(item.difficulty),
                      icon: Icons.school_rounded,
                    ),
                    _softTag(
                      "Urgency: ${item.urgency}",
                      urgencyColor,
                      icon: Icons.priority_high_rounded,
                    ),
                    _softTag(
                      "${item.estimatedMinutes} min",
                      const Color(0xFF0F766E),
                      icon: Icons.schedule_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Primary learning goals",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF334155),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...item.learningGoals.take(2).map(
                            (goal) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 16,
                                    color: item.color,
                                  ),
                                  const SizedBox(width: 7),
                                  Expanded(
                                    child: Text(
                                      goal,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF52606D),
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags
                      .take(3)
                      .map((e) => _softTag(e, const Color(0xFF64748B)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProgressiveCaseSimulationScreen(caseData: item),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item.color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    label: const Text(
                      "Start Simulation",
                      style: TextStyle(fontWeight: FontWeight.w800),
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

  Widget _buildClinicalWorkflowBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Clinical Learning Workflow",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF16324A),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Each case follows a structured medical reasoning sequence so the student learns how to think safely and systematically, not just how to guess.",
            style: TextStyle(
              fontSize: 13.5,
              color: Color(0xFF61758A),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _WorkflowPill(
                icon: Icons.emergency_outlined,
                title: "Triage",
                subtitle: "Assess urgency level",
              ),
              _WorkflowPill(
                icon: Icons.visibility_outlined,
                title: "Impression",
                subtitle: "Form initial view",
              ),
              _WorkflowPill(
                icon: Icons.biotech_outlined,
                title: "Diagnosis",
                subtitle: "Select likely condition",
              ),
              _WorkflowPill(
                icon: Icons.medication_liquid_outlined,
                title: "First Action",
                subtitle: "Choose safe escalation",
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 1160;
    final bool isTablet = width > 760;
    final int gridCount = width > 1380 ? 3 : (width > 860 ? 2 : 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FC),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF16324A)),
        title: const Text(
          "Simulation Case Bank",
          style: TextStyle(
            color: Color(0xFF16324A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 30 : 18,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommandCenterHeader(),
            const SizedBox(height: 20),
            if (isTablet)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      title: "Total Cases",
                      value: "${allCases.length}",
                      subtitle: "Available simulations",
                      icon: Icons.folder_copy_rounded,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricTile(
                      title: "Critical",
                      value: "$criticalCasesCount",
                      subtitle: "Immediate high-acuity cases",
                      icon: Icons.emergency_rounded,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildMetricTile(
                      title: "Advanced",
                      value: "$advancedCasesCount",
                      subtitle: "Deeper reasoning load",
                      icon: Icons.psychology_alt_rounded,
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  _buildMetricTile(
                    title: "Total Cases",
                    value: "${allCases.length}",
                    subtitle: "Available simulations",
                    icon: Icons.folder_copy_rounded,
                    color: const Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 12),
                  _buildMetricTile(
                    title: "Critical",
                    value: "$criticalCasesCount",
                    subtitle: "Immediate high-acuity cases",
                    icon: Icons.emergency_rounded,
                    color: const Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 12),
                  _buildMetricTile(
                    title: "Advanced",
                    value: "$advancedCasesCount",
                    subtitle: "Deeper reasoning load",
                    icon: Icons.psychology_alt_rounded,
                    color: const Color(0xFF7C3AED),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            _buildClinicalWorkflowBox(),
            const SizedBox(height: 20),
            _buildAiZone(context),
            const SizedBox(height: 20),
            _buildRecommendedCasePanel(context),
            const SizedBox(height: 24),
            _buildSectionTitle(
              "Case Discovery",
              "Search and filter the simulation bank to build a clinically meaningful learning path.",
            ),
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 14),
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16324A),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categoryFilters.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _filterChip(
                      label: f,
                      isSelected: selectedCategoryFilter == f,
                      onTap: () => setState(() => selectedCategoryFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Difficulty",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16324A),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: difficultyFilters.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _filterChip(
                      label: f,
                      isSelected: selectedDifficultyFilter == f,
                      onTap: () => setState(() => selectedDifficultyFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "Urgency",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF16324A),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: urgencyFilters.map((f) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _filterChip(
                      label: f,
                      isSelected: selectedUrgencyFilter == f,
                      onTap: () => setState(() => selectedUrgencyFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              "Priority Learning Cases",
              "These scenarios are highlighted because they represent high-yield patterns for clinical reasoning and escalation.",
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 395,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredCases.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedStripCard(context, featuredCases[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Case Triage Board",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16324A),
                    ),
                  ),
                ),
                Text(
                  "${filteredCases.length} cases",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF61758A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Open any case and move through the sequence: urgency assessment, clinical impression, diagnosis, then safe first action.",
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF61758A),
              ),
            ),
            const SizedBox(height: 18),
            if (filteredCases.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 42,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No matching cases found",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF16324A),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Try changing the search text or filters to reveal more clinical simulations.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF61758A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                itemCount: filteredCases.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop ? 0.78 : 0.76,
                ),
                itemBuilder: (context, index) {
                  return _buildCaseTriageCard(context, filteredCases[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _WorkflowPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WorkflowPill({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.local_hospital_outlined,
              color: Color(0xFF0F4C75),
              size: 0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: const Color(0xFF0F4C75)),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF16324A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF61758A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}