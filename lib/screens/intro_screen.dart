import 'package:flutter/material.dart';
import 'StudentLoginScreen.dart';
import 'admin_login_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  void _openRolePicker(BuildContext context) {

    const bg = Color(0xFFFFF3E6);
    const orange = Color(0xFFFF7A00);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: bg,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Choose Access",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFFF7A00),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Continue to MediLearn as a user or as an admin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Access MediLearn Button (Student + Doctor)
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: orange,
                        side: const BorderSide(color: orange, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentLoginScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Access MediLearn",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Admin Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),

                      onPressed: () {
                        Navigator.pop(ctx);
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
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    const bg = Color(0xFFFFF3E6);
    const orange = Color(0xFFFF7A00);

    return Scaffold(
      backgroundColor: bg,

      body: Center(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Container(
            width: 420,

            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 36,
            ),

            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(
                  Icons.menu_book_rounded,
                  size: 72,
                  color: orange,
                ),

                const SizedBox(height: 18),

                const Text(
                  "MediLearn 📚",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: orange,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Welcome to MediLearn!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: orange,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Digital medical learning system\nfor structured clinical education and smart evaluation.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF6B6B6B),
                  ),
                ),

                const SizedBox(height: 28),

                /// Access MediLearn Button
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),

                    onPressed: () => _openRolePicker(context),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Access MediLearn",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
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
}