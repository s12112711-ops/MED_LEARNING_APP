import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExamModeScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ExamModeScreen({super.key, required this.userId, required this.userName});

  @override
  State<ExamModeScreen> createState() => _ExamModeScreenState();
}

class _ExamModeScreenState extends State<ExamModeScreen> {
  final String baseUrl = 'http://127.0.0.1:5000/api';
  String selectedSubject = "Anatomy";
  List<dynamic> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final annResponse = await http.get(Uri.parse('$baseUrl/announcements'));
      if (annResponse.statusCode == 200) {
        setState(() {
          announcements = jsonDecode(annResponse.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Exam Mode fetch error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F172A), elevation: 0),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Exam Mode 🌙", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ),
        body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Select Subject to Focus", style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 12),
                  _buildSubjectSelector(),
                  
                  const SizedBox(height: 30),
                  
                  _buildFeatureCard(
                    title: "Hardest Questions",
                    description: "Battle the questions with the highest failure rate among all students.",
                    icon: Icons.psychology,
                    color: Colors.redAccent,
                  ),

                  _buildFeatureCard(
                    title: "Your Weak Points",
                    description: "Focus on $selectedSubject topics where your scores are below 50%.",
                    icon: Icons.trending_down,
                    color: Colors.orangeAccent,
                  ),

                  _buildFeatureCard(
                    title: "Quick Summary",
                    description: announcements.isNotEmpty 
                      ? "Latest: ${announcements[0]['title']}" 
                      : "Review pinned materials and latest updates.",
                    icon: Icons.auto_stories,
                    color: Colors.blueAccent,
                  ),

                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logic to launch a filtered quiz
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text("Start Focused Quiz", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text("Points earned in Exam Mode are doubled! ⚡", 
                      style: TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildSubjectSelector() {
    final subjects = ["Anatomy", "Pharmacology", "Physiology", "Surgery"];
    return Wrap(
      spacing: 10,
      children: subjects.map((sub) {
        final isSelected = selectedSubject == sub;
        return ChoiceChip(
          label: Text(sub),
          selected: isSelected,
          onSelected: (val) => setState(() => selectedSubject = sub),
          selectedColor: Colors.blueAccent.withAlpha(51),
          labelStyle: TextStyle(color: isSelected ? Colors.blueAccent : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
          backgroundColor: Colors.white.withAlpha(13),
          side: BorderSide(color: isSelected ? Colors.blueAccent : Colors.transparent),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard({required String title, required String description, required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade400, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
