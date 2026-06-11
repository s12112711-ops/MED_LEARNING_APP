import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'auth_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'admin_login_screen.dart';
import 'doctor/doctor_dashboard_screen.dart';
import 'services/push_notification_service.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  String selectedRole = "student";


String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:5000";
    } else {
      return "http://10.0.2.2:5000";
    }
  }


  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    final url = Uri.parse("$baseUrl/api/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passController.text.trim(),
          "role": selectedRole,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final role = (data["role"] ??
                (data["user"] != null ? data["user"]["role"] : null) ??
                "")
            .toString()
            .toLowerCase();

        final String userId = (data["_id"] ??
                data["id"] ??
                data["userId"] ??
                (data["user"] is Map ? data["user"]["_id"] : null) ??
                (data["user"] is Map ? data["user"]["id"] : null) ??
                "")
            .toString();

        final String userName = (data["name"] ??
                data["fullName"] ??
                data["username"] ??
                (data["user"] is Map ? data["user"]["name"] : null) ??
                (data["user"] is Map ? data["user"]["fullName"] : null) ??
                emailController.text.trim().split("@").first)
            .toString();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('userName', userName);
        await prefs.setString('role', role);

        // هذا السطر الجديد المهم
        // نفعله فقط للطالب
        if (role == "student" && userId.isNotEmpty) {
          await PushNotificationService.initialize(
            currentUserId: userId,
          );
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful"),
            backgroundColor: Colors.green,
          ),
        );

        if (role == "doctor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorDashboardScreen(
                currentUserId: userId,
                currentUserName: userName,
              ),
            ),
          );
        } else if (role == "student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                currentUserId: userId,
                currentUserName: userName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Unknown user role"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Login failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _roleCard({
    required String role,
    required String title,
    required Color color,
    required IconData icon,
  }) {
    final bool isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color, width: 1.5),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withAlpha(46),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFFFF3E6);
    const orange = Color(0xFFFF7A00);
    const blue = Color(0xFF0E4A6B);

    final activeColor = selectedRole == "doctor" ? blue : orange;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "MediLearn 📚",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: orange,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "👋 Welcome!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: orange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    selectedRole == "doctor"
                        ? "Doctors login here to manage content and analytics ✨"
                        : "Students login here to continue learning ✨",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      _roleCard(
                        role: "student",
                        title: "Student",
                        color: orange,
                        icon: Icons.school_outlined,
                      ),
                      const SizedBox(width: 12),
                      _roleCard(
                        role: "doctor",
                        title: "Doctor",
                        color: blue,
                        icon: Icons.medical_services_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  _InputBox(
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: selectedRole == "doctor"
                            ? "Doctor Email"
                            : "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (v) {
                        final s = (v ?? "").trim();
                        if (s.isEmpty) return "Email is required";
                        if (!s.contains("@")) return "Enter valid email";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InputBox(
                    child: TextFormField(
                      controller: passController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (v) {
                        final s = (v ?? "");
                        if (s.isEmpty) return "Password is required";
                        if (s.length < 6) return "Minimum 6 characters";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        if (!isLoading) {
                          _login();
                        }
                      },
                      onFieldSubmitted: (_) {
                        if (!isLoading) {
                          _login();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              selectedRole == "doctor"
                                  ? "Doctor Login"
                                  : "Let’s go 🚀",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: activeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Admin Login",
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AuthScreen(),
                        ),
                      );
                    },
                    child: Text(
                      selectedRole == "doctor"
                          ? "Create Doctor Account"
                          : "Create New Account",
                      style: TextStyle(
                        color: activeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final Widget child;
  const _InputBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}