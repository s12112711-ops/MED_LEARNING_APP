import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'doctor_students_screen.dart';
import '../auth_screen.dart';
import 'doctor_announcements_screen.dart';
import 'doctor_materials_screen.dart';
import 'doctor_questions_screen.dart';
import 'doctor_quizzes_screen.dart';
import 'doctor_analytics_screen.dart';
import 'doctor_evaluation_review_screen.dart';
//import 'doctor_clinical_reports_screen.dart';
import 'student_reports_list_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const DoctorDashboardScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int unreadTotal = 0;
  Timer? _timer;

  String get _baseUrl =>
      kIsWeb ? 'http://127.0.0.1:5000' : 'http://10.0.2.2:5000';

  // 🌿 Medical Elegant Colors
  static const primary = Color(0xFF2563EB);
  static const secondary = Color(0xFF60A5FA);
  static const bg = Color(0xFFF6F8FC);
  static const card = Colors.white;
  static const textDark = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _fetchUnread();
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchUnread(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnread() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/api/messages/unread-total/${widget.currentUserId}'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() => unreadTotal = data['totalUnread'] ?? 0);
        }
      }
    } catch (_) {}
  }

  // ================= SIDE ITEM =================
  Widget _sideItem({
    required IconData icon,
    required String title,
    required int index,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        tileColor: Colors.transparent,
        leading: Icon(icon, color: isLogout ? Colors.red : primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.red : textDark,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // ================= SIDEBAR =================
  Widget _sidebar() {
    return Container(
      width: 290,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F5FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // 🧑‍⚕️ Doctor Avatar + Info
          Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/3774/3774299.png",
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Dr. ${widget.currentUserName}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),

              // 📧 Email icon added
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.email_outlined, size: 16, color: muted),
                  SizedBox(width: 6),
                  Text(
                    "doctor@hospital.com",
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          _sideItem(
            icon: Icons.campaign_outlined,
            title: "Announcements",
            index: 0,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorAnnouncementsScreen(),
              ),
            ),
          ),

          _sideItem(
            icon: Icons.folder_outlined,
            title: "Materials",
            index: 1,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorMaterialsScreen(),
              ),
            ),
          ),

          _sideItem(
            icon: Icons.quiz_outlined,
            title: "Questions",
            index: 2,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorQuestionsScreen(),
              ),
            ),
          ),

          _sideItem(
            icon: Icons.fact_check_outlined,
            title: "Quizzes",
            index: 3,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorQuizzesScreen(),
              ),
            ),
          ),

          _sideItem(
            icon: Icons.bar_chart_outlined,
            title: "Analytics",
            index: 4,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DoctorAnalyticsScreen(),
              ),
            ),
          ),


          _sideItem(
            icon: Icons.rate_review_outlined,
            title: "Reviews",
            index: 5,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorEvaluationReviewScreen(
                  doctorId: widget.currentUserId,
                  doctorName: widget.currentUserName,
                ),
              ),
            ),
          ),


// ✅ أضف هذا بعده مباشرة
_sideItem(
  icon: Icons.assessment_outlined,
  title: "Student Reports",
  index: 6,
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StudentReportsListScreen(
        doctorId: widget.currentUserId,
      ),
    ),
  ),
),










          const Spacer(),

          _sideItem(
            icon: Icons.logout,
            title: "Logout",
            index: 99,
            isLogout: true,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                (_) => false,
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= HERO =================
  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [primary, secondary],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_hospital, color: Colors.white, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Welcome Dr. ${widget.currentUserName}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= STAT =================
  Widget _stat(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primary),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: muted)),
          ],
        ),
      ),
    );
  }

  // ================= ACTION TILE =================
  Widget _action(IconData icon, String title) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: primary),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ================= MAIN =================
  Widget _main() {
    return Container(
      color: bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(),
            const SizedBox(height: 20),

            Row(
              children: [
                _stat("Messages", "$unreadTotal", Icons.message_outlined),
                const SizedBox(width: 10),
                _stat("Modules", "6", Icons.widgets_outlined),
                const SizedBox(width: 10),
                _stat("Students", "24", Icons.people_outline),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),

            const SizedBox(height: 12),

          Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    _action(Icons.campaign_outlined, "Announcements"),
    _action(Icons.folder_outlined, "Materials"),
    _action(Icons.quiz_outlined, "Quizzes"),
    _action(Icons.bar_chart_outlined, "Analytics"),
    // ✅ أضف هذا
    GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudentReportsListScreen(
            doctorId: widget.currentUserId,
          ),
        ),
      ),
      child: _action(Icons.assessment_outlined, "Student Reports"),
    ),
  ],
),



          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _sidebar(),
          Expanded(child: _main()),
        ],
      ),
    );
  }
}