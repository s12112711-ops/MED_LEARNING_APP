import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'clinical_simulation_engine_screen.dart';
import 'medical_knowledge_screen.dart';
import 'student_notifications_screen.dart';
import 'student_chat_popup.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';
import 'doctor_evaluation_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const HomeScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int unreadTotal = 0;
  Timer? _unreadTimer;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // ─── Refined Medical Palette ───────────────────────────────────────────────
  static const Color deepNavy     = Color(0xFF0A2540);
  static const Color clinicalBlue = Color(0xFF1A6B8A);
  static const Color skyTeal      = Color(0xFF2ABFBF);
  static const Color softMint     = Color(0xFFE8F8F5);
  static const Color pureWhite    = Colors.white;
  static const Color bgShell      = Color(0xFFF0F5F9);
  static const Color cardSurface  = Color(0xFFFFFFFF);
  static const Color dividerLine  = Color(0xFFDDE8EF);
  static const Color textPrimary  = Color(0xFF0A2540);
  static const Color textSecond   = Color(0xFF4A6A7D);
  static const Color textHint     = Color(0xFF8FAAB8);
  static const Color accentGold   = Color(0xFFD4A843);
  static const Color accentRed    = Color(0xFFE05C5C);
  static const Color accentGreen  = Color(0xFF36B37E);

  String get _baseUrl =>
      kIsWeb ? 'http://127.0.0.1:5000' : 'http://10.0.2.2:5000';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
    _fetchUnreadCount();
    _unreadTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchUnreadCount(),
    );
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/api/messages/unread-total/${widget.currentUserId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() => unreadTotal = data['totalUnread'] ?? 0);
        }
      }
    } catch (e) {
      debugPrint("Unread error: $e");
    }
  }

  bool get isDesktop => MediaQuery.of(context).size.width >= 1200;
  bool get isTablet  => MediaQuery.of(context).size.width >= 800;
  bool get isMobile  => MediaQuery.of(context).size.width < 800;

  double r(double mo, double ta, double de) {
    if (isDesktop) return de;
    if (isTablet)  return ta;
    return mo;
  }

  // ─── TOP BAR ───────────────────────────────────────────────────────────────
  Widget _topBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r(14, 20, 24),
        vertical:   r(12, 14, 16),
      ),
      decoration: BoxDecoration(
        color: cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerLine, width: 1),
        boxShadow: [
          BoxShadow(
            color: deepNavy.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width:  r(44, 50, 54),
            height: r(44, 50, 54),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [deepNavy, clinicalBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: clinicalBlue.withOpacity(0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: pureWhite,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Title block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MediLearn",
                  style: TextStyle(
                    fontSize: r(15, 18, 20),
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  "Clinical Workspace",
                  style: TextStyle(
                    fontSize: r(11, 12, 13),
                    color: textSecond,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // User chip
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: softMint,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: skyTeal.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [clinicalBlue, skyTeal],
                      ),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: pureWhite, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.currentUserName,
                    style: const TextStyle(
                      color: deepNavy,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Logout
          _iconBtn(
            icon: Icons.logout_rounded,
            tooltip: "تسجيل الخروج",
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
    Color? bg,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: bg ?? const Color(0xFFF0F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: dividerLine),
          ),
          child: Icon(icon, color: textSecond, size: 18),
        ),
      ),
    );
  }

  // ─── HERO ──────────────────────────────────────────────────────────────────
  Widget _heroSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [deepNavy, Color(0xFF0D3B5E), clinicalBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: deepNavy.withOpacity(0.30),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30, right: -30,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: skyTeal.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -40, left: -20,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: clinicalBlue.withOpacity(0.10),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(r(18, 26, 32)),
            child: isMobile
                ? _heroMobile()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: _heroText()),
                      const SizedBox(width: 24),
                      Expanded(flex: 4, child: _heroStatsPanel()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _heroMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heroBadge(),
        const SizedBox(height: 14),
        _heroText(),
        const SizedBox(height: 16),
        _heroStatsPanel(),
        const SizedBox(height: 16),
        _heroCTA(),
      ],
    );
  }

  Widget _heroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: skyTeal.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: skyTeal.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
              color: accentGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            "Student Clinical Zone  •  Active",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile) ...[_heroBadge(), const SizedBox(height: 18)],
        Text(
          "Focused Medical\nLearning & Practice",
          style: TextStyle(
            color: pureWhite,
            fontSize: r(22, 28, 34),
            height: 1.2,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Master clinical skills through structured knowledge, realistic simulation, and professional evaluation.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.72),
            fontSize: r(12.5, 13.5, 14.5),
            height: 1.65,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (!isMobile) ...[const SizedBox(height: 22), _heroCTA()],
      ],
    );
  }

  Widget _heroCTA() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const ClinicalSimulationEngineScreen()),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r(18, 22, 26),
          vertical: r(13, 14, 15),
        ),
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: deepNavy.withOpacity(0.20),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [clinicalBlue, skyTeal],
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: pureWhite, size: 18),
            ),
            const SizedBox(width: 11),
            Text(
              "Launch Clinical Simulation",
              style: TextStyle(
                color: deepNavy,
                fontWeight: FontWeight.w800,
                fontSize: r(13, 14, 14.5),
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded,
                color: clinicalBlue, size: r(16, 17, 18)),
          ],
        ),
      ),
    );
  }

  Widget _heroStatsPanel() {
    return Container(
      padding: EdgeInsets.all(r(14, 16, 18)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "System Overview",
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          _statRow(
            icon: Icons.menu_book_rounded,
            label: "Knowledge Base",
            value: "Ready",
            color: accentGreen,
          ),
          _dividerLine(),
          _statRow(
            icon: Icons.biotech_rounded,
            label: "Simulation Engine",
            value: "Active",
            color: skyTeal,
          ),
          _dividerLine(),
          _statRow(
            icon: Icons.notifications_active_rounded,
            label: "Notifications",
            value: unreadTotal > 0 ? "$unreadTotal New" : "Clear",
            color: unreadTotal > 0 ? accentGold : accentGreen,
          ),
          _dividerLine(),
          _statRow(
            icon: Icons.assignment_turned_in_rounded,
            label: "Evaluations",
            value: "Open",
            color: accentGold,
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() => Divider(
        color: Colors.white.withOpacity(0.08),
        height: 14,
        thickness: 1,
      );

  Widget _statRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ─── SECTION LABEL ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [clinicalBlue, skyTeal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: r(17, 21, 23),
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: r(11.5, 12.5, 13),
                color: textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── PRIMARY FEATURE CARD ──────────────────────────────────────────────────
  Widget _primaryCard({
    required String title,
    required String desc,
    required String tag,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
    String? statsLabel,
    String? statsValue,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: dividerLine),
          boxShadow: [
            BoxShadow(
              color: deepNavy.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header strip
            Container(
              height: r(9, 10, 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                gradient: LinearGradient(colors: gradient),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(r(16, 20, 22)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width:  r(50, 56, 60),
                        height: r(50, 56, 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withOpacity(0.30),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: pureWhite, size: 24),
                      ),
                      const Spacer(),
                      _tagChip(tag),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: r(16, 19, 21),
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: r(12, 13, 13.5),
                      height: 1.6,
                      color: textSecond,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradient),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "Open Module",
                              style: TextStyle(
                                color: pureWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward_rounded,
                                color: pureWhite, size: 15),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (statsLabel != null)
                        _miniStat(statsLabel, statsValue ?? ''),
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

  Widget _tagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: skyTeal.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: clinicalBlue,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: textHint, fontSize: 10.5),
        ),
      ],
    );
  }

  // ─── SECONDARY (SIDE) CARD ─────────────────────────────────────────────────
  Widget _secondaryCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    String? badge,
    bool urgent = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: urgent ? accentRed.withOpacity(0.25) : dividerLine,
          ),
          boxShadow: [
            BoxShadow(
              color: deepNavy.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(r(14, 16, 18)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width:  r(46, 50, 52),
              height: r(46, 50, 52),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: iconColor.withOpacity(0.20),
                ),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: r(14, 15.5, 16),
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (badge != null) _badgeChip(badge, urgent: urgent),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: r(11.5, 12.5, 13),
                      color: textSecond,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeChip(String label, {bool urgent = false}) {
    final color = urgent ? accentRed : accentGold;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ─── LAYOUT ────────────────────────────────────────────────────────────────
  Widget _contentLayout() {
    final knowledgeCard = _primaryCard(
      title: "Medical Knowledge System",
      desc: "Structured educational content, clear learning pathways, and polished academic presentation for effective medical study.",
      tag: "Core Learning",
      icon: Icons.menu_book_rounded,
      gradient: const [Color(0xFF1A6B8A), Color(0xFF2ABFBF)],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MedicalKnowledgeScreen()),
      ),
    );

    final simCard = _primaryCard(
      title: "Clinical Simulation Engine",
      desc: "Practice diagnosis logic, reasoning steps, and applied decision-making in a realistic clinical training environment.",
      tag: "Main Practice",
      icon: Icons.biotech_rounded,
      gradient: const [Color(0xFF0A2540), Color(0xFF1A6B8A)],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const ClinicalSimulationEngineScreen()),
      ),
    );

    final notifCard = _secondaryCard(
      title: "Notifications",
      desc: "Academic updates, doctor announcements, and important learning alerts.",
      icon: Icons.notifications_active_rounded,
      iconColor: accentGold,
      badge: unreadTotal > 0 ? "$unreadTotal New" : null,
      urgent: unreadTotal > 0,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const StudentNotificationsScreen()),
      ),
    );

    final profileCard = _secondaryCard(
      title: "My Profile",
      desc: "Student identity, personal information, and system presence.",
      icon: Icons.person_rounded,
      iconColor: clinicalBlue,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: widget.currentUserId,
            userName: widget.currentUserName,
          ),
        ),
      ),
    );

    final evalCard = _secondaryCard(
      title: "Doctor Evaluation Panel",
      desc: "Submit real clinical cases for review by doctors assigned to your learning path.",
      icon: Icons.assignment_turned_in_rounded,
      iconColor: accentGreen,
      badge: "Academic",
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DoctorEvaluationPanelScreen(
            studentId: widget.currentUserId,
            studentName: widget.currentUserName,
          ),
        ),
      ),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                knowledgeCard,
                const SizedBox(height: 18),
                simCard,
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                notifCard,
                const SizedBox(height: 14),
                profileCard,
                const SizedBox(height: 14),
                evalCard,
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        knowledgeCard,
        const SizedBox(height: 14),
        simCard,
        const SizedBox(height: 14),
        notifCard,
        const SizedBox(height: 14),
        profileCard,
        const SizedBox(height: 14),
        evalCard,
      ],
    );
  }

  // ─── FAB ───────────────────────────────────────────────────────────────────
  Widget _fab() {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => StudentChatPopup(
          currentUserId: widget.currentUserId,
          currentUserName: widget.currentUserName,
        ),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [deepNavy, clinicalBlue],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: deepNavy.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble_rounded,
                    color: pureWhite, size: 21),
                if (unreadTotal > 0)
                  Positioned(
                    top: -6, right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: accentRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: pureWhite, width: 1.5),
                      ),
                      child: Text(
                        unreadTotal > 9 ? "9+" : "$unreadTotal",
                        style: const TextStyle(
                          color: pureWhite,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 9),
            const Text(
              "Chat",
              style: TextStyle(
                color: pureWhite,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgShell,
      floatingActionButton: _fab(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: r(12, 20, 32),
              vertical:   r(10, 14, 16),
            ),
            child: Column(
              children: [
                _topBar(),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: r(100, 80, 80)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _heroSection(),
                        SizedBox(height: r(22, 26, 30)),
                        _sectionLabel(
                          "Core Academic Flow",
                          "Study · Simulate · Evaluate",
                        ),
                        SizedBox(height: r(14, 16, 18)),
                        _contentLayout(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }
}