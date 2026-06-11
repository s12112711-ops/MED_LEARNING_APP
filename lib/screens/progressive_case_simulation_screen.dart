import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressiveCaseSimulationScreen extends StatefulWidget {
  final dynamic caseData;

  const ProgressiveCaseSimulationScreen({
    super.key,
    required this.caseData,
  });

  @override
  State<ProgressiveCaseSimulationScreen> createState() =>
      _ProgressiveCaseSimulationScreenState();
}

class _ProgressiveCaseSimulationScreenState
    extends State<ProgressiveCaseSimulationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _bannerController;
  Timer? _monitorTimer;

  int score = 0;

  bool historyOpened = false;
  bool examOpened = false;
  bool hintOpened = false;

  bool ecgOrdered = false;
  bool labsOrdered = false;
  bool imagingOrdered = false;
  bool reportOpened = false;

  bool ecgReady = false;
  bool labsReady = false;
  bool imagingReady = false;
  bool reportReady = false;

  bool oxygenGiven = false;
  bool aspirinGiven = false;
  bool cardiologyCalled = false;
  bool reassuredPatient = false;

  bool triageDone = false;
  bool impressionDone = false;
  bool diagnosisDone = false;
  bool actionDone = false;

  int? selectedTriage;
  int? selectedImpression;
  int? selectedDiagnosis;
  int? selectedAction;

  String patientState = "unstable";
  String alertMessage = "Patient arrived. Immediate assessment required.";
  bool dangerAlert = true;

  late Map<String, String> liveVitals;
  final List<String> eventFeed = [];
  final List<String> orderedTests = [];

  final List<String> possibleDifferentials = [
    "Acute coronary syndrome",
    "Pulmonary embolism",
    "Aortic dissection",
    "Gastritis / reflux",
    "Anxiety-related chest pain",
    "Acute heart failure",
  ];

  final List<String> highPriorityDifferentials = [];
  final List<String> ruledOutDifferentials = [];

  @override
  void initState() {
    super.initState();

    liveVitals = Map<String, String>.from(vitals);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _bannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);

    eventFeed.add("Patient arrived to emergency area.");
    eventFeed.add("Chief complaint documented: $complaint");

    _monitorTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      _simulateMonitorDrift();
    });
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    _pulseController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  String _string(dynamic value, [String fallback = "-"]) {
    if (value == null) return fallback;
    return value.toString();
  }

  int _int(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? fallback;
  }

  List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  Map<String, String> _stringMap(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val.toString()));
    }
    return {};
  }

  T? _read<T>(String fieldName) {
    try {
      final dynamic data = widget.caseData;
      switch (fieldName) {
        case "title": return data.title as T?;
        case "category": return data.category as T?;
        case "difficulty": return data.difficulty as T?;
        case "urgency": return data.urgency as T?;
        case "patientName": return data.patientName as T?;
        case "age": return data.age as T?;
        case "gender": return data.gender as T?;
        case "complaint": return data.complaint as T?;
        case "history": return data.history as T?;
        case "ecgClue": return data.ecgClue as T?;
        case "labClue": return data.labClue as T?;
        case "imagingClue": return data.imagingClue as T?;
        case "hint": return data.hint as T?;
        case "redFlag": return data.redFlag as T?;
        case "likelyComplication": return data.likelyComplication as T?;
        case "physicalExam": return data.physicalExam as T?;
        case "vitals": return data.vitals as T?;
        case "triageOptions": return data.triageOptions as T?;
        case "correctTriageIndex": return data.correctTriageIndex as T?;
        case "impressionOptions": return data.impressionOptions as T?;
        case "correctImpressionIndex": return data.correctImpressionIndex as T?;
        case "diagnosisOptions": return data.diagnosisOptions as T?;
        case "correctDiagnosisIndex": return data.correctDiagnosisIndex as T?;
        case "actionOptions": return data.actionOptions as T?;
        case "correctActionIndex": return data.correctActionIndex as T?;
        case "color": return data.color as T?;
        case "icon": return data.icon as T?;
        case "tags": return data.tags as T?;
        case "estimatedMinutes": return data.estimatedMinutes as T?;
        case "learningGoals": return data.learningGoals as T?;
        case "patientImage": return data.patientImage as T?;
        case "ecgImage": return data.ecgImage as T?;
        case "xrayImage": return data.xrayImage as T?;
        case "reportImage": return data.reportImage as T?;
        case "ctImage": return data.ctImage as T?;
        case "labTable": return data.labTable as T?;
        default: return null;
      }
    } catch (_) {
      return null;
    }
  }

  String get title => _string(_read("title"));
  String get category => _string(_read("category"));
  String get difficulty => _string(_read("difficulty"));
  String get urgency => _string(_read("urgency"));
  String get patientName => _string(_read("patientName"), "Patient");
  int get age => _int(_read("age"));
  String get gender => _string(_read("gender"));
  String get complaint => _string(_read("complaint"));
  String get history => _string(_read("history"));
  String get ecgClue => _string(_read("ecgClue"));
  String get labClue => _string(_read("labClue"));
  String get imagingClue => _string(_read("imagingClue"));
  String get hint => _string(_read("hint"));
  String get redFlag => _string(_read("redFlag"));
  String get likelyComplication => _string(_read("likelyComplication"));
  List<String> get physicalExam => _stringList(_read("physicalExam"));
  Map<String, String> get vitals => _stringMap(_read("vitals"));
  List<String> get triageOptions => _stringList(_read("triageOptions"));
  int get correctTriageIndex => _int(_read("correctTriageIndex"));
  List<String> get impressionOptions => _stringList(_read("impressionOptions"));
  int get correctImpressionIndex => _int(_read("correctImpressionIndex"));
  List<String> get diagnosisOptions => _stringList(_read("diagnosisOptions"));
  int get correctDiagnosisIndex => _int(_read("correctDiagnosisIndex"));
  List<String> get actionOptions => _stringList(_read("actionOptions"));
  int get correctActionIndex => _int(_read("correctActionIndex"));
  Color get accentColor => (_read("color") as Color?) ?? const Color(0xFFDC2626);
  IconData get caseIcon => (_read("icon") as IconData?) ?? Icons.local_hospital_rounded;
  List<String> get tags => _stringList(_read("tags"));
  int get estimatedMinutes => _int(_read("estimatedMinutes"), 12);
  List<String> get learningGoals => _stringList(_read("learningGoals"));
  String? get patientImage => _read("patientImage")?.toString();
  String? get ecgImage => _read("ecgImage")?.toString();
  String? get xrayImage => _read("xrayImage")?.toString();
  String? get reportImage => _read("reportImage")?.toString();
  String? get ctImage => _read("ctImage")?.toString();
  Map<String, String> get labTable => _stringMap(_read("labTable"));

  int get maxScore => 100;
  int get percent => ((score / maxScore) * 100).round();
  bool get caseComplete => triageDone && impressionDone && diagnosisDone && actionDone;

  String _performanceLabel() {
    if (percent >= 90) return "Excellent Clinical Reasoning";
    if (percent >= 75) return "Very Good Performance";
    if (percent >= 50) return "Good Start";
    return "Needs More Practice";
  }

  Color _performanceColor() {
    if (percent >= 90) return const Color(0xFF059669);
    if (percent >= 75) return const Color(0xFF2563EB);
    if (percent >= 50) return const Color(0xFFEA580C);
    return const Color(0xFFDC2626);
  }

  void _addEvent(String text) {
    setState(() {
      eventFeed.insert(0, text);
    });
  }

  void _setAlert(String text, {required bool danger}) {
    setState(() {
      alertMessage = text;
      dangerAlert = danger;
    });
  }

  void _updatePatientState(String value) {
    setState(() {
      patientState = value;
    });
  }

  int _extractNumber(String raw) {
    final match = RegExp(r'\d+').firstMatch(raw);
    return match == null ? 0 : int.parse(match.group(0)!);
  }

  void _setVital(String key, String value) {
    liveVitals[key] = value;
  }

  void _simulateMonitorDrift() {
    if (!mounted) return;
    if (caseComplete) return;

    final hr = _extractNumber(liveVitals["HR"] ?? "0");
    final spo2 = _extractNumber(liveVitals["SpO2"] ?? "0");
    final bp = liveVitals["BP"] ?? "0/0";

    if (patientState == "worsening" || patientState == "critical") {
      final newHr = math.min(hr + 2, 170);
      final newSpo2 = math.max(spo2 - 1, 82);
      final parts = bp.split("/");
      final systolic = parts.isNotEmpty ? _extractNumber(parts[0]) : 0;
      final diastolic = parts.length > 1 ? _extractNumber(parts[1]) : 0;
      final newSys = math.max(systolic - 2, 70);
      final newDia = math.max(diastolic - 1, 40);

      setState(() {
        _setVital("HR", "$newHr bpm");
        _setVital("SpO2", "$newSpo2%");
        _setVital("BP", "$newSys/$newDia mmHg");
      });
    } else if (patientState == "stabilizing") {
      final newHr = math.max(hr - 1, 96);
      final newSpo2 = math.min(spo2 + 1, 96);

      setState(() {
        _setVital("HR", "$newHr bpm");
        _setVital("SpO2", "$newSpo2%");
      });
    }
  }

  Future<void> _receiveResult({
    required String testName,
    required VoidCallback onReady,
    required String successEvent,
  }) async {
    _orderTest(testName);
    _setAlert("$testName requested. Waiting for result...", danger: false);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(onReady);
    _addEvent(successEvent);
    _setAlert("$testName result received.", danger: false);
  }

  void _orderTest(String name) {
    if (!orderedTests.contains(name)) {
      orderedTests.add(name);
      _addEvent("$name ordered.");
    }
  }

  void _giveOxygen() {
    if (oxygenGiven) return;
    setState(() {
      oxygenGiven = true;
      final spo2 = _extractNumber(liveVitals["SpO2"] ?? "0");
      _setVital("SpO2", "${math.min(spo2 + 2, 96)}%");
      score += 5;
    });
    _addEvent("Oxygen applied.");
    _setAlert("Oxygen support started.", danger: false);
  }

  void _giveAspirin() {
    if (aspirinGiven) return;
    setState(() {
      aspirinGiven = true;
      score += 10;
    });
    _addEvent("Aspirin given.");
    _setAlert("Early evidence-based step completed.", danger: false);
  }

  void _callCardiology() {
    if (cardiologyCalled) return;
    setState(() {
      cardiologyCalled = true;
      score += 10;
    });
    _addEvent("Cardiology / urgent escalation called.");
    _setAlert("Specialist escalation activated.", danger: false);
  }

  void _reassurePatient() {
    if (reassuredPatient) return;
    setState(() {
      reassuredPatient = true;
      score = math.max(0, score - 5);
      _updatePatientState("worsening");
    });
    _addEvent("Patient reassured without adequate urgent workup.");
    _setAlert("Unsafe reassurance may delay lifesaving treatment.", danger: true);
  }

  void _moveToHighPriority(String item) {
    setState(() {
      ruledOutDifferentials.remove(item);
      if (!highPriorityDifferentials.contains(item)) {
        highPriorityDifferentials.add(item);
      }
    });
  }

  void _moveToRuledOut(String item) {
    setState(() {
      highPriorityDifferentials.remove(item);
      if (!ruledOutDifferentials.contains(item)) {
        ruledOutDifferentials.add(item);
      }
    });
  }

  void _resetDifferential(String item) {
    setState(() {
      highPriorityDifferentials.remove(item);
      ruledOutDifferentials.remove(item);
    });
  }

  void _submitTriage() {
    if (selectedTriage == null || triageDone) return;
    final correct = selectedTriage == correctTriageIndex;

    setState(() {
      triageDone = true;
      if (correct) {
        score += 20;
        _updatePatientState("unstable");
      } else {
        score = math.max(0, score - 5);
        _updatePatientState("worsening");
      }
    });

    if (correct) {
      _addEvent("Correct triage priority chosen.");
      _setAlert("High-risk patient recognized early.", danger: false);
    } else {
      _addEvent("Unsafe triage decision selected.");
      _setAlert("Urgency underestimated. Patient may deteriorate.", danger: true);
    }
  }

  void _submitImpression() {
    if (selectedImpression == null || impressionDone) return;
    final correct = selectedImpression == correctImpressionIndex;

    setState(() {
      impressionDone = true;
      if (correct) {
        score += 20;
      } else {
        score = math.max(0, score - 5);
      }
    });

    _addEvent(
      correct
          ? "Clinical impression matched the main emergency pattern."
          : "Clinical impression missed the dominant pattern.",
    );
  }

  void _submitDiagnosis() {
    if (selectedDiagnosis == null || diagnosisDone) return;
    final correct = selectedDiagnosis == correctDiagnosisIndex;

    setState(() {
      diagnosisDone = true;
      if (correct) {
        score += 20;
      } else {
        score = math.max(0, score - 5);
      }
    });

    _addEvent(
      correct
          ? "Most likely diagnosis identified."
          : "Diagnosis choice was suboptimal.",
    );
  }

  void _submitAction() {
    if (selectedAction == null || actionDone) return;
    final correct = selectedAction == correctActionIndex;

    setState(() {
      actionDone = true;
      if (correct) {
        score += 20;
      } else {
        score = math.max(0, score - 8);
      }
    });

    if (correct && (aspirinGiven || cardiologyCalled || ecgReady)) {
      _updatePatientState("stabilizing");
      _setAlert("Correct urgent action selected. Patient is improving.", danger: false);
      _addEvent("Appropriate initial management pathway activated.");
      _setVital("BP", "100/64 mmHg");
      _setVital("HR", "102 bpm");
      _setVital("SpO2", "94%");
    } else if (correct) {
      _updatePatientState("unstable");
      _setAlert("Correct action selected, but supportive urgent steps are still important.", danger: false);
      _addEvent("Correct pathway chosen, but optimization still needed.");
    } else {
      _updatePatientState("critical");
      _setAlert("Unsafe delay or wrong action. Condition worsening.", danger: true);
      _addEvent("Unsafe action increased clinical risk.");
      _setVital("BP", "78/46 mmHg");
      _setVital("HR", "136 bpm");
      _setVital("SpO2", "87%");
    }
  }

  Color _stateColor() {
    switch (patientState) {
      case "critical": return const Color(0xFFB91C1C);
      case "worsening": return const Color(0xFFDC2626);
      case "stabilizing": return const Color(0xFF059669);
      case "recovered": return const Color(0xFF0F766E);
      default: return const Color(0xFFEA580C);
    }
  }

  String _stateLabel() {
    switch (patientState) {
      case "critical": return "Critical";
      case "worsening": return "Worsening";
      case "stabilizing": return "Stabilizing";
      case "recovered": return "Recovered";
      default: return "Unstable";
    }
  }

  void _showZoomedImage(String title, String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFFF8FAFC),
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F3B5B),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _imageFallback(title),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? color.withOpacity(0.10) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: enabled ? color.withOpacity(0.40) : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 17,
              color: enabled ? color : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.8,
                fontWeight: FontWeight.w700,
                color: enabled ? color : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageFallback(String label) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_not_supported_rounded, size: 40, color: accentColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabTable() {
    if (labTable.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Text(
          "No structured lab table added for this case yet.",
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: labTable.entries.map((entry) {
        return Container(
          width: 170,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                entry.value,
                style: const TextStyle(
                  fontSize: 14.5,
                  color: Color(0xFF1F3B5B),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.4,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageCard({
    required String title,
    required String? path,
    double height = 220,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13.3,
            fontWeight: FontWeight.w800,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: path == null || path.isEmpty ? null : () => _showZoomedImage(title, path),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: path != null && path.isNotEmpty
                ? Image.asset(
                    path,
                    height: height,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imageFallback(title),
                  )
                : _imageFallback(title),
          ),
        ),
      ],
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    IconData? icon,
    Color borderColor = const Color(0xFFE2E8F0),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFF1F3B5B)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F3B5B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _monitorTile({
    required String label,
    required String value,
    required Color color,
  }) {
    return ScaleTransition(
      scale: Tween(begin: 0.98, end: 1.02).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1F3B5B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pulseWave() {
    return SizedBox(
      height: 58,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (_, __) {
          return CustomPaint(
            painter: _PulsePainter(
              progress: _pulseController.value,
              color: dangerAlert ? const Color(0xFFEF4444) : accentColor,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }

  Widget _topEmergencyHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0F172A),
            accentColor.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.24),
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
              _statusChip(category, Colors.white, icon: Icons.category_rounded),
              _statusChip(difficulty, Colors.white, icon: Icons.school_rounded),
              _statusChip(_stateLabel(), _stateColor(), icon: Icons.emergency),
              _statusChip("$estimatedMinutes min", Colors.white, icon: Icons.schedule_rounded),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(caseIcon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$patientName • $age y/o $gender",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "SCORE",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "$score/$maxScore",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            complaint,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          _pulseWave(),
        ],
      ),
    );
  }

  Widget _liveAlertBanner() {
    return FadeTransition(
      opacity: Tween(begin: 0.65, end: 1.0).animate(_bannerController),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dangerAlert ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: dangerAlert ? const Color(0xFFEF4444).withOpacity(0.32) : const Color(0xFF10B981).withOpacity(0.28),
          ),
        ),
        child: Row(
          children: [
            Icon(
              dangerAlert ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
              color: dangerAlert ? const Color(0xFFDC2626) : const Color(0xFF059669),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                alertMessage,
                style: TextStyle(
                  fontSize: 13.4,
                  height: 1.45,
                  color: dangerAlert ? const Color(0xFF991B1B) : const Color(0xFF065F46),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monitorSection() {
    return _section(
      title: "Live Patient Monitor",
      icon: Icons.monitor_heart_rounded,
      borderColor: dangerAlert ? const Color(0xFFEF4444).withOpacity(0.25) : accentColor.withOpacity(0.18),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _monitorTile(label: "BP", value: liveVitals["BP"] ?? "-", color: Colors.red),
          _monitorTile(label: "HR", value: liveVitals["HR"] ?? "-", color: Colors.orange),
          _monitorTile(label: "RR", value: liveVitals["RR"] ?? "-", color: Colors.blue),
          _monitorTile(label: "SpO2", value: liveVitals["SpO2"] ?? "-", color: Colors.green),
        ],
      ),
    );
  }

  Widget _arrivalZone() {
    return _section(
      title: "Arrival Zone",
      icon: Icons.directions_walk_rounded,
      borderColor: accentColor.withOpacity(0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _imageCard(
            title: "Patient Visual Clue",
            path: patientImage,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.take(4).map<Widget>((t) => _statusChip(t, const Color(0xFF64748B))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _expandTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool opened,
    required VoidCallback onTap,
    required String body,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: opened ? color.withOpacity(0.35) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: opened ? color.withOpacity(0.12) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: opened ? color : const Color(0xFF64748B)),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F3B5B),
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: opened ? color : const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              opened ? Icons.expand_less_rounded : Icons.expand_more_rounded,
              color: opened ? color : const Color(0xFF64748B),
            ),
          ),
          if (opened)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _assessmentZone() {
    return Column(
      children: [
        _section(
          title: "Initial Assessment",
          icon: Icons.assignment_ind_rounded,
          child: Column(
            children: [
              _expandTile(
                title: "Take History",
                subtitle: historyOpened ? "Opened" : "Tap to open",
                icon: Icons.history_edu_rounded,
                opened: historyOpened,
                onTap: () {
                  setState(() => historyOpened = !historyOpened);
                  if (historyOpened) _addEvent("History reviewed.");
                },
                body: history,
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 12),
              _expandTile(
                title: "Physical Examination",
                subtitle: examOpened ? "Opened" : "Tap to open",
                icon: Icons.health_and_safety_rounded,
                opened: examOpened,
                onTap: () {
                  setState(() => examOpened = !examOpened);
                  if (examOpened) _addEvent("Physical exam reviewed.");
                },
                body: physicalExam.isEmpty ? "No examination findings added." : physicalExam.map((e) => "• $e").join("\n"),
                color: const Color(0xFF059669),
              ),
              const SizedBox(height: 12),
              _expandTile(
                title: "Clinical Hint",
                subtitle: hintOpened ? "Opened" : "Tap to open",
                icon: Icons.lightbulb_rounded,
                opened: hintOpened,
                onTap: () => setState(() => hintOpened = !hintOpened),
                body: hint,
                color: const Color(0xFFEAB308),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _resultCard({
    required String title,
    required String subtitle,
    required String imageTitle,
    required String? imagePath,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.8,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.55,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _imageCard(
            title: imageTitle,
            path: imagePath,
            height: 210,
          ),
        ],
      ),
    );
  }

  Widget _miniInterpretation({
    required String title,
    required List<String> choices,
    required int correctIndex,
  }) {
    return _section(
      title: title,
      icon: Icons.remove_red_eye_rounded,
      child: _MiniMCQ(
        choices: choices,
        correctIndex: correctIndex,
        accentColor: accentColor,
      ),
    );
  }

  Widget _investigationsZone() {
    return Column(
      children: [
        _section(
          title: "Investigations Hub",
          icon: Icons.science_rounded,
          borderColor: accentColor.withOpacity(0.18),
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _actionButton(
                    label: ecgReady ? "ECG Ready" : "Order ECG",
                    icon: Icons.monitor_heart_rounded,
                    color: const Color(0xFF7C3AED),
                    enabled: !ecgOrdered,
                    onTap: () async {
                      setState(() => ecgOrdered = true);
                      await _receiveResult(
                        testName: "ECG",
                        onReady: () => ecgReady = true,
                        successEvent: "ECG result received.",
                      );
                    },
                  ),
                  _actionButton(
                    label: labsReady ? "Labs Ready" : "Order Labs",
                    icon: Icons.biotech_rounded,
                    color: const Color(0xFF0F766E),
                    enabled: !labsOrdered,
                    onTap: () async {
                      setState(() => labsOrdered = true);
                      await _receiveResult(
                        testName: "Troponin / Labs",
                        onReady: () => labsReady = true,
                        successEvent: "Laboratory panel received.",
                      );
                    },
                  ),
                  _actionButton(
                    label: imagingReady ? "Imaging Ready" : "Order Imaging",
                    icon: Icons.medical_information_rounded,
                    color: const Color(0xFFEA580C),
                    enabled: !imagingOrdered,
                    onTap: () async {
                      setState(() => imagingOrdered = true);
                      await _receiveResult(
                        testName: "Imaging",
                        onReady: () => imagingReady = true,
                        successEvent: "Imaging result received.",
                      );
                    },
                  ),
                  _actionButton(
                    label: reportReady ? "Report Ready" : "Open Report",
                    icon: Icons.description_rounded,
                    color: const Color(0xFFDC2626),
                    enabled: !reportOpened,
                    onTap: () async {
                      setState(() => reportOpened = true);
                      await _receiveResult(
                        testName: "Clinical Report",
                        onReady: () => reportReady = true,
                        successEvent: "Clinical report loaded.",
                      );
                    },
                  ),
                ],
              ),
              if (ecgReady) ...[
                const SizedBox(height: 16),
                _resultCard(
                  title: "ECG Result",
                  subtitle: ecgClue,
                  imageTitle: "ECG Image",
                  imagePath: ecgImage,
                  color: const Color(0xFF7C3AED),
                ),
                const SizedBox(height: 12),
                _miniInterpretation(
                  title: "ECG Interpretation Check",
                  choices: const [
                    "ST elevation pattern",
                    "Normal ECG",
                    "Only benign changes",
                  ],
                  correctIndex: 0,
                ),
              ],
              if (labsReady) ...[
                const SizedBox(height: 16),
                _resultCard(
                  title: "Laboratory Result",
                  subtitle: labClue,
                  imageTitle: "Lab / Report Image",
                  imagePath: reportImage,
                  color: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 12),
                _buildLabTable(),
              ],
              if (imagingReady) ...[
                const SizedBox(height: 16),
                _resultCard(
                  title: "Imaging Result",
                  subtitle: imagingClue,
                  imageTitle: "Imaging Preview",
                  imagePath: xrayImage?.isNotEmpty == true ? xrayImage : ctImage,
                  color: const Color(0xFFEA580C),
                ),
              ],
              if (reportReady) ...[
                const SizedBox(height: 16),
                _resultCard(
                  title: "Clinical Report",
                  subtitle: "Red flag: $redFlag\n\nLikely complication: $likelyComplication",
                  imageTitle: "Formal Report",
                  imagePath: reportImage,
                  color: const Color(0xFFDC2626),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _diffColumn({
    required String title,
    required List<String> items,
    required Color color,
    required ValueChanged<String> onHigh,
    required ValueChanged<String> onRuleOut,
    required ValueChanged<String> onReset,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.6,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          if (items.isEmpty)
            const Text(
              "No items here yet.",
              style: TextStyle(
                fontSize: 12.8,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: const TextStyle(
                        fontSize: 13.2,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () => onHigh(item),
                          child: const Text("High Priority"),
                        ),
                        OutlinedButton(
                          onPressed: () => onRuleOut(item),
                          child: const Text("Rule Out"),
                        ),
                        OutlinedButton(
                          onPressed: () => onReset(item),
                          child: const Text("Reset"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _optionCard({
    required String text,
    required int index,
    required int? selectedIndex,
    required bool submitted,
    required int correctIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;
    final isCorrect = index == correctIndex;
    final isWrongSelected = submitted && isSelected && !isCorrect;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE2E8F0);

    if (submitted) {
      if (isCorrect) {
        bgColor = const Color(0xFFDCFCE7);
        borderColor = const Color(0xFF22C55E);
      } else if (isWrongSelected) {
        bgColor = const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFEF4444);
      }
    } else if (isSelected) {
      bgColor = accentColor.withOpacity(0.10);
      borderColor = accentColor;
    }

    return InkWell(
      onTap: submitted ? null : onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.4),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: submitted
                    ? (isCorrect ? const Color(0xFF22C55E) : isWrongSelected ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0))
                    : (isSelected ? accentColor : const Color(0xFFE2E8F0)),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + index),
                style: TextStyle(
                  color: (submitted || isSelected) ? Colors.white : const Color(0xFF475569),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13.8,
                  height: 1.45,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (submitted && isCorrect) const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
            if (isWrongSelected) const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626)),
          ],
        ),
      ),
    );
  }

  Widget _feedbackBox({
    required bool submitted,
    required bool isCorrect,
    required String correctAnswer,
    required String explanation,
  }) {
    if (!submitted) return const SizedBox.shrink();

    final color = isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? "Correct choice" : "Learning feedback",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Correct answer: $correctAnswer",
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: const TextStyle(
              fontSize: 13.3,
              height: 1.55,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _decisionSection({
    required String title,
    required String subtitle,
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelect,
    required VoidCallback onSubmit,
    required bool submitted,
    required int correctIndex,
    required String explanation,
  }) {
    final correctAnswer = options.isNotEmpty && correctIndex < options.length ? options[correctIndex] : "-";

    return _section(
      title: title,
      icon: Icons.psychology_alt_rounded,
      borderColor: accentColor.withOpacity(0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13.6,
              height: 1.55,
              color: Color(0xFF52606D),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(options.length, (index) {
            return _optionCard(
              text: options[index],
              index: index,
              selectedIndex: selectedIndex,
              submitted: submitted,
              correctIndex: correctIndex,
              onTap: () => onSelect(index),
            );
          }),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (selectedIndex == null || submitted) ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                disabledBackgroundColor: const Color(0xFFCBD5E1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.done_all_rounded),
              label: Text(
                submitted ? "Answer Submitted" : "Submit Answer",
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          _feedbackBox(
            submitted: submitted,
            isCorrect: selectedIndex == correctIndex,
            correctAnswer: correctAnswer,
            explanation: explanation,
          ),
        ],
      ),
    );
  }

  Widget _reasoningZone() {
    return Column(
      children: [
        _section(
          title: "Differential Diagnosis Board",
          icon: Icons.fact_check_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Move important possibilities into High Priority or rule them out.",
                style: TextStyle(
                  fontSize: 13.4,
                  color: Color(0xFF52606D),
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _diffColumn(
                title: "Possible",
                items: possibleDifferentials
                    .where((e) => !highPriorityDifferentials.contains(e) && !ruledOutDifferentials.contains(e))
                    .toList(),
                color: const Color(0xFF64748B),
                onHigh: _moveToHighPriority,
                onRuleOut: _moveToRuledOut,
                onReset: _resetDifferential,
              ),
              const SizedBox(height: 12),
              _diffColumn(
                title: "High Priority",
                items: highPriorityDifferentials,
                color: const Color(0xFFDC2626),
                onHigh: _moveToHighPriority,
                onRuleOut: _moveToRuledOut,
                onReset: _resetDifferential,
              ),
              const SizedBox(height: 12),
              _diffColumn(
                title: "Ruled Out",
                items: ruledOutDifferentials,
                color: const Color(0xFF059669),
                onHigh: _moveToHighPriority,
                onRuleOut: _moveToRuledOut,
                onReset: _resetDifferential,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _decisionSection(
          title: "Triage Priority",
          subtitle: "How urgent is this patient at first contact based on symptoms and monitor?",
          options: triageOptions,
          selectedIndex: selectedTriage,
          onSelect: (v) => setState(() => selectedTriage = v),
          onSubmit: _submitTriage,
          submitted: triageDone,
          correctIndex: correctTriageIndex,
          explanation: "Main red flag: $redFlag",
        ),
        const SizedBox(height: 16),
        _decisionSection(
          title: "Initial Clinical Impression",
          subtitle: "Choose the best broad first clinical impression before final diagnosis.",
          options: impressionOptions,
          selectedIndex: selectedImpression,
          onSelect: (v) => setState(() => selectedImpression = v),
          onSubmit: _submitImpression,
          submitted: impressionDone,
          correctIndex: correctImpressionIndex,
          explanation: "Use the monitor, symptoms, history, and tests together.",
        ),
        const SizedBox(height: 16),
        _decisionSection(
          title: "Most Likely Diagnosis",
          subtitle: "Which diagnosis best explains this presentation right now?",
          options: diagnosisOptions,
          selectedIndex: selectedDiagnosis,
          onSelect: (v) => setState(() => selectedDiagnosis = v),
          onSubmit: _submitDiagnosis,
          submitted: diagnosisDone,
          correctIndex: correctDiagnosisIndex,
          explanation: "This is where you commit to the most likely explanation.",
        ),
        const SizedBox(height: 16),
        _decisionSection(
          title: "Best Initial Action",
          subtitle: "Choose the immediate management direction that best protects the patient.",
          options: actionOptions,
          selectedIndex: selectedAction,
          onSelect: (v) => setState(() => selectedAction = v),
          onSubmit: _submitAction,
          submitted: actionDone,
          correctIndex: correctActionIndex,
          explanation: "Immediate action matters because complication risk is: $likelyComplication",
        ),
      ],
    );
  }

  Widget _outcomeZone() {
    return Column(
      children: [
        _section(
          title: "Outcome",
          icon: Icons.emoji_events_rounded,
          borderColor: _stateColor().withOpacity(0.22),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _stateColor().withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _stateColor().withOpacity(0.20)),
                ),
                child: Column(
                  children: [
                    Text(
                      _performanceLabel(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _performanceColor(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Final Score: $score / $maxScore ($percent%)",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1F2937),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Patient Status: ${_stateLabel()}",
                      style: TextStyle(
                        fontSize: 14,
                        color: _stateColor(),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _summaryRow("Red flag", redFlag),
              _summaryRow("Likely complication", likelyComplication),
              _summaryRow(
                "Correct diagnosis",
                diagnosisOptions.isNotEmpty ? diagnosisOptions[correctDiagnosisIndex] : "-",
              ),
              _summaryRow(
                "Best initial action",
                actionOptions.isNotEmpty ? actionOptions[correctActionIndex] : "-",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _section(
          title: "Learning Points",
          icon: Icons.auto_stories_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: learningGoals
                .map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: accentColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _eventFeedZone() {
    return _section(
      title: "Live Event Feed",
      icon: Icons.newspaper_rounded,
      child: Column(
        children: eventFeed.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 13.2,
                      color: Color(0xFF334155),
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _bottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _actionButton(
              label: oxygenGiven ? "Oxygen Given" : "Give Oxygen",
              icon: Icons.air_rounded,
              color: const Color(0xFF0EA5E9),
              enabled: !oxygenGiven,
              onTap: _giveOxygen,
            ),
            const SizedBox(width: 10),
            _actionButton(
              label: aspirinGiven ? "Aspirin Given" : "Give Aspirin",
              icon: Icons.medication_rounded,
              color: const Color(0xFF10B981),
              enabled: !aspirinGiven,
              onTap: _giveAspirin,
            ),
            const SizedBox(width: 10),
            _actionButton(
              label: cardiologyCalled ? "Cardiology Called" : "Call Cardiology",
              icon: Icons.call_rounded,
              color: const Color(0xFF7C3AED),
              enabled: !cardiologyCalled,
              onTap: _callCardiology,
            ),
            const SizedBox(width: 10),
            _actionButton(
              label: reassuredPatient ? "Reassured" : "Reassure Patient",
              icon: Icons.sentiment_satisfied_alt_rounded,
              color: const Color(0xFFEA580C),
              enabled: !reassuredPatient,
              onTap: _reassurePatient,
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _topEmergencyHeader(),
        const SizedBox(height: 16),
        _liveAlertBanner(),
        const SizedBox(height: 16),
        _monitorSection(),
        const SizedBox(height: 16),
        _arrivalZone(),
        const SizedBox(height: 16),
        _assessmentZone(),
        const SizedBox(height: 16),
        _investigationsZone(),
        const SizedBox(height: 16),
        _reasoningZone(),
        const SizedBox(height: 16),
        _eventFeedZone(),
        const SizedBox(height: 16),
        _outcomeZone(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width > 1100 ? 34.0 : 18.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF4F8FC),
        iconTheme: const IconThemeData(color: Color(0xFF1F3B5B)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1F3B5B),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      bottomNavigationBar: _bottomActionBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          16,
          horizontalPadding,
          28,
        ),
        child: _body(),
      ),
    );
  }
}

class _MiniMCQ extends StatefulWidget {
  final List<String> choices;
  final int correctIndex;
  final Color accentColor;

  const _MiniMCQ({
    required this.choices,
    required this.correctIndex,
    required this.accentColor,
  });

  @override
  State<_MiniMCQ> createState() => _MiniMCQState();
}

class _MiniMCQState extends State<_MiniMCQ> {
  int? selected;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.choices.length, (index) {
          final isSelected = selected == index;
          final isCorrect = index == widget.correctIndex;
          final isWrongSelected = submitted && isSelected && !isCorrect;

          Color bg = Colors.white;
          Color border = const Color(0xFFE2E8F0);

          if (submitted) {
            if (isCorrect) {
              bg = const Color(0xFFDCFCE7);
              border = const Color(0xFF22C55E);
            } else if (isWrongSelected) {
              bg = const Color(0xFFFEE2E2);
              border = const Color(0xFFEF4444);
            }
          } else if (isSelected) {
            bg = widget.accentColor.withOpacity(0.10);
            border = widget.accentColor;
          }

          return InkWell(
            onTap: submitted ? null : () => setState(() => selected = index),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: border),
              ),
              child: Text(
                widget.choices[index],
                style: const TextStyle(
                  fontSize: 13.3,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 6),
        ElevatedButton(
          onPressed: selected == null || submitted ? null : () => setState(() => submitted = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(submitted ? "Checked" : "Check Interpretation"),
        ),
      ],
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double progress;
  final Color color;

  _PulsePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerY = height / 2;

    path.moveTo(0, centerY);

    for (double x = 0; x <= width; x++) {
      final normalized = (x / width) * 2 * math.pi * 2;
      double y = centerY + math.sin(normalized + progress * 2 * math.pi) * 4;

      final spikeCenter = width * (0.22 + progress * 0.56);
      if ((x - spikeCenter).abs() < 10) {
        y = centerY - 18 + (x - spikeCenter).abs() * 1.8;
      }

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
