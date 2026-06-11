import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/fake_ai_service.dart';

enum PhysiologyPhase {
  atrialSystole,
  ventricularSystole,
  diastole,
}

class FlowNode {
  final String title;
  final String note;
  final String oxygenState;
  final IconData icon;
  final Color color;

  const FlowNode({
    required this.title,
    required this.note,
    required this.oxygenState,
    required this.icon,
    required this.color,
  });
}

class PhysiologyScreen extends StatefulWidget {
  const PhysiologyScreen({super.key});

  @override
  State<PhysiologyScreen> createState() => _PhysiologyScreenState();
}

class _PhysiologyScreenState extends State<PhysiologyScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartBeatController;
  late AnimationController _flowController;

  double heartRate = 72;
  PhysiologyPhase selectedPhase = PhysiologyPhase.diastole;
  int selectedFlowIndex = 0;

  bool isAiLoading = false;
  String aiResultTitle = "MediLearn AI Assistant";
  String aiResult =
      "Use the smart tools below to simplify physiology, generate summary notes, create questions, or explain the clinical meaning.";
  Color aiAccentColor = const Color(0xFF8B5CF6);

  final List<FlowNode> flowNodes = const [
    FlowNode(
      title: "Body",
      note: "Systemic tissues send deoxygenated blood back toward the heart.",
      oxygenState: "Deoxygenated",
      icon: Icons.accessibility_new_rounded,
      color: Color(0xFF607D8B),
    ),
    FlowNode(
      title: "Right Atrium",
      note: "Receives deoxygenated blood from the venae cavae.",
      oxygenState: "Deoxygenated",
      icon: Icons.circle_rounded,
      color: Color(0xFF42A5F5),
    ),
    FlowNode(
      title: "Right Ventricle",
      note: "Pumps blood toward the pulmonary trunk and lungs.",
      oxygenState: "Deoxygenated",
      icon: Icons.favorite_border_rounded,
      color: Color(0xFF29B6F6),
    ),
    FlowNode(
      title: "Lungs",
      note: "Gas exchange occurs here and blood becomes oxygenated.",
      oxygenState: "Oxygenated",
      icon: Icons.air_rounded,
      color: Color(0xFF26A69A),
    ),
    FlowNode(
      title: "Left Atrium",
      note: "Receives oxygenated blood returning from the lungs.",
      oxygenState: "Oxygenated",
      icon: Icons.circle_rounded,
      color: Color(0xFF66BB6A),
    ),
    FlowNode(
      title: "Left Ventricle",
      note: "Pumps oxygenated blood into the aorta and systemic circulation.",
      oxygenState: "Oxygenated",
      icon: Icons.favorite_rounded,
      color: Color(0xFFE57373),
    ),
    FlowNode(
      title: "Aorta / Body",
      note: "Blood is distributed to the systemic circulation.",
      oxygenState: "Oxygenated",
      icon: Icons.alt_route_rounded,
      color: Color(0xFFFFA726),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _heartBeatController = AnimationController(
      vsync: this,
      duration: _durationFromHeartRate(),
    )..repeat(reverse: true);

    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _heartBeatController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  Duration _durationFromHeartRate() {
    final ms = (60000 / heartRate).round();
    return Duration(milliseconds: ms.clamp(350, 1400));
  }

  void _updateHeartRate(double value) {
    setState(() {
      heartRate = value;
      _heartBeatController.duration = _durationFromHeartRate();
      _heartBeatController.repeat(reverse: true);
    });
  }

  Color get phaseColor {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return const Color(0xFF26A69A);
      case PhysiologyPhase.ventricularSystole:
        return const Color(0xFFE57373);
      case PhysiologyPhase.diastole:
        return const Color(0xFF4A90E2);
    }
  }

  String get phaseTitle {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return "Atrial Systole";
      case PhysiologyPhase.ventricularSystole:
        return "Ventricular Systole";
      case PhysiologyPhase.diastole:
        return "Diastole";
    }
  }

  String get phaseExplanation {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return "The atria contract and push the remaining blood into the ventricles. This completes ventricular filling before the main ventricular contraction begins.";
      case PhysiologyPhase.ventricularSystole:
        return "The ventricles contract strongly, AV valves close, semilunar valves open, and blood is ejected into the pulmonary trunk and aorta.";
      case PhysiologyPhase.diastole:
        return "The heart chambers relax and fill with blood. Ventricular pressure falls, allowing passive filling through the AV valves.";
    }
  }

  String get activeValves {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return "Tricuspid & Mitral: Open • Pulmonary & Aortic: Closed";
      case PhysiologyPhase.ventricularSystole:
        return "Tricuspid & Mitral: Closed • Pulmonary & Aortic: Open";
      case PhysiologyPhase.diastole:
        return "Tricuspid & Mitral: Open • Pulmonary & Aortic: Closed";
    }
  }

  String get bloodFlowNote {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return "Blood moves from atria to ventricles.";
      case PhysiologyPhase.ventricularSystole:
        return "Blood moves from ventricles to lungs and body.";
      case PhysiologyPhase.diastole:
        return "Blood returns to the heart and refills the chambers.";
    }
  }

  double get cardiacOutputEstimate {
    const strokeVolume = 70.0;
    return (heartRate * strokeVolume) / 1000.0;
  }

  String get heartRateStatus {
    if (heartRate < 60) return "Low resting rate";
    if (heartRate <= 100) return "Normal resting range";
    return "Elevated rate";
  }

  String get pressureInsight {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return "Atrial pressure rises slightly to complete ventricular filling.";
      case PhysiologyPhase.ventricularSystole:
        return "Ventricular pressure rises sharply and exceeds arterial pressure.";
      case PhysiologyPhase.diastole:
        return "Chamber pressure falls and passive filling becomes possible.";
    }
  }

  int get activeFlowIndex {
    switch (selectedPhase) {
      case PhysiologyPhase.atrialSystole:
        return 1;
      case PhysiologyPhase.ventricularSystole:
        return 2;
      case PhysiologyPhase.diastole:
        return 0;
    }
  }

  Future<void> _handleAIAction(String action) async {
    setState(() {
      isAiLoading = true;
      aiResultTitle = "Analyzing Cardiac Physiology...";
    });

    try {
      String result = "";
      String title = "";
      Color accent = phaseColor;

      const topic = "Cardiac Physiology";
      final description =
          "Cardiac physiology explains how the heart contracts, relaxes, pumps blood, and maintains circulation through coordinated chamber activity, valve action, blood flow direction, and pressure changes.";

      if (action == "simplify") {
        title = "Simplified Physiology";
        accent = const Color(0xFF8B5CF6);
        result = await FakeAIService.simplifyTopic(
          topic: topic,
          content: description,
        );
      } else if (action == "summary") {
        title = "Smart Summary";
        accent = const Color(0xFF26A69A);
        result = await FakeAIService.generateSummary(
          topic: topic,
          content: description,
          bullets: [
            "The cardiac cycle includes systole and diastole",
            "Valve opening depends on pressure differences",
            "Heart rate affects cardiac output",
            "Blood flow direction must remain one-way",
          ],
        );
      } else if (action == "questions") {
        title = "Practice Questions";
        accent = const Color(0xFFF4A641);
        result = await FakeAIService.generateQuestions(topic: topic);
      } else if (action == "clinical") {
        title = "Clinical Insight";
        accent = const Color(0xFFE35D6A);
        result = await FakeAIService.generateClinicalInsight(
          topic: topic,
          clinicalNote:
              "Abnormal cardiac physiology can lead to arrhythmias, valve dysfunction, reduced cardiac output, poor perfusion, and heart failure.",
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentNode = flowNodes[selectedFlowIndex];

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
          "Physiology",
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
            _buildMonitorRow(isDark),
            const SizedBox(height: 18),
            _buildSimulatorPanel(isDark),
            const SizedBox(height: 18),
            _buildCyclePanel(isDark),
            const SizedBox(height: 18),
            _buildValvesPanel(isDark),
            const SizedBox(height: 18),
            _buildFlowPathPanel(isDark, currentNode),
            const SizedBox(height: 18),
            _buildAiPanel(isDark),
            const SizedBox(height: 18),
            _buildClinicalPanel(isDark),
            const SizedBox(height: 18),
            _buildMiniChallengePanel(isDark),
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
            Color(0xFF4E3B8A),
            Color(0xFF6B56B3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E3B8A).withOpacity(0.22),
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
                  Icons.monitor_heart_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Cardiac Physiology Lab",
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
            "Explore how the heart functions as a dynamic pump through heart rate simulation, cycle analysis, valve behavior, blood flow interaction, and smart learning tools.",
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
              _heroChip(Icons.speed_rounded, "${heartRate.toInt()} bpm"),
              _heroChip(Icons.water_drop_rounded,
                  "${cardiacOutputEstimate.toStringAsFixed(1)} L/min"),
              _heroChip(Icons.loop_rounded, phaseTitle),
              _heroChip(Icons.monitor_heart_outlined, heartRateStatus),
            ],
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

  Widget _buildMonitorRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _monitorTile(
            isDark,
            title: "Heart Rate",
            value: "${heartRate.toInt()} bpm",
            icon: Icons.favorite_rounded,
            color: const Color(0xFFE57373),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _monitorTile(
            isDark,
            title: "Output",
            value: "${cardiacOutputEstimate.toStringAsFixed(1)} L/min",
            icon: Icons.water_drop_rounded,
            color: const Color(0xFF26A69A),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _monitorTile(
            isDark,
            title: "Phase",
            value: phaseTitle,
            icon: Icons.sync_rounded,
            color: phaseColor,
          ),
        ),
      ],
    );
  }

  Widget _monitorTile(
    bool isDark, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
              fontSize: 14.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorPanel(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Heart Pump Simulator",
            Icons.favorite_rounded,
            const Color(0xFFE35D6A),
          ),
          const SizedBox(height: 16),
          Center(
            child: AnimatedBuilder(
              animation: _heartBeatController,
              builder: (context, _) {
                final scale = 1 + (_heartBeatController.value * 0.16);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: phaseColor.withOpacity(0.10),
                      boxShadow: [
                        BoxShadow(
                          color: phaseColor.withOpacity(0.35),
                          blurRadius: 28,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 80,
                      color: phaseColor,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Adjust Heart Rate",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w700,
            ),
          ),
          Slider(
            value: heartRate,
            min: 40,
            max: 160,
            divisions: 120,
            label: "${heartRate.toInt()} bpm",
            onChanged: _updateHeartRate,
          ),
          const SizedBox(height: 8),
          Text(
            "Changing the heart rate changes how fast the simulated heart beats and affects the estimated cardiac output.",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCyclePanel(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Cardiac Cycle Control",
            Icons.sync_rounded,
            const Color(0xFF4A90E2),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _phaseButton(
                isDark,
                "Atrial Systole",
                PhysiologyPhase.atrialSystole,
                const Color(0xFF26A69A),
              ),
              _phaseButton(
                isDark,
                "Ventricular Systole",
                PhysiologyPhase.ventricularSystole,
                const Color(0xFFE57373),
              ),
              _phaseButton(
                isDark,
                "Diastole",
                PhysiologyPhase.diastole,
                const Color(0xFF4A90E2),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: phaseColor.withOpacity(0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phaseTitle,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  phaseExplanation,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 14),
                _infoLine(isDark, "Flow", bloodFlowNote),
                const SizedBox(height: 8),
                _infoLine(isDark, "Pressure", pressureInsight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValvesPanel(bool isDark) {
    final avOpen = selectedPhase != PhysiologyPhase.ventricularSystole;
    final semilunarOpen = selectedPhase == PhysiologyPhase.ventricularSystole;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Valve Status Panel",
            Icons.tune_rounded,
            const Color(0xFFFFA726),
          ),
          const SizedBox(height: 14),
          _valveRow(
            isDark,
            "Tricuspid Valve",
            avOpen,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 10),
          _valveRow(
            isDark,
            "Mitral Valve",
            avOpen,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 10),
          _valveRow(
            isDark,
            "Pulmonary Valve",
            semilunarOpen,
            const Color(0xFFE57373),
          ),
          const SizedBox(height: 10),
          _valveRow(
            isDark,
            "Aortic Valve",
            semilunarOpen,
            const Color(0xFFE57373),
          ),
          const SizedBox(height: 14),
          Text(
            activeValves,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              height: 1.55,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _valveRow(bool isDark, String title, bool isOpen, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isOpen
            ? color.withOpacity(0.12)
            : (isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOpen ? color : const Color(0xFFDDE6EF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOpen ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
            color: isOpen ? color : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF102033),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            isOpen ? "Open" : "Closed",
            style: TextStyle(
              color: isOpen ? color : const Color(0xFF94A3B8),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowPathPanel(bool isDark, FlowNode currentNode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Blood Flow Interaction",
            Icons.alt_route_rounded,
            const Color(0xFF26A69A),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(flowNodes.length, (index) {
                final node = flowNodes[index];
                final isSelected = selectedFlowIndex == index;
                final isPhaseActive = activeFlowIndex == index;

                return Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() {
                          selectedFlowIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? node.color.withOpacity(0.18)
                              : (isDark
                                  ? const Color(0xFF0B1220)
                                  : const Color(0xFFF8FBFF)),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? node.color
                                : (isPhaseActive
                                    ? phaseColor
                                    : const Color(0xFFDDE6EF)),
                            width: isPhaseActive ? 1.8 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(node.icon, color: node.color, size: 20),
                            const SizedBox(height: 6),
                            Text(
                              node.title,
                              style: TextStyle(
                                color: isSelected
                                    ? node.color
                                    : (isDark
                                        ? Colors.white70
                                        : const Color(0xFF334155)),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != flowNodes.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AnimatedBuilder(
                          animation: _flowController,
                          builder: (context, _) {
                            final wave = math.sin(
                              (_flowController.value * 2 * math.pi) +
                                  (index * 0.7),
                            );
                            return Transform.translate(
                              offset: Offset(0, wave * 2),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: isPhaseActive
                                    ? phaseColor
                                    : const Color(0xFF94A3B8),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: currentNode.color.withOpacity(0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNode.title,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF102033),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  currentNode.note,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF475569),
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                _infoLine(isDark, "Blood Type", currentNode.oxygenState),
              ],
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

  Widget _buildClinicalPanel(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF2A1515), Color(0xFF1A1010)],
              )
            : const LinearGradient(
                colors: [Color(0xFFFFF7ED), Color(0xFFFFFBF5)],
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Clinical Relevance",
            Icons.health_and_safety_rounded,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 14),
          Text(
            "Abnormal physiology can lead to arrhythmias, valve dysfunction, reduced cardiac output, reduced tissue perfusion, and cardiovascular instability. Understanding the normal cycle is essential before studying disease.",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF7C2D12),
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChallengePanel(bool isDark) {
    final expectedAnswer = selectedPhase == PhysiologyPhase.ventricularSystole
        ? "Semilunar valves open"
        : "AV valves open";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            isDark,
            "Mini Challenge",
            Icons.bolt_rounded,
            const Color(0xFF8B5CF6),
          ),
          const SizedBox(height: 14),
          Text(
            "Based on the currently selected phase, what is the most important valve event?",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B1220) : const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: phaseColor.withOpacity(0.30),
              ),
            ),
            child: Text(
              expectedAnswer,
              style: TextStyle(
                color: phaseColor,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _phaseButton(
    bool isDark,
    String label,
    PhysiologyPhase phase,
    Color color,
  ) {
    final isActive = selectedPhase == phase;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          selectedPhase = phase;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: isActive
              ? color.withOpacity(0.16)
              : (isDark ? const Color(0xFF111827) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color : const Color(0xFFDDE6EF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? color
                : (isDark ? Colors.white70 : const Color(0xFF334155)),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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

  Widget _infoLine(bool isDark, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            "$label:",
            style: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF102033),
              fontWeight: FontWeight.w600,
              height: 1.45,
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