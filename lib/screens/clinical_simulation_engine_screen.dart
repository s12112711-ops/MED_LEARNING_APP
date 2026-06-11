import 'package:flutter/material.dart';
import 'simulation_case_bank_screen.dart';

class SimulationModule {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String level;
  final String status;
  final List<String> tags;
  final bool isReady;

  const SimulationModule({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.level,
    required this.status,
    required this.tags,
    required this.isReady,
  });
}

class ClinicalSimulationEngineScreen extends StatelessWidget {
  const ClinicalSimulationEngineScreen({super.key});

  static const Color deepNavy     = Color(0xFF0A2540);
  static const Color clinicalBlue = Color(0xFF1A6B8A);
  static const Color skyTeal      = Color(0xFF2ABFBF);
  static const Color bgShell      = Color(0xFFF0F5F9);
  static const Color cardSurface  = Color(0xFFFFFFFF);
  static const Color dividerLine  = Color(0xFFDDE8EF);
  static const Color textPrimary  = Color(0xFF0A2540);
  static const Color textSecond   = Color(0xFF4A6A7D);
  static const Color textHint     = Color(0xFF8FAAB8);
  static const Color accentGold   = Color(0xFFD4A843);
  static const Color accentRed    = Color(0xFFE05C5C);
  static const Color accentGreen  = Color(0xFF36B37E);

  List<SimulationModule> get readyModules => const [
        SimulationModule(
          title: "Simulation Case Bank",
          subtitle: "Start from multiple structured clinical cases",
          description:
              "Browse progressive cardiovascular cases, open one case at a time, reveal evidence gradually, and move through a realistic diagnostic sequence.",
          icon: Icons.folder_special_rounded,
          color: Color(0xFF0F766E),
          level: "Core Module",
          status: "Ready Now",
          tags: ["Multi-Case", "Timeline", "Evidence"],
          isReady: true,
        ),
      ];

  List<SimulationModule> get futureModules => const [
        SimulationModule(
          title: "Image-Based Diagnosis",
          subtitle: "Interpret pathology and visual clues",
          description:
              "Analyze pathology slides, gross images, and visual evidence as part of structured clinical reasoning.",
          icon: Icons.image_search_rounded,
          color: Color(0xFF7C3AED),
          level: "Advanced",
          status: "Planned",
          tags: ["Histology", "Imaging", "Visual"],
          isReady: false,
        ),
        SimulationModule(
          title: "ECG & Lab Reasoning",
          subtitle: "Connect patterns to diagnosis",
          description:
              "Train on ECG changes, troponin, BNP, electrolyte shifts, and evidence correlation inside guided cases.",
          icon: Icons.monitor_heart_rounded,
          color: Color(0xFFE05C5C),
          level: "Advanced",
          status: "Planned",
          tags: ["ECG", "Labs", "Cardiology"],
          isReady: false,
        ),
        SimulationModule(
          title: "Emergency Response",
          subtitle: "Time-sensitive critical care logic",
          description:
              "Manage unstable patients, prioritize immediate escalation, and make urgent decisions under pressure.",
          icon: Icons.emergency_rounded,
          color: Color(0xFFD4A843),
          level: "Expert",
          status: "Planned",
          tags: ["Urgency", "Critical", "Timer"],
          isReady: false,
        ),
      ];

