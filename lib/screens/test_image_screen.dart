import 'package:flutter/material.dart';

class TestImageScreen extends StatelessWidget {
  const TestImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Test"),
      ),

      body: Center(
        child: Image.asset(
          "assets/systems/cardiovascular.jpg",

          height: 200,

          errorBuilder: (context, error, stackTrace) {
            return Text(
              "❌ Image not found",
              style: TextStyle(color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}