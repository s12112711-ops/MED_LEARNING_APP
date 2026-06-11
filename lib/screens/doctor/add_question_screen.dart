import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddQuestionScreen extends StatefulWidget {
  const AddQuestionScreen({super.key});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController createdByNameController =
      TextEditingController(text: "Dr Ahmad");
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();

  String selectedCorrectAnswer = "A";
  String selectedDifficulty = "easy";
  bool isLoading = false;

  Future<void> _submitQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    final options = [
      optionAController.text.trim(),
      optionBController.text.trim(),
      optionCController.text.trim(),
      optionDController.text.trim(),
    ];

    String correctAnswerText = optionAController.text.trim();

    if (selectedCorrectAnswer == "B") {
      correctAnswerText = optionBController.text.trim();
    } else if (selectedCorrectAnswer == "C") {
      correctAnswerText = optionCController.text.trim();
    } else if (selectedCorrectAnswer == "D") {
      correctAnswerText = optionDController.text.trim();
    }

    final url = Uri.parse("http://127.0.0.1:5000/api/questions");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "subject": subjectController.text.trim(),
          "topic": topicController.text.trim(),
          "questionText": questionController.text.trim(),
          "options": options,
          "correctAnswer": correctAnswerText,
          "difficulty": selectedDifficulty,
          "explanation": explanationController.text.trim(),
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Question added successfully"),
            backgroundColor: Colors.green,
          ),
        );

        subjectController.clear();
        topicController.clear();
        questionController.clear();
        optionAController.clear();
        optionBController.clear();
        optionCController.clear();
        optionDController.clear();
        explanationController.clear();

        setState(() {
          selectedCorrectAnswer = "A";
          selectedDifficulty = "easy";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to add question"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    createdByNameController.dispose();
    subjectController.dispose();
    topicController.dispose();
    questionController.dispose();
    optionAController.dispose();
    optionBController.dispose();
    optionCController.dispose();
    optionDController.dispose();
    explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Add Question"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add a new question to the bank",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: createdByNameController,
                      decoration: const InputDecoration(
                        labelText: "Doctor Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Doctor name is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: topicController,
                      decoration: const InputDecoration(
                        labelText: "Topic",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Topic is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: questionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Question",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Question is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: optionAController,
                      decoration: const InputDecoration(
                        labelText: "Option A",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Option A is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: optionBController,
                      decoration: const InputDecoration(
                        labelText: "Option B",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Option B is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: optionCController,
                      decoration: const InputDecoration(
                        labelText: "Option C",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Option C is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: optionDController,
                      decoration: const InputDecoration(
                        labelText: "Option D",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Option D is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedCorrectAnswer,
                      decoration: const InputDecoration(
                        labelText: "Correct Answer",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: "A", child: Text("A")),
                        DropdownMenuItem(value: "B", child: Text("B")),
                        DropdownMenuItem(value: "C", child: Text("C")),
                        DropdownMenuItem(value: "D", child: Text("D")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCorrectAnswer = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: "Difficulty",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: "easy", child: Text("Easy")),
                        DropdownMenuItem(value: "medium", child: Text("Medium")),
                        DropdownMenuItem(value: "hard", child: Text("Hard")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedDifficulty = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: explanationController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Explanation (optional)",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Add Question",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}