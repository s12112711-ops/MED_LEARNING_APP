import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'simulation_case_bank_screen.dart'; // 👈 مهم

class AiCaseScreen extends StatefulWidget {
  final Map<String, dynamic> caseData;
  final List<Map<String, dynamic>>? previousHistory;

  const AiCaseScreen({
    super.key,
    required this.caseData,
    this.previousHistory,
  });

  @override
  State<AiCaseScreen> createState() => _AiCaseScreenState();
}

class _AiCaseScreenState extends State<AiCaseScreen> {
  List<Map<String, String>> messages = [];
  bool showVitals = false;
  bool showLabs = false;
  bool showExam = false;

  int score = 0;
  int totalCases = 0;
  int attempts = 0;
  bool answered = false;

  List<Map<String, dynamic>> caseHistory = [];
  List<int> selectedPath = [];

  bool isSaved = false; // 🔥 منع التكرار

  @override
  void initState() {
    super.initState();

    if (widget.previousHistory != null) {
      caseHistory = List.from(widget.previousHistory!);
      score = caseHistory.fold(0, (sum, c) => sum + (c['score'] as int));
      totalCases = caseHistory.length;
    }

    messages.add({
      "role": "patient",
      "text": widget.caseData['presentation']
    });
  }

  Future<String> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? "";
  }

  Future<void> saveReport() async {
    if (isSaved) return; // 🔥 أهم سطر

    try {
      final userId = await _getUserId();
      if (userId.isEmpty) return;

      isSaved = true;

      print("Saving report: score=$score, totalCases=$totalCases");

      await AiService.saveReport({
        "userId": userId,
        "score": score,
        "totalCases": totalCases,
        "history": caseHistory,
      });

      print("Report saved successfully");
    } catch (e) {
      print("Error saving report: $e");
    }
  }

  String getPerformance() {
    if (score >= 30) return "Excellent";
    if (score >= 20) return "Good";
    if (score >= 10) return "Average";
    return "Needs Improvement";
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.caseData;

    return WillPopScope(
      onWillPop: () async {
        return true; // ❌ منع الحفظ عند الرجوع
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1F33),
        body: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...messages.map((m) => _bubble(m)),
                    if (showVitals) _section("Vitals", _vitals(d)),
                    if (showLabs) _section("Investigations", _labs(d)),
                    if (showExam) _section("Examination", _exam(d)),
                  ],
                ),
              ),
              _actions(d),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F3D63), Color(0xFF1E5F96)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor_heart, color: Colors.white),
              SizedBox(width: 10),
              Text("Clinical Simulation",
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _bubble(Map<String, String> msg) {
    final isPatient = msg['role'] == "patient";

    return Align(
      alignment: isPatient ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isPatient
              ? const LinearGradient(
                  colors: [Color(0xFF1E5F96), Color(0xFF0F3D63)])
              : null,
          color: isPatient ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg['text']!,
          style: TextStyle(
            color: isPatient ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _vitals(Map d) {
    final v = d['vitals'];
    return Column(
      children: [
        _row("Blood Pressure", v['bloodPressure']),
        _row("Heart Rate", v['heartRate']),
        _row("Respiratory Rate", v['respiratoryRate']),
        _row("Oxygen Saturation", v['oxygenSaturation']),
      ],
    );
  }

  Widget _labs(Map d) {
    final l = d['labs'];
    return Column(
      children: l.entries.map<Widget>((e) => _row(e.key, e.value)).toList(),
    );
  }

  Widget _exam(Map d) {
    return Column(
      children: d['exam']
          .map<Widget>((e) => Text(
                "• $e",
                style: const TextStyle(color: Colors.white),
              ))
          .toList(),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actions(Map d) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _btn("History", () {
            setState(() {
              messages.add({
                "role": "doctor",
                "text": "Tell me more about your symptoms."
              });
              messages.add({"role": "patient", "text": d['history']});
            });
          }),
          _btn("Vitals", () => setState(() => showVitals = true)),
          _btn("Labs", () => setState(() => showLabs = true)),
          _btn("Exam", () => setState(() => showExam = true)),
          _btn("Diagnose", () => _chooseDiagnosis(d)),
          _btn("Report", () => _showReport()),

          _btn("New Case", () async {
            final newCase = await AiService.generateCase();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AiCaseScreen(
                  caseData: newCase,
                  previousHistory: caseHistory,
                ),
              ),
            );
          }),

          // 🔥 الحل النهائي
          _btn("Logout", () async {
            await saveReport();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => SimulationCaseBankScreen(),
              ),
              (route) => false,
            );
          }),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E5F96)),
      child: Text(text),
    );
  }

  // ❗ باقي الكود (diagnosis + report) زي ما هو بدون تغيير


  void _chooseDiagnosis(Map d) {
    attempts = 0;
    answered = false;
    selectedPath.clear();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F3D63), Color(0xFF1E5F96)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select Diagnosis",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  ...List.generate(d['options'].length, (i) {
                    bool isSelected = selectedPath.contains(i);
                    bool isCorrect = i == d['correctIndex'];
                    Color borderColor = Colors.white24;
                    IconData icon = Icons.circle_outlined;

                    if (isSelected) {
                      if (isCorrect) {
                        borderColor = Colors.green;
                        icon = Icons.check_circle;
                      } else {
                        borderColor = Colors.red;
                        icon = Icons.cancel;
                      }
                    }

                    return GestureDetector(
                      onTap: answered
                          ? null
                          : () {
                              setModalState(() {
                                attempts++;
                                selectedPath.add(i);
                              });

                              if (isCorrect) {
                                answered = true;

                                int gained = 0;
                                if (attempts == 1) gained = 15;
                                else if (attempts == 2) gained = 10;
                                else if (attempts == 3) gained = 5;

                                setState(() {
                                  score += gained;
                                  totalCases++;
                                  caseHistory.add({
                                    "case": d['diagnosis'],
                                    "attempts": attempts,
                                    "path": List.from(selectedPath),
                                    "isCorrect": true,
                                    "score": gained,
                                  });
                                });
                              } else {
                                if (attempts >= 4) {
                                  answered = true;
                                  setState(() {
                                    totalCases++;
                                    caseHistory.add({
                                      "case": d['diagnosis'],
                                      "attempts": attempts,
                                      "path": List.from(selectedPath),
                                      "isCorrect": false,
                                      "score": 0,
                                    });
                                  });
                                }
                              }
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF112D4E), Color(0xFF0B1F33)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor.withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(icon, color: borderColor),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                d['options'][i],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (answered)
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Continue"),
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showReport() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F3D63), Color(0xFF1E5F96)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Text("Clinical Report",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 10),
              Text("Total Score: $score", style: const TextStyle(color: Colors.white)),
              Text("Cases: $totalCases", style: const TextStyle(color: Colors.white)),
              Text("Performance: ${getPerformance()}", style: const TextStyle(color: Colors.white)),
              const Divider(color: Colors.white30),
              Expanded(
                child: ListView.builder(
                  itemCount: caseHistory.length,
                  itemBuilder: (_, i) {
                    final c = caseHistory[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: c['isCorrect'] ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['case'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text("Attempts: ${c['attempts']}", style: const TextStyle(color: Colors.white70)),
                          Text("Score: ${c['score']}", style: const TextStyle(color: Colors.white70)),
                          Text(c['isCorrect'] ? "Correct ✅" : "Wrong ❌", style: TextStyle(color: c['isCorrect'] ? Colors.green : Colors.red)),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}