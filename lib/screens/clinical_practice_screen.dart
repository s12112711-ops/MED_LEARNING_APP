import 'package:flutter/material.dart';
import '../services/clinical_result_service.dart';
import 'clinical_history_screen.dart';

class ClinicalCase {
  final String title;
  final String difficulty;
  final String urgency;
  final Color color;
  final IconData icon;

  final String patientName;
  final int age;
  final String gender;
  final String complaint;
  final String history;
  final String ecgClue;
  final String hint;
  final String redFlag;
  final String likelyComplication;

  final List<String> learningGoals;
  final List<String> symptoms;
  final List<String> physicalExam;
  final Map<String, String> vitals;

  final List<String> diagnosisOptions;
  final int correctDiagnosisIndex;

  final List<String> investigationOptions;
  final List<int> correctInvestigations;

  final List<String> firstActionOptions;
  final int correctFirstActionIndex;

  final String explanation;
  final String clinicalPearl;

  const ClinicalCase({
    required this.title,
    required this.difficulty,
    required this.urgency,
    required this.color,
    required this.icon,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.complaint,
    required this.history,
    required this.ecgClue,
    required this.hint,
    required this.redFlag,
    required this.likelyComplication,
    required this.learningGoals,
    required this.symptoms,
    required this.physicalExam,
    required this.vitals,
    required this.diagnosisOptions,
    required this.correctDiagnosisIndex,
    required this.investigationOptions,
    required this.correctInvestigations,
    required this.firstActionOptions,
    required this.correctFirstActionIndex,
    required this.explanation,
    required this.clinicalPearl,
  });
}

class ClinicalPracticeScreen extends StatefulWidget {
  const ClinicalPracticeScreen({super.key});

  @override
  State<ClinicalPracticeScreen> createState() => _ClinicalPracticeScreenState();
}