  // ── Tag chip ──
  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.2)),
    );
  }

  // ── Hero ──
  Widget _hero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [deepNavy, Color(0xFF0D3B5E), clinicalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
              color: deepNavy.withOpacity(0.22),
              blurRadius: 24,
              offset: const Offset(0, 10))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: skyTeal.withOpacity(0.07)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.16)),
                      ),
                      child: const Icon(Icons.science_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Clinical Simulation Engine",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 2),
                        Row(children: [
                          Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                  color: accentGreen,
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 5),
                          Text("Engine Active",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11.5)),
                        ]),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  "Guided clinical reasoning — choose a case, reveal evidence step by step, and move through a realistic diagnostic pathway.",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 13,
                      height: 1.6),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _heroBadge(Icons.folder_special_rounded, "Case-Based"),
                    _heroBadge(Icons.route_rounded, "Step-by-Step"),
                    _heroBadge(Icons.psychology_alt_rounded, "Reasoning"),
                    _heroBadge(Icons.monitor_heart_rounded, "Evidence Driven"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11)),
        ],
      ),
    );
  }

  // ── Stats row ──
  Widget _statsRow() {
    return Row(
      children: [
        _statTile("Case Bank", "Start Point",
            Icons.play_circle_fill_rounded, accentGreen),
        const SizedBox(width: 10),
        _statTile("1 Module", "Ready Now",
            Icons.check_circle_outline_rounded, skyTeal),
        const SizedBox(width: 10),
        _statTile("3 Steps", "Choose→Analyze→Decide",
            Icons.auto_awesome_motion_rounded, accentGold),
      ],
    );
  }

  Widget _statTile(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: dividerLine),
          boxShadow: [
            BoxShadow(
                color: deepNavy.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: textPrimary)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: textHint)),
          ],
        ),
      ),
    );
  }

  // ── Section label ──
  Widget _sectionLabel(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3, height: 30,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [clinicalBlue, skyTeal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    letterSpacing: -0.2)),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  style: const TextStyle(fontSize: 11.5, color: textHint)),
          ],
        ),
      ],
    );
  }

  // ── Workflow steps ──
  Widget _workflowSteps(bool isTablet) {
    final steps = [
      _StepData("01", "Choose a Case",
          "Open the case bank and select one structured scenario.",
          Icons.folder_open_rounded, accentGreen),
      _StepData("02", "Reveal Evidence",
          "Case unfolds through history, vitals, exam, ECG, labs, and clues.",
          Icons.visibility_rounded, clinicalBlue),
      _StepData("03", "Make Decisions",
          "Form impression, reach diagnosis, choose action, get feedback.",
          Icons.task_alt_rounded, accentRed),
    ];

    if (isTablet) {
      return Row(
        children: steps.expand((s) => [
          Expanded(child: _stepCard(s)),
          if (s != steps.last) const SizedBox(width: 10),
        ]).toList(),
      );
    }
    return Column(
      children: steps.expand((s) => [
        _stepCard(s),
        if (s != steps.last) const SizedBox(height: 10),
      ]).toList(),
    );
  }

  Widget _stepCard(_StepData s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: dividerLine),
        boxShadow: [
          BoxShadow(
              color: deepNavy.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: s.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6)),
                child: Text("STEP ${s.step}",
                    style: TextStyle(
                        color: s.color,
                        fontWeight: FontWeight.w800,
                        fontSize: 9.5,
                        letterSpacing: 0.5)),
              ),
              const Spacer(),
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                    color: s.color.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(9)),
                child: Icon(s.icon, color: s.color, size: 17),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(s.title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: textPrimary)),
          const SizedBox(height: 5),
          Text(s.desc,
              style: const TextStyle(
                  fontSize: 11.5, color: textSecond, height: 1.5)),
        ],
      ),
    );
  }

  // ── Start here card ──
  Widget _startCard(BuildContext context) {
    final item = readyModules.first;
    return Container(
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: item.color.withOpacity(0.18), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: item.color.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top accent strip
          Container(
            height: 5,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              gradient:
                  LinearGradient(colors: [item.color, skyTeal]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // badges
                Row(
                  children: [
                    _inlineBadge("START HERE", item.color),
                    const SizedBox(width: 7),
                    _inlineBadge("READY NOW", accentGreen),
                    const Spacer(),
                    _tag(item.level, item.color),
                  ],
                ),
                const SizedBox(height: 14),

                // icon + title
                Row(
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: item.color.withOpacity(0.2)),
                      ),
                      child: Icon(item.icon, color: item.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: textPrimary,
                                  letterSpacing: -0.2)),
                          const SizedBox(height: 3),
                          Text(item.subtitle,
                              style: const TextStyle(
                                  fontSize: 12, color: textSecond)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(item.description,
                    style: const TextStyle(
                        fontSize: 13,
                        color: textSecond,
                        height: 1.6)),

                const SizedBox(height: 10),
                Wrap(
                  spacing: 7, runSpacing: 7,
                  children: item.tags
                      .map((e) => _tag(e, textHint))
                      .toList(),
                ),

                const SizedBox(height: 14),

                // what student does
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: bgShell,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: dividerLine),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("What will the student do?",
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: textPrimary)),
                      const SizedBox(height: 10),
                      _stepLine("1", "Choose one clinical case"),
                      const SizedBox(height: 6),
                      _stepLine("2",
                          "Move through triage, impression, evidence, diagnosis, and action"),
                      const SizedBox(height: 6),
                      _stepLine(
                          "3", "Receive structured clinical feedback"),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // CTA
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const SimulationCaseBankScreen())),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            item.color,
                            item.color.withOpacity(0.8)
                          ]),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                            color: item.color.withOpacity(0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text("Open Simulation Case Bank",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                      ],
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

  Widget _inlineBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 9.5,
              letterSpacing: 0.3)),
    );
  }

  Widget _stepLine(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(
              color: clinicalBlue.withOpacity(0.1),
              shape: BoxShape.circle),
          child: Center(
            child: Text(num,
                style: const TextStyle(
                    color: clinicalBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12, color: textSecond, height: 1.5)),
        ),
      ],
    );
  }

  // ── Future module card ──
  Widget _futureCard(SimulationModule item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: item.color.withOpacity(0.13)),
        boxShadow: [
          BoxShadow(
              color: deepNavy.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: item.color.withOpacity(0.18)),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                            letterSpacing: -0.2)),
                    const SizedBox(height: 2),
                    Text(item.subtitle,
                        style: const TextStyle(
                            fontSize: 11, color: textSecond)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.description,
              style: const TextStyle(
                  fontSize: 12.5, color: textSecond, height: 1.55)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: [
              _tag(item.level, item.color),
              _tag(item.status, accentGold),
              ...item.tags.map((e) => _tag(e, textHint)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: item.color.withOpacity(0.16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_clock_rounded,
                    color: item.color, size: 14),
                const SizedBox(width: 6),
                Text("Planned Module",
                    style: TextStyle(
                        color: item.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 1100;
    final bool isTablet  = width > 700;
    final int futureCols = width > 1200 ? 3 : (width > 800 ? 2 : 1);

    return Scaffold(
      backgroundColor: bgShell,
      appBar: AppBar(
        backgroundColor: bgShell,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
        title: Row(
          children: [
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [deepNavy, clinicalBlue]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.science_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 9),
            const Text("Clinical Simulation Engine",
                style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: -0.2)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(),
            const SizedBox(height: 16),
            _statsRow(),
            const SizedBox(height: 22),

            _sectionLabel("How it works", "The intended student journey"),
            const SizedBox(height: 12),
            _workflowSteps(isTablet),
            const SizedBox(height: 22),

            _sectionLabel("Start Here", "Active module ready to launch"),
            const SizedBox(height: 12),
            _startCard(context),
            const SizedBox(height: 22),

            _sectionLabel("Coming Next",
                "Modules expanding the simulation engine"),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: futureModules.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: futureCols,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: width > 1200 ? 1.1 : 0.95,
              ),
              itemBuilder: (_, i) => _futureCard(futureModules[i]),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StepData {
  final String step;
  final String title;
  final String desc;
  final IconData icon;
  final Color color;

  const _StepData(
      this.step, this.title, this.desc, this.icon, this.color);
}