import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'home_screen.dart';
import 'forgot_password_screen.dart';
import 'admin_login_screen.dart';
import 'doctor/doctor_dashboard_screen.dart';
import '../services/push_notification_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String selectedRole = "student";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  static const Color navy = Color(0xFF0B2D48);
  static const Color teal = Color(0xFF0A7C86);
  static const Color bgColor = Color(0xFFF0F5F9);
  static const Color textDark = Color(0xFF0B2D48);
  static const Color textMuted = Color(0xFF627D98);
  static const Color borderColor = Color(0xFFDDE6EF);

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  Color get activeColor => selectedRole == "doctor" ? navy : teal;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (!isLogin && name.isEmpty) { _showError("Full name is required"); return; }
    if (email.isEmpty) { _showError("Email is required"); return; }
    if (!email.contains("@")) { _showError("Enter a valid email"); return; }
    if (password.isEmpty) { _showError("Password is required"); return; }
    if (password.length < 6) { _showError("Password must be at least 6 characters"); return; }
    if (!isLogin && confirmPassword.isEmpty) { _showError("Confirm password is required"); return; }
    if (!isLogin && password != confirmPassword) { _showError("Passwords do not match"); return; }

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final url = isLogin
          ? Uri.parse("$baseUrl/api/auth/login")
          : Uri.parse("$baseUrl/api/auth/register");

      final body = isLogin
          ? {"email": email, "password": password, "role": selectedRole}
          : {"fullName": name, "email": email, "password": password, "role": selectedRole};

      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      final Map<String, dynamic> data = jsonDecode(response.body);
      if (!mounted) return;
      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogin) {
          final String role = (data["role"] ??
              (data["user"] is Map ? data["user"]["role"] : null) ??
              selectedRole).toString().toLowerCase();
          final String userId = (data["_id"] ?? data["id"] ?? data["userId"] ??
              (data["user"] is Map ? data["user"]["_id"] : null) ?? "").toString();
          final String userName = (data["name"] ?? data["fullName"] ??
              data["username"] ??
              (data["user"] is Map ? data["user"]["name"] : null) ??
              email.split("@").first).toString();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', userId);
          await prefs.setString('userName', userName);
          await prefs.setString('role', role);

          if (role == "student" && userId.isNotEmpty) {
            await PushNotificationService.initialize(currentUserId: userId);
          }
          if (!mounted) return;

          if (role == "doctor") {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => DoctorDashboardScreen(
                  currentUserId: userId, currentUserName: userName)));
          } else {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => HomeScreen(
                  currentUserId: userId, currentUserName: userName)));
          }
        } else {
          setState(() => isLogin = true);
          nameController.clear(); emailController.clear();
          passController.clear(); confirmController.clear();
          _showSuccess("Account created. Please login.");
        }
      } else {
        _showError(data["message"] ?? "Something went wrong");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _showError("Connection error: $e");
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700));

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green.shade700));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Scaffold(
      body: Stack(
        children: [
          // خلفية متدرجة
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF062435), Color(0xFF0B3D52), Color(0xFF0D6470)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // خلفية طبية
          const Positioned.fill(child: _MedicalBackground()),

          // المحتوى
          SafeArea(
            child: isWide
                ? _wideLayout(size)
                : _mobileLayout(),
          ),
        ],
      ),
    );
  }

  // ── Wide Layout ──
  Widget _wideLayout(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          // يسار
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شعار
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: teal,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.local_hospital_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "MediLearn",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    "Advanced Medical\nEducation Platform",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Train smarter with AI-powered clinical cases,\ndoctor evaluations, and real-time analytics.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _featureItem(Icons.psychology_rounded,
                      "AI Clinical Cases", "Simulate real patient scenarios"),
                  const SizedBox(height: 18),
                  _featureItem(Icons.rate_review_rounded,
                      "Doctor Feedback", "Expert specialist evaluations"),
                  const SizedBox(height: 18),
                  _featureItem(Icons.insert_chart_rounded,
                      "Performance Reports", "Track your academic progress"),

                  const SizedBox(height: 48),

                  Row(
                    children: [
                      _miniStat("500+", "Students"),
                      _dividerV(),
                      _miniStat("50+", "Doctors"),
                      _dividerV(),
                      _miniStat("1000+", "Cases"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 48),

          // يمين — الفورم
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _formCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile Layout ──
  Widget _mobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // هيدر للجوال
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: teal.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.local_hospital_rounded,
                      color: Colors.white, size: 30),
                ),
                const SizedBox(height: 14),
                const Text(
                  "MediLearn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Advanced Medical Education Platform",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 20),

                // إحصائيات مبسطة للجوال
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _miniStat("500+", "Students"),
                      _dividerV(),
                      _miniStat("50+", "Doctors"),
                      _dividerV(),
                      _miniStat("1000+", "Cases"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // الفورم
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: _formCard(),
          ),
        ],
      ),
    );
  }

  // ── Form Card ──
  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLogin ? "Sign In" : "Create Account",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isLogin
                ? "Access your medical learning dashboard"
                : "Join the MediLearn platform today",
            style: const TextStyle(fontSize: 13, color: textMuted),
          ),

          const SizedBox(height: 20),

          // Role selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                _roleTab("student", "Student", Icons.school_rounded),
                _roleTab("doctor", "Doctor", Icons.medical_services_rounded),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Login/Signup tabs
          Row(
            children: [
              _tabBtn("Login", isLogin),
              const SizedBox(width: 18),
              _tabBtn("Sign Up", !isLogin),
            ],
          ),

          const SizedBox(height: 18),

          if (!isLogin) ...[
            _field(nameController, "Full Name",
                Icons.person_outline_rounded),
            const SizedBox(height: 12),
          ],

          _field(
            emailController,
            selectedRole == "doctor" ? "Doctor Email" : "Student Email",
            Icons.email_outlined,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),

          _field(
            passController, "Password", Icons.lock_outline_rounded,
            obscure: obscurePassword,
            onToggle: () =>
                setState(() => obscurePassword = !obscurePassword),
          ),

          if (isLogin) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen())),
                child: Text("Forgot password?",
                    style: TextStyle(
                        color: activeColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],

          if (!isLogin) ...[
            const SizedBox(height: 12),
            _field(
              confirmController, "Confirm Password",
              Icons.lock_reset_outlined,
              obscure: obscureConfirmPassword,
              onToggle: () => setState(
                  () => obscureConfirmPassword = !obscureConfirmPassword),
            ),
          ],

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(
                      isLogin
                          ? (selectedRole == "doctor"
                              ? "Doctor Login"
                              : "Student Login")
                          : (selectedRole == "doctor"
                              ? "Create Doctor Account"
                              : "Create Student Account"),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
            ),
          ),

          const SizedBox(height: 14),

          Center(
            child: GestureDetector(
              onTap: () => setState(() => isLogin = !isLogin),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: textMuted),
                  children: [
                    TextSpan(
                        text: isLogin
                            ? "Don't have an account? "
                            : "Already have an account? "),
                    TextSpan(
                        text: isLogin ? "Sign Up" : "Login",
                        style: TextStyle(
                            color: activeColor,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: borderColor),
          ),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminLoginScreen())),
              child: const Text("Admin Login",
                  style: TextStyle(
                      color: textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleTab(String role, String label, IconData icon) {
    final bool selected = selectedRole == role;
    final Color color = role == "doctor" ? navy : teal;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17,
                  color: selected ? Colors.white : textMuted),
              const SizedBox(width: 7),
              Text(label,
                  style: TextStyle(
                      color: selected ? Colors.white : textMuted,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBtn(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() => isLogin = label == "Login"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: active ? activeColor : textMuted)),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2.5,
            width: 36,
            decoration: BoxDecoration(
              color: active ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: type,
        style: const TextStyle(fontSize: 14, color: textDark),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          hintText: hint,
          hintStyle: const TextStyle(color: textMuted, fontSize: 14),
          prefixIcon: Icon(icon, color: textMuted, size: 19),
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: textMuted,
                      size: 19),
                  onPressed: onToggle)
              : null,
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Icon(icon, color: teal, size: 20),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            Text(subtitle,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.55), fontSize: 11.5)),
      ],
    );
  }

  Widget _dividerV() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.15),
    );
  }
}