class _ClinicalPracticeScreenState extends State<ClinicalPracticeScreen> {
  final List<ClinicalCase> cases = const [
    ClinicalCase(
      title: "Chest Pain Assessment",
      difficulty: "Intermediate",
      urgency: "High",
      color: Color(0xFFE57373),
      icon: Icons.favorite_rounded,
      patientName: "Patient A",
      age: 58,
      gender: "Male",
      complaint: "Central chest pain for 40 minutes",
      history:
          "Known smoker with hypertension and diabetes. Pain started at rest and radiates to the left arm.",
      ecgClue: "Look for ischemic ST-T changes or acute coronary pattern.",
      hint: "Pain at rest + radiation + sweating should never be treated as simple benign pain.",
      redFlag: "Persistent chest pain with diaphoresis and low blood pressure.",
      likelyComplication: "Acute myocardial infarction or cardiogenic instability.",
      learningGoals: [
        "Recognize acute coronary syndrome pattern",
        "Choose urgent cardiac investigations",
        "Identify the safest first clinical step",
      ],
      symptoms: [
        "Chest pressure",
        "Sweating",
        "Shortness of breath",
        "Nausea",
      ],
      physicalExam: [
        "Patient appears anxious",
        "Cool extremities",
        "Mild diaphoresis",
      ],
      vitals: {
        "BP": "96/62 mmHg",
        "HR": "112 bpm",
        "RR": "24 /min",
        "SpO2": "93%",
      },
      diagnosisOptions: [
        "Stable angina",
        "Acute coronary syndrome",
        "Heart failure",
        "Benign arrhythmia",
      ],
      correctDiagnosisIndex: 1,
      investigationOptions: [
        "12-lead ECG",
        "Cardiac troponin",
        "Lipid profile",
        "Chest X-ray",
        "Coronary angiography preparation",
      ],
      correctInvestigations: [0, 1, 4],
      firstActionOptions: [
        "Send patient home with reassurance",
        "Urgent cardiac assessment and monitoring",
        "Advise hydration only",
        "Schedule routine follow-up after one month",
      ],
      correctFirstActionIndex: 1,
      explanation:
          "This presentation strongly suggests acute coronary syndrome because of prolonged chest pain, radiation, autonomic symptoms, and hemodynamic concern.",
      clinicalPearl:
          "Chest pain at rest with sweating and radiation should always raise concern for acute coronary syndrome.",
    ),
    ClinicalCase(
      title: "Dyspnea and Leg Swelling",
      difficulty: "Intermediate",
      urgency: "Moderate",
      color: Color(0xFF42A5F5),
      icon: Icons.air_rounded,
      patientName: "Patient B",
      age: 67,
      gender: "Female",
      complaint: "Progressive shortness of breath and ankle swelling",
      history:
          "History of hypertension and previous ischemic heart disease. Sleeps on 3 pillows and reports reduced exercise tolerance.",
      ecgClue: "ECG may show ischemic change, prior infarction, or strain pattern.",
      hint: "Think of congestion when orthopnea, edema, and crackles appear together.",
      redFlag: "Reduced oxygen saturation with congestion signs.",
      likelyComplication: "Decompensated heart failure and pulmonary edema.",
      learningGoals: [
        "Link symptoms to congestive heart failure",
        "Select core heart failure investigations",
        "Prioritize oxygenation and decompensation assessment",
      ],
      symptoms: [
        "Dyspnea on exertion",
        "Orthopnea",
        "Fatigue",
        "Peripheral edema",
      ],
      physicalExam: [
        "Bilateral pitting edema",
        "Basal crackles",
        "Mild jugular venous distension",
      ],
      vitals: {
        "BP": "138/84 mmHg",
        "HR": "104 bpm",
        "RR": "22 /min",
        "SpO2": "92%",
      },
      diagnosisOptions: [
        "Heart failure exacerbation",
        "Simple viral illness",
        "Hypertension only",
        "Mild dehydration",
      ],
      correctDiagnosisIndex: 0,
      investigationOptions: [
        "Echocardiography",
        "BNP or NT-proBNP",
        "Chest X-ray",
        "ECG",
        "Skin allergy testing",
      ],
      correctInvestigations: [0, 1, 2, 3],
      firstActionOptions: [
        "Ignore edema and treat as gastritis",
        "Assess for decompensated heart failure and oxygenation",
        "Discharge immediately",
        "Only give vitamins",
      ],
      correctFirstActionIndex: 1,
      explanation:
          "The combination of orthopnea, edema, crackles, and reduced oxygen saturation strongly supports heart failure with congestion.",
      clinicalPearl:
          "Orthopnea + edema + crackles is a classic heart failure pattern until proven otherwise.",
    ),
    ClinicalCase(
      title: "Palpitations with Dizziness",
      difficulty: "Advanced",
      urgency: "Critical",
      color: Color(0xFF8B78E6),
      icon: Icons.timeline_rounded,
      patientName: "Patient C",
      age: 49,
      gender: "Male",
      complaint: "Sudden palpitations and dizziness",
      history:
          "Episodes started this morning. No trauma. Has prior ischemic heart disease and poor sleep.",
      ecgClue: "Rapid rhythm with hemodynamic effect should be considered unstable until proven otherwise.",
      hint: "Low blood pressure + tachycardia + dizziness = urgent rhythm concern.",
      redFlag: "Hemodynamic instability due to tachyarrhythmia.",
      likelyComplication: "Syncope, reduced perfusion, or sudden deterioration.",
      learningGoals: [
        "Recognize unstable arrhythmia pattern",
        "Choose urgent rhythm investigations",
        "Prioritize immediate stabilization pathway",
      ],
      symptoms: [
        "Rapid heartbeat",
        "Dizziness",
        "Weakness",
        "Mild chest discomfort",
      ],
      physicalExam: [
        "Irregular pulse",
        "Patient looks uncomfortable",
        "No focal neurological deficit",
      ],
      vitals: {
        "BP": "90/58 mmHg",
        "HR": "154 bpm",
        "RR": "21 /min",
        "SpO2": "95%",
      },
      diagnosisOptions: [
        "Hemodynamically significant arrhythmia",
        "Uncomplicated hypertension",
        "Simple tension headache",
        "Stable sinus bradycardia",
      ],
      correctDiagnosisIndex: 0,
      investigationOptions: [
        "Immediate ECG",
        "Continuous cardiac monitoring",
        "Electrolytes",
        "Thyroid profile",
        "Urinalysis only",
      ],
      correctInvestigations: [0, 1, 2, 3],
      firstActionOptions: [
        "Urgent rhythm assessment because patient may be unstable",
        "Tell patient to rest for a week with no assessment",
        "Treat as skin rash",
        "No intervention needed",
      ],
      correctFirstActionIndex: 0,
      explanation:
          "Rapid pulse with low blood pressure and dizziness suggests a clinically important arrhythmia with possible hemodynamic instability.",
      clinicalPearl:
          "Any fast rhythm with hypotension or syncope should be treated as urgent.",
    ),
  ];

