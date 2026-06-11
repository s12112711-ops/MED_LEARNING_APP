import 'package:flutter/material.dart';
import 'cells_biology_screen.dart';
import 'tissue_structure_screen.dart';
import 'cardiovascular_anatomy_screen.dart';
import 'physiology_screen.dart';
import 'pathology_screen.dart';
import 'clinical_practice_screen.dart';

class LearningModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? route;
  final List<String> tags;
  final double progress;
  final bool isLocked;
  final Color color;

  LearningModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.route,
    this.tags = const [],
    this.progress = 0.0,
    this.isLocked = false,
    required this.color,
  });
}

class CardiovascularScreen extends StatelessWidget {
  CardiovascularScreen({super.key});

  // ── Palette ──
  static const Color navy     = Color(0xFF0B2D48);
  static const Color blue     = Color(0xFF1A6B8A);
  static const Color teal     = Color(0xFF2ABFBF);
  static const Color bg       = Color(0xFFF0F5F9);
  static const Color surface  = Colors.white;
  static const Color border   = Color(0xFFDDE8EF);
  static const Color txtDark  = Color(0xFF0B2D48);
  static const Color txtMuted = Color(0xFF4A6A7D);
  static const Color txtHint  = Color(0xFF8FAAB8);

  final List<LearningModule> levels = [
    LearningModule(
      title: "Cells Biology",
      subtitle: "Cardiac cellular structure and function",
      icon: Icons.biotech,
      route: const CellsBiologyScreen(),
      tags: ["3D", "Interactive"],
      progress: 0.20,
      color: const Color(0xFF4A90E2),
    ),
    LearningModule(
      title: "Tissue Structure",
      subtitle: "Myocardium and vascular tissue layers",
      icon: Icons.layers_outlined,
      route: const TissueStructureScreen(isDarkMode: false),
      tags: ["Histology"],
      progress: 0.0,
      color: const Color(0xFF4DB6AC),
    ),
    LearningModule(
      title: "Cardiovascular Anatomy",
      subtitle: "Heart chambers, valves, vessels and circulation",
      icon: Icons.favorite_border,
      route: const CardiovascularAnatomyScreen(),
      tags: ["3D", "Atlas", "Interactive"],
      progress: 0.0,
      color: const Color(0xFFE57373),
    ),
    LearningModule(
      title: "Physiology",
      subtitle: "Circulation, blood flow and cardiac cycle",
      icon: Icons.show_chart,
      route: const PhysiologyScreen(),
      tags: ["Simulation"],
      progress: 0.0,
      color: const Color(0xFF9575CD),
    ),
    LearningModule(
      title: "Pathology",
      subtitle: "Disease mechanisms and cardiovascular disorders",
      icon: Icons.science_outlined,
      route: const PathologyScreen(),
      tags: ["Cases"],
      progress: 0.0,
      color: const Color(0xFFFFB74D),
    ),
    LearningModule(
      title: "Clinical Practice",
      subtitle: "Diagnosis and treatment scenarios",
      icon: Icons.local_hospital_outlined,
      route: const ClinicalPracticeScreen(),
      tags: ["Clinical", "Simulation"],
      progress: 0.0,
      color: const Color(0xFF26A69A),
    ),
  ];

  double get overallProgress {
    return levels.fold(0.0, (sum, e) => sum + e.progress) / levels.length;
  }