// ── خلفية طبية ──
class _MedicalBackground extends StatelessWidget {
  const _MedicalBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MedicalPainter());
  }
}

class _MedicalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(
        Offset(size.width * 0.12, size.height * 0.15), 160, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.88, size.height * 0.85), 220, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.5), 300, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.2), 130, circlePaint);

    // ECG line
    final ecgPaint = Paint()
      ..color = const Color(0xFF0A7C86).withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final y = size.height * 0.9;
    final w = size.width;

    path.moveTo(0, y);
    path.lineTo(w * 0.12, y);
    path.lineTo(w * 0.15, y - 25);
    path.lineTo(w * 0.18, y + 45);
    path.lineTo(w * 0.22, y - 70);
    path.lineTo(w * 0.26, y + 18);
    path.lineTo(w * 0.29, y);
    path.lineTo(w * 0.45, y);
    path.lineTo(w * 0.48, y - 18);
    path.lineTo(w * 0.51, y + 28);
    path.lineTo(w * 0.54, y - 45);
    path.lineTo(w * 0.57, y + 12);
    path.lineTo(w * 0.60, y);
    path.lineTo(w, y);

    canvas.drawPath(path, ecgPaint);

    // نقاط زخرفية
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 10; j++) {
        canvas.drawCircle(
          Offset(
            size.width * 0.04 + i * size.width * 0.09,
            size.height * 0.05 + j * size.height * 0.09,
          ),
          1.8,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}