  int currentCaseIndex = 0;

  int? selectedDiagnosis;
  int? selectedFirstAction;
  List<int> selectedInvestigations = [];

  bool submitted = false;
  bool isSaving = false;
  bool showHint = false;
  bool showEcgClue = false;
  String studentName = "Amal";

  ClinicalCase get currentCase => cases[currentCaseIndex];

  double get overallProgress => (currentCaseIndex + 1) / cases.length;

  int get completionCount {
    int count = 0;
    if (selectedDiagnosis != null) count++;
    if (selectedInvestigations.isNotEmpty) count++;
    if (selectedFirstAction != null) count++;
    return count;
  }

  void _toggleInvestigation(int index) {
    if (submitted) return;

    setState(() {
      if (selectedInvestigations.contains(index)) {
        selectedInvestigations.remove(index);
      } else {
        selectedInvestigations.add(index);
      }
    });
  }

  int _calculateScore() {
    int score = 0;

    if (selectedDiagnosis == currentCase.correctDiagnosisIndex) {
      score += 40;
    }

    if (selectedFirstAction == currentCase.correctFirstActionIndex) {
      score += 30;
    }

    int correctSelected = 0;
    for (final i in selectedInvestigations) {
      if (currentCase.correctInvestigations.contains(i)) {
        correctSelected++;
      }
    }

    int wrongSelected = 0;
    for (final i in selectedInvestigations) {
      if (!currentCase.correctInvestigations.contains(i)) {
        wrongSelected++;
      }
    }

    int investigationScore = (correctSelected * 10) - (wrongSelected * 5);
    if (investigationScore < 0) investigationScore = 0;
    if (investigationScore > 30) investigationScore = 30;

    score += investigationScore;
    return score;
  }

  String _performanceLabel(int score) {
    if (score >= 85) return "Excellent";
    if (score >= 65) return "Good";
    if (score >= 40) return "Needs Improvement";
    return "Weak";
  }