  void _open(BuildContext context, LearningModule item) {
    if (item.isLocked || item.route == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => item.route!));
  }

  // ── Tag chip ──
  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.09),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }

  // ── Hero ──
  Widget _hero() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B2D48), Color(0xFF0D3B5E), Color(0xFF1A6B8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
              color: navy.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 110, height: 110,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: teal.withOpacity(0.07)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.15)),
                      ),
                      child: const Icon(Icons.monitor_heart_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text("Cardiovascular System",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Structured learning from cellular foundations to anatomy, physiology, pathology, and clinical reasoning.",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12.5,
                      height: 1.55),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7, runSpacing: 7,
                  children: [
                    _heroBadge(Icons.menu_book_outlined,
                        "${levels.length} Modules"),
                    _heroBadge(Icons.auto_graph_rounded,
                        "${(overallProgress * 100).toInt()}% Progress"),
                    _heroBadge(Icons.psychology_alt_rounded, "AI Learning"),
                    _heroBadge(Icons.quiz_rounded, "Smart Quiz"),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ── Stats row ──
  Widget _statsRow() {
    return Row(
      children: [
        _statTile("${levels.length}", "Modules",
            Icons.grid_view_rounded, const Color(0xFF4A90E2)),
        const SizedBox(width: 10),
        _statTile("${(overallProgress * 100).toInt()}%", "Completed",
            Icons.check_circle_outline_rounded, const Color(0xFF26A69A)),
        const SizedBox(width: 10),
        _statTile("Active", "AI Tools",
            Icons.psychology_alt_rounded, const Color(0xFF8B78E6)),
      ],
    );
  }

  Widget _statTile(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
                color: navy.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 7),
            Text(value,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: txtDark)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 10.5, color: txtHint)),
          ],
        ),
      ),
    );
  }

  // ── Section label ──
  Widget _sectionLabel(String title, [String subtitle = ""]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 3, height: 26,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [blue, teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: txtDark,
                    letterSpacing: -0.2)),
            if (subtitle.isNotEmpty)
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: txtHint)),
          ],
        ),
      ],
    );
  }

  // ── Progress bar ──
  Widget _progressBar(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 5,
        backgroundColor: const Color(0xFFE9EEF5),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  // ── Featured module ──
  Widget _featured(BuildContext context) {
    final item = levels[2];
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: item.color.withOpacity(0.18), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: item.color.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top accent
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              gradient: LinearGradient(
                  colors: [item.color, item.color.withOpacity(0.6)]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("FEATURED",
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: item.color,
                                    letterSpacing: 0.5)),
                          ),
                          const SizedBox(height: 3),
                          Text(item.title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: txtDark)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.subtitle,
                    style: const TextStyle(
                        fontSize: 12.5, color: txtMuted, height: 1.5)),
                const SizedBox(height: 8),
                Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children:
                        item.tags.map((t) => _tag(t, item.color)).toList()),
                const SizedBox(height: 10),
                _progressBar(item.progress, item.color),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.progress > 0
                            ? "${(item.progress * 100).toInt()}% completed"
                            : "Ready to begin",
                        style: const TextStyle(
                            fontSize: 11.5, color: txtHint),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _open(context, item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Text("Open",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Module card ──
  Widget _moduleCard(BuildContext context, LearningModule item) {
    return GestureDetector(
      onTap: () => _open(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
                color: navy.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: txtDark)),
                      const SizedBox(height: 3),
                      Text(item.subtitle,
                          style: const TextStyle(
                              fontSize: 12,
                              color: txtMuted,
                              height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  item.isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.chevron_right_rounded,
                  size: 18,
                  color: txtHint,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Wrap(
                  spacing: 5,
                  children: item.tags.take(3).map((t) => _tag(t, item.color)).toList(),
                ),
                const Spacer(),
                Text(
                  "${(item.progress * 100).toInt()}%",
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: item.color),
                ),
              ],
            ),
            const SizedBox(height: 7),
            _progressBar(item.progress, item.color),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: txtDark),
        title: const Text("Cardiovascular",
            style: TextStyle(
                color: txtDark,
                fontWeight: FontWeight.w800,
                fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(),
            const SizedBox(height: 14),
            _statsRow(),
            const SizedBox(height: 18),
            _sectionLabel("Featured Module", "Recommended starting point"),
            const SizedBox(height: 10),
            _featured(context),
            const SizedBox(height: 18),
            _sectionLabel("Learning Modules",
                "Choose a module to begin your structured pathway"),
            const SizedBox(height: 10),
            ...levels.map((e) => _moduleCard(context, e)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}