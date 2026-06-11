
import 'package:flutter/material.dart';
import 'dart:async';

class MysteryCaseScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const MysteryCaseScreen({super.key, required this.userId, required this.userName});

  @override
  State<MysteryCaseScreen> createState() => _MysteryCaseScreenState();
}

class _MysteryCaseScreenState extends State<MysteryCaseScreen> {
  int currentStep = 0;
  bool showResolution = false;
  String? selectedOption;
  bool isCorrect = false;

  // Mock Case Data - In a real app, this would come from an AI API or backend
  final Map<String, dynamic> caseData = {
    "title": "The Breathless Runner",
    "patient": "Male, 24 years old",
    "presentation": "Sudden onset of sharp right-sided chest pain and shortness of breath while jogging. No history of trauma.",
    "vitals": "HR: 110 bpm, O2 Sat: 91% on room air, RR: 24 bpm.",
    "questions": [
      {
        "text": "Based on the presentation, what is your immediate clinical suspicion?",
        "options": [
          "Myocardial Infarction",
          "Spontaneous Pneumothorax",
          "Pulmonary Embolism",
          "Acute Asthma Attack"
        ],
        "correct": "Spontaneous Pneumothorax",
        "explanation": "Sudden sharp chest pain in a young, healthy male during exertion is a classic presentation for primary spontaneous pneumothorax."
      }
    ],
    "resolution": {
      "finding": "Diminished breath sounds on the right side. Tracheal deviation is not present.",
      "action": "Chest X-ray confirms a 30% collapse of the right lung. A chest tube was inserted.",
      "points": 50
    }
  };

  void handleAnswer(String option) {
    setState(() {
      selectedOption = option;
      isCorrect = option == caseData['questions'][0]['correct'];
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          showResolution = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0F4C75);
    const accent = Color(0xFF3282B8);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7),
      appBar: AppBar(
        title: const Text("AI Case Challenge 💡", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Case Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [primary, accent]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caseData['title'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_search, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(caseData['patient'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Presentation Section
            _buildInfoCard("Clinical Presentation", caseData['presentation'], Icons.medical_services_outlined, Colors.blue),
            const SizedBox(height: 12),
            _buildInfoCard("Vital Signs", caseData['vitals'], Icons.monitor_heart_outlined, Colors.red),

            const SizedBox(height: 30),

            if (!showResolution) ...[
              const Text("Your Diagnosis:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
              const SizedBox(height: 16),
              ...((caseData['questions'][0]['options'] as List).map((opt) {
                bool isPending = selectedOption == opt;
                return GestureDetector(
                  onTap: selectedOption == null ? () => handleAnswer(opt) : null,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: selectedOption == null 
                        ? Colors.white 
                        : (isPending ? (isCorrect ? Colors.green.withAlpha(26) : Colors.red.withAlpha(26)) : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selectedOption == null
                          ? Colors.transparent
                          : (isPending ? (isCorrect ? Colors.green : Colors.red) : Colors.transparent),
                        width: 2
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Expanded(child: Text(opt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                        if (isPending) 
                          Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: isCorrect ? Colors.green : Colors.red),
                      ],
                    ),
                  ),
                );
              })),
            ] else ...[
              // Resolution Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.green.shade100, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(isCorrect ? Icons.emoji_events : Icons.info_outline, size: 60, color: isCorrect ? Colors.amber : Colors.blue),
                    const SizedBox(height: 16),
                    Text(isCorrect ? "Brilliant Diagnosis!" : "Learning Opportunity", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isCorrect ? Colors.green : Colors.blue)),
                    const SizedBox(height: 12),
                    Text(caseData['questions'][0]['explanation'], textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5)),
                    const Divider(height: 32),
                    Text("Clinical Outcome", style: TextStyle(fontWeight: FontWeight.bold, color: primary)),
                    const SizedBox(height: 8),
                    Text(caseData['resolution']['action'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 24),
                    Text("+${caseData['resolution']['points']} XP", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        ),
                        child: const Text("Finish Challenge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