  Color _performanceColor(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 65) return Colors.blue;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  Color _urgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case "critical":
        return Colors.red;
      case "high":
        return Colors.deepOrange;
      case "moderate":
        return Colors.amber.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> _submitCase() async {
    if (selectedDiagnosis == null || selectedFirstAction == null) return;

    setState(() {
      submitted = true;
      isSaving = true;
    });

    try {
      final score = _calculateScore();
      final performance = _performanceLabel(score);

      await ClinicalResultService.saveResult(
        studentName: studentName,
        caseTitle: currentCase.title,
        diagnosisSelected: currentCase.diagnosisOptions[selectedDiagnosis!],
        firstActionSelected: currentCase.firstActionOptions[selectedFirstAction!],
        selectedInvestigations: selectedInvestigations
            .map((i) => currentCase.investigationOptions[i])
            .toList(),
        score: score,
        performanceLabel: performance,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Clinical result saved successfully"),
        ),
      );
    } catch (e) {
      debugPrint('Save clinical result error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Save failed: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        isSaving = false;
      });
    }
  }

  void _nextCase() {
    if (currentCaseIndex < cases.length - 1) {
      setState(() {
        currentCaseIndex++;
        selectedDiagnosis = null;
        selectedFirstAction = null;
        selectedInvestigations = [];
        submitted = false;
        showHint = false;
        showEcgClue = false;
      });
    }
  }

  void _resetCurrentCase() {
    setState(() {
      selectedDiagnosis = null;
      selectedFirstAction = null;
      selectedInvestigations = [];
      submitted = false;
      showHint = false;
      showEcgClue = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = currentCase;
    final score = _calculateScore();
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 900;

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
          "Clinical Practice",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF14314B),
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Clinical History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClinicalHistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(isDark, c),
            const SizedBox(height: 18),
            _buildDashboardRow(isDark, c),
            const SizedBox(height: 18),
            _buildCaseSelector(isDark),
            const SizedBox(height: 18),
            _buildLearningGoalsCard(isDark, c),
            const SizedBox(height: 18),
            _buildPatientOverview(isDark, c),
            const SizedBox(height: 18),
            _buildVitalsCard(isDark, c),
            const SizedBox(height: 18),
            _buildCluePanel(isDark, c),
            const SizedBox(height: 18),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSymptomsCard(isDark, c)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildExamCard(isDark, c)),
                ],
              )
            else
              Column(
                children: [
                  _buildSymptomsCard(isDark, c),
                  const SizedBox(height: 12),
                  _buildExamCard(isDark, c),
                ],
              ),
            const SizedBox(height: 18),
            _buildDiagnosisSection(isDark, c),
            const SizedBox(height: 18),
            _buildInvestigationsSection(isDark, c),
            const SizedBox(height: 18),
            _buildFirstActionSection(isDark, c),
            const SizedBox(height: 18),
            _buildActionButtons(),
            if (submitted) ...[
              const SizedBox(height: 18),
              _buildResultCard(isDark, c, score),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(bool isDark, ClinicalCase c) {
    final urgencyColor = _urgencyColor(c.urgency);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
            color: const Color(0xFF0F3D63).withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(
                  c.icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Cardiology Clinical Simulator",
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
            "Train like a real medical learner: assess the case, analyze the signs, choose the most likely diagnosis, request the right investigations, and make the first clinical decision.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip(Icons.medical_services_rounded, c.title),
              _heroChip(Icons.bolt_rounded, c.difficulty),
              _heroChip(Icons.touch_app_rounded, "Interactive Training"),
              _heroChip(Icons.school_rounded, "Clinical Reasoning"),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.white, size: 15),
                    const SizedBox(width: 7),
                    Text(
                      "Urgency: ${c.urgency}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardRow(bool isDark, ClinicalCase c) {
    return Row(
      children: [
        Expanded(
          child: _miniStatCard(
            isDark,
            "Case",
            "${currentCaseIndex + 1}/${cases.length}",
            Icons.folder_open_rounded,
            c.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _miniStatCard(
            isDark,
            "Completed Steps",
            "$completionCount/3",
            Icons.checklist_rounded,
            const Color(0xFF26A69A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _miniStatCard(
            isDark,
            "Progress",
            "${(overallProgress * 100).toInt()}%",
            Icons.auto_graph_rounded,
            const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _miniStatCard(
    bool isDark,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseSelector(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(cases.length, (index) {
          final active = currentCaseIndex == index;
          final item = cases[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                currentCaseIndex = index;
                selectedDiagnosis = null;
                selectedFirstAction = null;
                selectedInvestigations = [];
                submitted = false;
                showHint = false;
                showEcgClue = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: active
                    ? item.color
                    : (isDark ? const Color(0xFF111827) : Colors.white),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: active
                      ? item.color
                      : (isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFDDE6EF)),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 18,
                    color: active
                        ? Colors.white
                        : (isDark ? Colors.white70 : item.color),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Case ${index + 1}",
                    style: TextStyle(
                      color: active
                          ? Colors.white
                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLearningGoalsCard(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Case Objectives",
            Icons.flag_rounded,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 12),
          ...c.learningGoals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF26A69A),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      goal,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF334155),
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
    );
  }

  Widget _buildPatientOverview(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Patient Overview",
            Icons.person_pin_circle_rounded,
            c.color,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${c.patientName} • ${c.age} y/o • ${c.gender}",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontWeight: FontWeight.w800,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Chief complaint: ${c.complaint}",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  c.history,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF475569),
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "Red Flag: ${c.redFlag}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
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

  Widget _buildVitalsCard(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Vital Signs",
            Icons.monitor_heart_rounded,
            const Color(0xFFE35D6A),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: c.vitals.entries.map((e) {
              return Container(
                width: 150,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF1F2937)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      e.value,
                      style: TextStyle(
                        color: isDark ? Colors.white : c.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCluePanel(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Interactive Clinical Clues",
            Icons.lightbulb_rounded,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      showHint = !showHint;
                    });
                  },
                  icon: const Icon(Icons.tips_and_updates_rounded),
                  label: Text(showHint ? "Hide Hint" : "Reveal Hint"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      showEcgClue = !showEcgClue;
                    });
                  },
                  icon: const Icon(Icons.graphic_eq_rounded),
                  label: Text(showEcgClue ? "Hide ECG Clue" : "Reveal ECG Clue"),
                ),
              ),
            ],
          ),
          if (showHint) ...[
            const SizedBox(height: 12),
            _infoBanner(
              color: const Color(0xFFF59E0B),
              text: c.hint,
            ),
          ],
          if (showEcgClue) ...[
            const SizedBox(height: 12),
            _infoBanner(
              color: const Color(0xFF8B5CF6),
              text: c.ecgClue,
            ),
          ],
          const SizedBox(height: 12),
          _infoBanner(
            color: const Color(0xFFEF4444),
            text: "Possible complication: ${c.likelyComplication}",
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard(bool isDark, ClinicalCase c) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Symptoms",
            Icons.sick_rounded,
            const Color(0xFFE57373),
          ),
          const SizedBox(height: 12),
          ...c.symptoms.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFE57373)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF334155),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(bool isDark, ClinicalCase c) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Physical Exam",
            Icons.medical_information_rounded,
            const Color(0xFF4A90E2),
          ),
          const SizedBox(height: 12),
          ...c.physicalExam.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFF4A90E2)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF334155),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisSection(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Step 1: Most Likely Diagnosis",
            Icons.psychology_alt_rounded,
            c.color,
          ),
          const SizedBox(height: 14),
          ...List.generate(c.diagnosisOptions.length, (index) {
            final isSelected = selectedDiagnosis == index;
            final isCorrect = c.correctDiagnosisIndex == index;
            final isWrongSelected = submitted && isSelected && !isCorrect;

            Color borderColor;
            Color fillColor;

            if (submitted && isCorrect) {
              borderColor = Colors.green;
              fillColor = Colors.green.withOpacity(0.10);
            } else if (isWrongSelected) {
              borderColor = Colors.red;
              fillColor = Colors.red.withOpacity(0.10);
            } else if (isSelected) {
              borderColor = c.color;
              fillColor = c.color.withOpacity(0.10);
            } else {
              borderColor =
                  isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
              fillColor =
                  isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: submitted
                    ? null
                    : () {
                        setState(() {
                          selectedDiagnosis = index;
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.diagnosisOptions[index],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF102033),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (submitted && isCorrect)
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.green),
                      if (isWrongSelected)
                        const Icon(Icons.cancel_rounded, color: Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInvestigationsSection(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Step 2: Choose Investigations",
            Icons.biotech_rounded,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 8),
          Text(
            "Select the most appropriate tests for this case.",
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(c.investigationOptions.length, (index) {
            final isSelected = selectedInvestigations.contains(index);
            final isCorrect = c.correctInvestigations.contains(index);

            Color borderColor;
            Color fillColor;

            if (submitted && isCorrect) {
              borderColor = Colors.green;
              fillColor = Colors.green.withOpacity(0.10);
            } else if (submitted && isSelected && !isCorrect) {
              borderColor = Colors.red;
              fillColor = Colors.red.withOpacity(0.10);
            } else if (isSelected) {
              borderColor = const Color(0xFF26A69A);
              fillColor = const Color(0xFF26A69A).withOpacity(0.10);
            } else {
              borderColor =
                  isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
              fillColor =
                  isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _toggleInvestigation(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        color: isSelected
                            ? const Color(0xFF26A69A)
                            : const Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          c.investigationOptions[index],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF102033),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFirstActionSection(bool isDark, ClinicalCase c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Step 3: First Clinical Action",
            Icons.local_hospital_rounded,
            const Color(0xFFF4A641),
          ),
          const SizedBox(height: 14),
          ...List.generate(c.firstActionOptions.length, (index) {
            final isSelected = selectedFirstAction == index;
            final isCorrect = c.correctFirstActionIndex == index;
            final isWrongSelected = submitted && isSelected && !isCorrect;

            Color borderColor;
            Color fillColor;

            if (submitted && isCorrect) {
              borderColor = Colors.green;
              fillColor = Colors.green.withOpacity(0.10);
            } else if (isWrongSelected) {
              borderColor = Colors.red;
              fillColor = Colors.red.withOpacity(0.10);
            } else if (isSelected) {
              borderColor = const Color(0xFFF4A641);
              fillColor = const Color(0xFFF4A641).withOpacity(0.10);
            } else {
              borderColor =
                  isDark ? const Color(0xFF1F2937) : const Color(0xFFE2E8F0);
              fillColor =
                  isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: submitted
                    ? null
                    : () {
                        setState(() {
                          selectedFirstAction = index;
                        });
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.firstActionOptions[index],
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF102033),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (submitted && isCorrect)
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.green),
                      if (isWrongSelected)
                        const Icon(Icons.cancel_rounded, color: Colors.red),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canSubmit =
        selectedDiagnosis != null && selectedFirstAction != null && !submitted;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _resetCurrentCase,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text("Reset Case"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: canSubmit ? _submitCase : null,
            icon: const Icon(Icons.task_alt_rounded),
            label: const Text("Submit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14314B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDark, ClinicalCase c, int score) {
    final resultColor = _performanceColor(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            isDark,
            "Clinical Feedback",
            Icons.insights_rounded,
            resultColor,
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: resultColor.withOpacity(0.15),
                  child: Icon(Icons.emoji_events_rounded, color: resultColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Score: $score / 100",
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF102033),
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _performanceLabel(score),
                        style: TextStyle(
                          color: resultColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSaving) ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text("Saving result to database..."),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(
            "Case Explanation",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            c.explanation,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _infoBanner(
            color: const Color(0xFF8B5CF6),
            text: c.clinicalPearl,
            title: "Clinical Pearl",
          ),
          const SizedBox(height: 12),
          _infoBanner(
            color: const Color(0xFFEF4444),
            text: c.likelyComplication,
            title: "Most Dangerous Possible Complication",
          ),
          const SizedBox(height: 16),
          if (currentCaseIndex < cases.length - 1)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _nextCase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text("Next Case"),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.10),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                "You completed all clinical practice cases. Great job.",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _heroChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBanner({
    required Color color,
    required String text,
    String? title,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    bool isDark,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF111827) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: isDark ? const Color(0xFF1F2937) : const Color(0xFFDDE6EF),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}