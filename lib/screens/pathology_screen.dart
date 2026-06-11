import 'package:flutter/material.dart';
import '../services/fake_ai_service.dart';

enum PathologyTab {
  hypertension,
  coronaryArteryDisease,
  heartFailure,
  arrhythmia,
}

enum SeverityLevel {
  mild,
  moderate,
  severe,
}

class PathologyCase {
  final String title;
  final String subtitle;
  final String description;
  final String clinicalMeaning;
  final IconData icon;
  final Color color;
  final List<String> symptoms;
  final List<String> riskFactors;
  final List<String> keyFindings;
  final List<String> investigations;
  final List<String> redFlags;
  final List<String> managementPriorities;

  const PathologyCase({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.clinicalMeaning,
    required this.icon,
    required this.color,
    required this.symptoms,
    required this.riskFactors,
    required this.keyFindings,
    required this.investigations,
    required this.redFlags,
    required this.managementPriorities,
  });
}

class PathologyQuestion {
  final String question;
  final List<String> answers;
  final int correctIndex;

  const PathologyQuestion({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}

class PatientScenario {
  final String patientName;
  final int age;
  final String sex;
  final String chiefComplaint;
  final String history;
  final Map<String, String> vitals;
  final Map<String, String> diagnostics;
  final String severityNote;

  const PatientScenario({
    required this.patientName,
    required this.age,
    required this.sex,
    required this.chiefComplaint,
    required this.history,
    required this.vitals,
    required this.diagnostics,
    required this.severityNote,
  });
}

class PathologyScreen extends StatefulWidget {
  const PathologyScreen({super.key});

  @override
  State<PathologyScreen> createState() => _PathologyScreenState();
}

class _PathologyScreenState extends State<PathologyScreen> {
  PathologyTab selectedTab = PathologyTab.hypertension;
  SeverityLevel severity = SeverityLevel.moderate;

  bool isAiLoading = false;
  String aiResultTitle = "MediLearn Pathology Assistant";
  String aiResult =
      "Use the smart tools below to simplify pathology concepts, generate summary notes, produce practice questions, or explain clinical meaning.";
  Color aiAccentColor = const Color(0xFF8B5CF6);

  int quizIndex = 0;
  bool quizSubmitted = false;
  List<int?> selectedAnswers = List<int?>.filled(pathologyQuiz.length, null);

  final Map<PathologyTab, PathologyCase> cases = const {
    PathologyTab.hypertension: PathologyCase(
      title: "Hypertension",
      subtitle: "Persistent elevation of arterial blood pressure",
      description:
          "Hypertension is a chronic cardiovascular disorder characterized by sustained elevation of systemic arterial pressure. Over time, this increases left ventricular workload, damages vascular endothelium, and contributes to progressive target-organ injury.",
      clinicalMeaning:
          "It is one of the most important silent cardiovascular risk factors. Long-term uncontrolled hypertension can lead to stroke, left ventricular hypertrophy, chronic kidney disease, retinopathy, and heart failure.",
      icon: Icons.monitor_heart_rounded,
      color: Color(0xFFE57373),
      symptoms: [
        "Often asymptomatic",
        "Headache",
        "Dizziness",
        "Blurry vision in severe cases",
        "Occasional chest discomfort",
      ],
      riskFactors: [
        "Obesity",
        "High salt intake",
        "Family history",
        "Sedentary lifestyle",
        "Smoking",
      ],
      keyFindings: [
        "Elevated systemic blood pressure",
        "Progressive vascular damage",
        "Left ventricular strain",
      ],
      investigations: [
        "Repeated BP measurements",
        "ECG for LVH screening",
        "Renal function tests",
        "Urinalysis",
        "Fundoscopy if severe",
      ],
      redFlags: [
        "Very high BP with neurological symptoms",
        "Acute chest pain",
        "Shortness of breath",
        "Visual loss",
      ],
      managementPriorities: [
        "Control blood pressure",
        "Reduce salt intake",
        "Lifestyle modification",
        "Medication adherence",
      ],
    ),
    PathologyTab.coronaryArteryDisease: PathologyCase(
      title: "Coronary Artery Disease",
      subtitle: "Reduced blood flow to the myocardium",
      description:
          "Coronary artery disease develops when atherosclerotic plaques narrow the coronary arteries, reducing blood flow and oxygen delivery to the myocardium. Clinical presentation ranges from stable angina to acute coronary syndrome.",
      clinicalMeaning:
          "This condition is central to ischemic heart disease and may progress to myocardial infarction, arrhythmia, impaired ventricular function, or sudden cardiac complications.",
      icon: Icons.favorite_border_rounded,
      color: Color(0xFFFFA726),
      symptoms: [
        "Chest pain or pressure",
        "Pain on exertion",
        "Shortness of breath",
        "Fatigue",
        "Sweating in acute events",
      ],
      riskFactors: [
        "Smoking",
        "Hyperlipidemia",
        "Diabetes mellitus",
        "Hypertension",
        "Family history",
      ],
      keyFindings: [
        "Myocardial ischemia",
        "Reduced coronary perfusion",
        "Risk of infarction",
      ],
      investigations: [
        "ECG",
        "Troponin if acute symptoms",
        "Lipid profile",
        "Stress testing",
        "Coronary angiography",
      ],
      redFlags: [
        "Persistent chest pain at rest",
        "Rising troponin",
        "ST-segment changes",
        "Hemodynamic instability",
      ],
      managementPriorities: [
        "Relieve ischemia",
        "Control risk factors",
        "Antiplatelet therapy when indicated",
        "Urgent assessment in acute chest pain",
      ],
    ),
    PathologyTab.heartFailure: PathologyCase(
      title: "Heart Failure",
      subtitle: "Impaired pumping ability of the heart",
      description:
          "Heart failure is a clinical syndrome in which the heart fails to pump sufficient blood to meet metabolic demands or can do so only with elevated filling pressures. It may involve systolic dysfunction, diastolic dysfunction, or both.",
      clinicalMeaning:
          "Patients often experience pulmonary congestion, peripheral edema, reduced exercise tolerance, and fatigue. Advanced cases can lead to organ hypoperfusion and repeated hospital admissions.",
      icon: Icons.water_drop_rounded,
      color: Color(0xFF42A5F5),
      symptoms: [
        "Dyspnea",
        "Orthopnea",
        "Peripheral edema",
        "Fatigue",
        "Reduced exercise tolerance",
      ],
      riskFactors: [
        "Coronary artery disease",
        "Hypertension",
        "Valve disease",
        "Cardiomyopathy",
        "Previous myocardial injury",
      ],
      keyFindings: [
        "Reduced cardiac output",
        "Pulmonary or systemic congestion",
        "Fluid retention",
      ],
      investigations: [
        "Echocardiography",
        "BNP/NT-proBNP",
        "Chest X-ray",
        "ECG",
        "Renal and electrolyte profile",
      ],
      redFlags: [
        "Severe respiratory distress",
        "Rapidly worsening edema",
        "Low oxygen saturation",
        "Hypotension",
      ],
      managementPriorities: [
        "Reduce fluid overload",
        "Improve cardiac output",
        "Monitor oxygenation",
        "Long-term medication optimization",
      ],
    ),
    PathologyTab.arrhythmia: PathologyCase(
      title: "Arrhythmia",
      subtitle: "Abnormal heart rhythm or conduction",
      description:
          "Arrhythmia includes disorders of impulse generation or conduction that produce an abnormal heart rhythm. Rhythms may be tachyarrhythmias, bradyarrhythmias, or irregular conduction patterns.",
      clinicalMeaning:
          "Some arrhythmias are benign, while others reduce cardiac output, provoke syncope, worsen heart failure, or increase the risk of embolic or sudden cardiac events.",
      icon: Icons.timeline_rounded,
      color: Color(0xFF8B78E6),
      symptoms: [
        "Palpitations",
        "Dizziness",
        "Syncope",
        "Irregular pulse",
        "Chest discomfort",
      ],
      riskFactors: [
        "Electrolyte imbalance",
        "Ischemic heart disease",
        "Drug effects",
        "Structural heart disease",
        "Thyroid dysfunction",
      ],
      keyFindings: [
        "Abnormal rhythm generation",
        "Irregular electrical conduction",
        "Variable hemodynamic impact",
      ],
      investigations: [
        "12-lead ECG",
        "Holter monitoring",
        "Electrolyte testing",
        "Echocardiography",
        "Thyroid profile",
      ],
      redFlags: [
        "Syncope",
        "Very rapid or very slow pulse",
        "Chest pain",
        "Hypotension",
      ],
      managementPriorities: [
        "Identify rhythm type",
        "Assess hemodynamic stability",
        "Correct reversible causes",
        "Urgent intervention if unstable",
      ],
    ),
  };

  PathologyCase get currentCase => cases[selectedTab]!;

  double get severityValue {
    switch (severity) {
      case SeverityLevel.mild:
        return 0.33;
      case SeverityLevel.moderate:
        return 0.66;
      case SeverityLevel.severe:
        return 1.0;
    }
  }

  String get severityLabel {
    switch (severity) {
      case SeverityLevel.mild:
        return "Mild";
      case SeverityLevel.moderate:
        return "Moderate";
      case SeverityLevel.severe:
        return "Severe";
    }
  }

  String get severityInterpretation {
    switch (severity) {
      case SeverityLevel.mild:
        return "Early or controlled state with limited physiological impact.";
      case SeverityLevel.moderate:
        return "Clear pathological effect with noticeable clinical significance.";
      case SeverityLevel.severe:
        return "High clinical risk with strong functional and systemic impact.";
    }
  }

  PatientScenario get currentScenario {
    switch (selectedTab) {
      case PathologyTab.hypertension:
        if (severity == SeverityLevel.mild) {
          return const PatientScenario(
            patientName: "Patient A",
            age: 47,
            sex: "Female",
            chiefComplaint: "Headache during the last two weeks",
            history:
                "Known sedentary lifestyle with frequent salty meals and positive family history of hypertension.",
            vitals: {
              "BP": "146/92 mmHg",
              "HR": "82 bpm",
              "RR": "16 /min",
              "SpO2": "98%",
            },
            diagnostics: {
              "ECG": "Possible mild LV strain pattern",
              "Creatinine": "Normal",
              "Urine": "No major abnormality",
              "Fundoscopy": "No acute changes",
            },
            severityNote:
                "This patient demonstrates early but clinically relevant hypertension.",
          );
        } else if (severity == SeverityLevel.moderate) {
          return const PatientScenario(
            patientName: "Patient B",
            age: 56,
            sex: "Male",
            chiefComplaint: "Headache, dizziness, and occasional blurry vision",
            history:
                "History of obesity, poor exercise tolerance, and high dietary sodium intake.",
            vitals: {
              "BP": "168/102 mmHg",
              "HR": "88 bpm",
              "RR": "18 /min",
              "SpO2": "97%",
            },
            diagnostics: {
              "ECG": "Left ventricular hypertrophy changes",
              "Creatinine": "Slightly elevated",
              "Urine": "Trace protein",
              "Fundoscopy": "Mild hypertensive changes",
            },
            severityNote:
                "This level suggests established disease with target-organ stress.",
          );
        } else {
          return const PatientScenario(
            patientName: "Patient C",
            age: 63,
            sex: "Female",
            chiefComplaint: "Severe headache with chest discomfort and visual disturbance",
            history:
                "Longstanding untreated hypertension with poor medication adherence.",
            vitals: {
              "BP": "198/118 mmHg",
              "HR": "96 bpm",
              "RR": "22 /min",
              "SpO2": "95%",
            },
            diagnostics: {
              "ECG": "Marked LV strain",
              "Creatinine": "Elevated",
              "Urine": "Proteinuria present",
              "Fundoscopy": "Significant hypertensive retinopathy changes",
            },
            severityNote:
                "This pattern raises concern for hypertensive urgency or emergency depending on symptoms and organ damage.",
          );
        }

      case PathologyTab.coronaryArteryDisease:
        if (severity == SeverityLevel.mild) {
          return const PatientScenario(
            patientName: "Patient D",
            age: 52,
            sex: "Male",
            chiefComplaint: "Chest tightness during stair climbing",
            history:
                "Smoker with elevated lipids and symptoms relieved by rest.",
            vitals: {
              "BP": "138/86 mmHg",
              "HR": "84 bpm",
              "RR": "17 /min",
              "SpO2": "98%",
            },
            diagnostics: {
              "ECG": "No acute ST changes at rest",
              "Troponin": "Negative",
              "Lipid Profile": "LDL elevated",
              "Stress Test": "Suggestive of inducible ischemia",
            },
            severityNote:
                "This resembles stable ischemic heart disease with exertional symptoms.",
          );
        } else if (severity == SeverityLevel.moderate) {
          return const PatientScenario(
            patientName: "Patient E",
            age: 61,
            sex: "Female",
            chiefComplaint: "Frequent chest pain with moderate activity",
            history:
                "Diabetes, hypertension, and family history of ischemic heart disease.",
            vitals: {
              "BP": "150/94 mmHg",
              "HR": "92 bpm",
              "RR": "18 /min",
              "SpO2": "97%",
            },
            diagnostics: {
              "ECG": "T-wave inversion in anterior leads",
              "Troponin": "Negative",
              "Lipid Profile": "Mixed dyslipidemia",
              "Echo": "Mild wall motion abnormality",
            },
            severityNote:
                "This indicates more established coronary disease with higher ischemic burden.",
          );
        } else {
          return const PatientScenario(
            patientName: "Patient F",
            age: 67,
            sex: "Male",
            chiefComplaint: "Severe chest pain at rest radiating to left arm",
            history:
                "Smoker with diabetes and prior uncontrolled hypertension.",
            vitals: {
              "BP": "92/60 mmHg",
              "HR": "112 bpm",
              "RR": "24 /min",
              "SpO2": "93%",
            },
            diagnostics: {
              "ECG": "ST-segment elevation changes",
              "Troponin": "Markedly elevated",
              "Echo": "Regional wall motion abnormality",
              "Angiography": "Likely critical coronary obstruction",
            },
            severityNote:
                "This scenario is highly concerning for acute coronary syndrome requiring urgent intervention.",
          );
        }

      case PathologyTab.heartFailure:
        if (severity == SeverityLevel.mild) {
          return const PatientScenario(
            patientName: "Patient G",
            age: 58,
            sex: "Male",
            chiefComplaint: "Shortness of breath on exertion",
            history:
                "Past hypertension with reduced exercise tolerance over several months.",
            vitals: {
              "BP": "142/88 mmHg",
              "HR": "90 bpm",
              "RR": "18 /min",
              "SpO2": "96%",
            },
            diagnostics: {
              "ECG": "Nonspecific changes",
              "BNP": "Mildly elevated",
              "Chest X-ray": "No frank edema",
              "Echo": "Mild LV dysfunction",
            },
            severityNote:
                "Early heart failure often appears with effort intolerance and subtle fluid changes.",
          );
        } else if (severity == SeverityLevel.moderate) {
          return const PatientScenario(
            patientName: "Patient H",
            age: 66,
            sex: "Female",
            chiefComplaint: "Dyspnea, orthopnea, and ankle swelling",
            history:
                "Known CAD and longstanding hypertension with progressive fatigue.",
            vitals: {
              "BP": "136/84 mmHg",
              "HR": "102 bpm",
              "RR": "22 /min",
              "SpO2": "94%",
            },
            diagnostics: {
              "ECG": "Prior ischemic changes",
              "BNP": "Elevated",
              "Chest X-ray": "Pulmonary vascular congestion",
              "Echo": "Reduced ejection fraction",
            },
            severityNote:
                "This reflects clinically significant heart failure with congestion.",
          );
        } else {
          return const PatientScenario(
            patientName: "Patient I",
            age: 71,
            sex: "Male",
            chiefComplaint: "Severe breathlessness at rest",
            history:
                "Advanced heart disease with recurrent admissions and poor sleep due to orthopnea.",
            vitals: {
              "BP": "90/58 mmHg",
              "HR": "118 bpm",
              "RR": "28 /min",
              "SpO2": "88%",
            },
            diagnostics: {
              "ECG": "Tachycardia with chronic changes",
              "BNP": "Markedly elevated",
              "Chest X-ray": "Pulmonary edema",
              "Echo": "Severely reduced ejection fraction",
            },
            severityNote:
                "This is a high-risk decompensated state with impaired oxygenation and poor perfusion.",
          );
        }

      case PathologyTab.arrhythmia:
        if (severity == SeverityLevel.mild) {
          return const PatientScenario(
            patientName: "Patient J",
            age: 34,
            sex: "Female",
            chiefComplaint: "Intermittent palpitations",
            history:
                "Symptoms occur during stress and caffeine intake without syncope.",
            vitals: {
              "BP": "124/78 mmHg",
              "HR": "102 bpm",
              "RR": "16 /min",
              "SpO2": "99%",
            },
            diagnostics: {
              "ECG": "Occasional premature beats",
              "Electrolytes": "Normal",
              "Thyroid": "Normal",
              "Echo": "Normal structure",
            },
            severityNote:
                "This likely represents a low-risk symptomatic rhythm disturbance.",
          );
        } else if (severity == SeverityLevel.moderate) {
          return const PatientScenario(
            patientName: "Patient K",
            age: 59,
            sex: "Male",
            chiefComplaint: "Palpitations with dizziness",
            history:
                "Known ischemic heart disease and episodic irregular pulse.",
            vitals: {
              "BP": "118/74 mmHg",
              "HR": "136 bpm",
              "RR": "20 /min",
              "SpO2": "96%",
            },
            diagnostics: {
              "ECG": "Irregular tachyarrhythmia",
              "Electrolytes": "Mild potassium disturbance",
              "Holter": "Frequent episodes",
              "Echo": "Mild left atrial enlargement",
            },
            severityNote:
                "This pattern is more clinically important because symptoms and hemodynamics are affected.",
          );
        } else {
          return const PatientScenario(
            patientName: "Patient L",
            age: 68,
            sex: "Female",
            chiefComplaint: "Syncope and chest discomfort",
            history:
                "Structural heart disease with sudden collapse episode.",
            vitals: {
              "BP": "82/50 mmHg",
              "HR": "162 bpm",
              "RR": "24 /min",
              "SpO2": "91%",
            },
            diagnostics: {
              "ECG": "Unstable tachyarrhythmia pattern",
              "Electrolytes": "Possible disturbance",
              "Echo": "Underlying structural disease",
              "Holter": "Sustained abnormal rhythm events",
            },
            severityNote:
                "This is a hemodynamically unstable rhythm scenario requiring urgent escalation.",
          );
        }
    }
  }

  Future<void> _handleAIAction(String action) async {
    setState(() {
      isAiLoading = true;
      aiResultTitle = "Analyzing ${currentCase.title}...";
    });

    try {
      String result = "";
      String title = "";
      Color accent = currentCase.color;

      if (action == "simplify") {
        title = "Simplified Explanation";
        accent = const Color(0xFF8B5CF6);
        result = await FakeAIService.simplifyTopic(
          topic: currentCase.title,
          content: currentCase.description,
        );
      } else if (action == "summary") {
        title = "Smart Summary";
        accent = const Color(0xFF26A69A);
        result = await FakeAIService.generateSummary(
          topic: currentCase.title,
          content: currentCase.description,
          bullets: currentCase.keyFindings,
        );
      } else if (action == "questions") {
        title = "Practice Questions";
        accent = const Color(0xFFF4A641);
        result = await FakeAIService.generateQuestions(
          topic: currentCase.title,
        );
      } else if (action == "clinical") {
        title = "Clinical Insight";
        accent = const Color(0xFFE35D6A);
        result = await FakeAIService.generateClinicalInsight(
          topic: currentCase.title,
          clinicalNote: currentCase.clinicalMeaning,
        );
      }

      if (!mounted) return;

      setState(() {
        isAiLoading = false;
        aiResultTitle = title;
        aiResult = result;
        aiAccentColor = accent;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isAiLoading = false;
        aiResultTitle = "AI Request Failed";
        aiResult = "$e";
        aiAccentColor = Colors.redAccent;
      });
    }
  }

  int _quizScore() {
    int score = 0;
    for (int i = 0; i < pathologyQuiz.length; i++) {
      if (selectedAnswers[i] == pathologyQuiz[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  void _resetQuiz() {
    setState(() {
      quizIndex = 0;
      quizSubmitted = false;
      selectedAnswers = List<int?>.filled(pathologyQuiz.length, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final item = currentCase;
    final scenario = currentScenario;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 850;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF09111F) : const Color(0xFFF4F8FC),
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF14314B),
        ),
        title: Text(
          "Pathology",
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF14314B),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(),
            const SizedBox(height: 18),
            _buildStatsRow(isDark),
            const SizedBox(height: 18),
            _buildTabs(isDark),
            const SizedBox(height: 18),
            _buildMainPathologyCard(isDark, item),
            const SizedBox(height: 18),
            _buildSeverityPanel(isDark, item),
            const SizedBox(height: 18),
            _buildPatientScenarioCard(isDark, item, scenario),
            const SizedBox(height: 18),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSymptomsCard(isDark, item)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildRiskFactorsCard(isDark, item)),
                ],
              )
            else
              Column(
                children: [
                  _buildSymptomsCard(isDark, item),
                  const SizedBox(height: 12),
                  _buildRiskFactorsCard(isDark, item),
                ],
              ),
            const SizedBox(height: 18),
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInvestigationsCard(isDark, item, scenario)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildRedFlagsCard(isDark, item)),
                ],
              )
            else
              Column(
                children: [
                  _buildInvestigationsCard(isDark, item, scenario),
                  const SizedBox(height: 12),
                  _buildRedFlagsCard(isDark, item),
                ],
              ),
            const SizedBox(height: 18),
            _buildManagementCard(isDark, item),
            const SizedBox(height: 18),
            _buildAiPanel(isDark),
            const SizedBox(height: 18),
            _buildQuizPanel(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5B1E8A),
            Color(0xFF8E24AA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.science_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Cardiovascular Pathology Lab",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "A realistic learning environment for disease review, patient scenario interpretation, severity simulation, diagnostic analysis, red-flag detection, and clinical decision support.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.55,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _heroChip(Icons.medical_information_rounded, currentCase.title),
              _heroChip(Icons.warning_amber_rounded, severityLabel),
              _heroChip(Icons.monitor_heart_outlined, "Live Case View"),
              _heroChip(Icons.quiz_rounded, "Mini Assessment"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            isDark,
            "Diseases",
            "4",
            Icons.local_hospital_outlined,
            const Color(0xFF42A5F5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            isDark,
            "Severity",
            severityLabel,
            Icons.speed_rounded,
            currentCase.color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            isDark,
            "AI Mode",
            "Active",
            Icons.psychology_alt_rounded,
            const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
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
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
              fontSize: 15.5,
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
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark) {
    final items = {
      PathologyTab.hypertension: "Hypertension",
      PathologyTab.coronaryArteryDisease: "CAD",
      PathologyTab.heartFailure: "Heart Failure",
      PathologyTab.arrhythmia: "Arrhythmia",
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.entries.map((entry) {
          final active = selectedTab == entry.key;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = entry.key;
                aiResultTitle = "MediLearn Pathology Assistant";
                aiResult =
                    "Use the smart tools below to simplify pathology concepts, generate summary notes, produce practice questions, or explain clinical meaning.";
                aiAccentColor = const Color(0xFF8B5CF6);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFF14314B)
                    : (isDark ? const Color(0xFF111827) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active
                      ? const Color(0xFF14314B)
                      : (isDark
                          ? const Color(0xFF1F2937)
                          : const Color(0xFFDDE6EF)),
                ),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : (isDark ? Colors.white70 : const Color(0xFF334155)),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainPathologyCard(bool isDark, PathologyCase item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(isDark, item.title, item.icon, item.color),
          const SizedBox(height: 8),
          Text(
            item.subtitle,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF334155),
              height: 1.65,
              fontSize: 14.2,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: item.keyFindings
                .map(
                  (e) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      e,
                      style: TextStyle(
                        color: item.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.2,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              item.clinicalMeaning,
              style: TextStyle(
                color: item.color,
                height: 1.55,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityPanel(bool isDark, PathologyCase item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Severity Simulator",
            Icons.speed_rounded,
            item.color,
          ),
          const SizedBox(height: 14),
          Slider(
            value: severityValue,
            min: 0.33,
            max: 1.0,
            divisions: 2,
            label: severityLabel,
            activeColor: item.color,
            onChanged: (value) {
              setState(() {
                if (value < 0.5) {
                  severity = SeverityLevel.mild;
                } else if (value < 0.85) {
                  severity = SeverityLevel.moderate;
                } else {
                  severity = SeverityLevel.severe;
                }
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            "Selected severity: $severityLabel",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            severityInterpretation,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientScenarioCard(
    bool isDark,
    PathologyCase item,
    PatientScenario scenario,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Patient Case Simulator",
            Icons.person_search_rounded,
            item.color,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: item.color.withOpacity(0.16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${scenario.patientName} • ${scenario.age} y/o • ${scenario.sex}",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Chief complaint: ${scenario.chiefComplaint}",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  scenario.history,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xFF475569),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Vital Signs",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: scenario.vitals.entries
                .map(
                  (e) => Container(
                    width: 150,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1220)
                          : const Color(0xFFF8FBFF),
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
                            color:
                                isDark ? Colors.white60 : const Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          e.value,
                          style: TextStyle(
                            color: isDark ? Colors.white : item.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              scenario.severityNote,
              style: const TextStyle(
                color: Color(0xFFB45309),
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsCard(bool isDark, PathologyCase item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Symptoms",
            Icons.sick_rounded,
            const Color(0xFFE57373),
          ),
          const SizedBox(height: 14),
          ...item.symptoms.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFE57373)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
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

  Widget _buildRiskFactorsCard(bool isDark, PathologyCase item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Risk Factors",
            Icons.warning_rounded,
            const Color(0xFFFFA726),
          ),
          const SizedBox(height: 14),
          ...item.riskFactors.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFFFFA726)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
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

  Widget _buildInvestigationsCard(
    bool isDark,
    PathologyCase item,
    PatientScenario scenario,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Investigations & Findings",
            Icons.biotech_rounded,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 14),
          ...item.investigations.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      size: 18, color: Color(0xFF26A69A)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Current Diagnostic Snapshot",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...scenario.diagnostics.entries.map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B1220)
                    : const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      e.key,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF102033),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.value,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white70 : const Color(0xFF475569),
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

  Widget _buildRedFlagsCard(bool isDark, PathologyCase item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Red Flags",
            Icons.emergency_rounded,
            const Color(0xFFE53935),
          ),
          const SizedBox(height: 14),
          ...item.redFlags.map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.priority_high_rounded,
                      color: Color(0xFFE53935), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Color(0xFFB91C1C),
                        fontWeight: FontWeight.w700,
                        height: 1.45,
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

  Widget _buildManagementCard(bool isDark, PathologyCase item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Management Priorities",
            Icons.assignment_turned_in_rounded,
            const Color(0xFF0EA5A4),
          ),
          const SizedBox(height: 14),
          ...item.managementPriorities.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.arrow_right_alt_rounded,
                      color: Color(0xFF0EA5A4)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
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

  Widget _buildAiPanel(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "MediLearn AI Assistant",
            Icons.psychology_alt_rounded,
            aiAccentColor,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _aiChip(
                isDark,
                "Simplify Topic",
                Icons.auto_fix_high_rounded,
                const Color(0xFF8B5CF6),
                () => _handleAIAction("simplify"),
              ),
              _aiChip(
                isDark,
                "Generate Summary",
                Icons.summarize_rounded,
                const Color(0xFF26A69A),
                () => _handleAIAction("summary"),
              ),
              _aiChip(
                isDark,
                "Practice Questions",
                Icons.quiz_rounded,
                const Color(0xFFF4A641),
                () => _handleAIAction("questions"),
              ),
              _aiChip(
                isDark,
                "Clinical Insight",
                Icons.local_hospital_rounded,
                const Color(0xFFE35D6A),
                () => _handleAIAction("clinical"),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: aiAccentColor.withOpacity(0.24),
              ),
            ),
            child: isAiLoading
                ? Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(aiAccentColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Generating AI response...",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : const Color(0xFF475569),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aiResultTitle,
                        style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF102033),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        aiResult,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF334155),
                          fontSize: 14.2,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPanel(bool isDark) {
    final q = pathologyQuiz[quizIndex];
    final selected = selectedAnswers[quizIndex];
    final score = _quizScore();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardTitle(
                isDark,
                "Mini Pathology Quiz",
                Icons.quiz_rounded,
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 14),
              Text(
                "Question ${quizIndex + 1} of ${pathologyQuiz.length}",
                style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                q.question,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF102033),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(q.answers.length, (index) {
                final isSelected = selected == index;
                final isCorrect = q.correctIndex == index;
                final isWrongSelected =
                    quizSubmitted && isSelected && !isCorrect;

                Color borderColor;
                Color fillColor;

                if (quizSubmitted && isCorrect) {
                  borderColor = Colors.green;
                  fillColor = Colors.green.withOpacity(0.10);
                } else if (isWrongSelected) {
                  borderColor = Colors.red;
                  fillColor = Colors.red.withOpacity(0.10);
                } else if (isSelected) {
                  borderColor = const Color(0xFF8B5CF6);
                  fillColor = const Color(0xFF8B5CF6).withOpacity(0.10);
                } else {
                  borderColor = isDark
                      ? const Color(0xFF1F2937)
                      : const Color(0xFFE2E8F0);
                  fillColor =
                      isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FAFC);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: quizSubmitted
                        ? null
                        : () {
                            setState(() {
                              selectedAnswers[quizIndex] = index;
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
                              q.answers[index],
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF102033),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (quizSubmitted && isCorrect)
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: quizIndex > 0
                          ? () => setState(() => quizIndex--)
                          : null,
                      child: const Text("Previous"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: quizIndex < pathologyQuiz.length - 1
                          ? () => setState(() => quizIndex++)
                          : null,
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetQuiz,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14314B),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => quizSubmitted = true),
                      icon: const Icon(Icons.task_alt_rounded),
                      label: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (quizSubmitted) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: _cardDecoration(isDark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardTitle(
                  isDark,
                  "Quiz Result",
                  Icons.emoji_events_rounded,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 14),
                Text(
                  "Your score: $score / ${pathologyQuiz.length}",
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  score == pathologyQuiz.length
                      ? "Excellent clinical understanding."
                      : score >= 2
                          ? "Good progress. Review weak points and retry."
                          : "You need more revision before moving forward.",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _aiChip(
    bool isDark,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12.3,
              ),
            ),
          ],
        ),
      ),
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

  Widget _cardTitle(bool isDark, String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontSize: 14.8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

const List<PathologyQuestion> pathologyQuiz = [
  PathologyQuestion(
    question: "Which condition is commonly called a silent cardiovascular risk?",
    answers: [
      "Arrhythmia",
      "Hypertension",
      "Heart failure",
      "Valve prolapse",
    ],
    correctIndex: 1,
  ),
  PathologyQuestion(
    question: "Coronary artery disease mainly reduces blood supply to the:",
    answers: [
      "Kidneys",
      "Liver",
      "Myocardium",
      "Lungs",
    ],
    correctIndex: 2,
  ),
  PathologyQuestion(
    question: "A common sign of heart failure is:",
    answers: [
      "Peripheral edema",
      "Hearing loss",
      "Dry skin",
      "Blurred speech",
    ],
    correctIndex: 0,
  ),
  PathologyQuestion(
    question: "Which investigation is essential for rhythm analysis in arrhythmia?",
    answers: [
      "ECG",
      "Urinalysis",
      "CT abdomen",
      "Skin biopsy",
    ],
    correctIndex: 0,
  ),
];