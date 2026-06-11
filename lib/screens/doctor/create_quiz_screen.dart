import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController easyCountController =
      TextEditingController(text: "0");
  final TextEditingController mediumCountController =
      TextEditingController(text: "0");
  final TextEditingController hardCountController =
      TextEditingController(text: "0");
  final TextEditingController durationController = TextEditingController();
  final TextEditingController createdByNameController =
      TextEditingController(text: "Dr Ahmad");

  bool isPublished = true;
  bool isLoading = false;

  int get totalQuestions {
    final easy = int.tryParse(easyCountController.text.trim()) ?? 0;
    final medium = int.tryParse(mediumCountController.text.trim()) ?? 0;
    final hard = int.tryParse(hardCountController.text.trim()) ?? 0;
    return easy + medium + hard;
  }

  Future<void> _createQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    final easy = int.tryParse(easyCountController.text.trim()) ?? 0;
    final medium = int.tryParse(mediumCountController.text.trim()) ?? 0;
    final hard = int.tryParse(hardCountController.text.trim()) ?? 0;

    if (easy + medium + hard <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add at least one question"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("http://127.0.0.1:5000/api/quizzes");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": titleController.text.trim(),
          "subject": subjectController.text.trim(),
          "topic": topicController.text.trim(),
          "description": descriptionController.text.trim(),
          "easyCount": easy,
          "mediumCount": medium,
          "hardCount": hard,
          "durationMinutes": int.parse(durationController.text.trim()),
          "createdByName": createdByNameController.text.trim(),
          "isPublished": isPublished,
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
            content: Text(data["message"] ?? "Quiz created successfully"),
            backgroundColor: Colors.green,
          ),
        );

        titleController.clear();
        subjectController.clear();
        topicController.clear();
        descriptionController.clear();
        easyCountController.text = "0";
        mediumCountController.text = "0";
        hardCountController.text = "0";
        durationController.clear();

        setState(() {
          isPublished = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to create quiz"),
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

  Widget buildCountField({
    required String label,
    required TextEditingController controller,
    required Color color,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: color, width: 1.8),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
          }
          final number = int.tryParse(value.trim());
          if (number == null) {
            return "Invalid";
          }
          if (number < 0) {
            return "Must be 0+";
          }
          return null;
        },
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    topicController.dispose();
    descriptionController.dispose();
    easyCountController.dispose();
    mediumCountController.dispose();
    hardCountController.dispose();
    durationController.dispose();
    createdByNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Create Quiz"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
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
                      "Create mixed-difficulty quiz",
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
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Quiz Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Quiz title is required"
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? "Subject is required"
                              : null,
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
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Question Distribution",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        buildCountField(
                          label: "Easy",
                          controller: easyCountController,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        buildCountField(
                          label: "Medium",
                          controller: mediumCountController,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        buildCountField(
                          label: "Hard",
                          controller: hardCountController,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Questions: $totalQuestions",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duration (minutes)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Duration is required";
                        }
                        final number = int.tryParse(value.trim());
                        if (number == null) {
                          return "Enter a valid number";
                        }
                        if (number <= 0) {
                          return "Duration must be greater than 0";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Publish now"),
                      subtitle: const Text(
                        "Published quizzes become available to students",
                      ),
                      value: isPublished,
                      activeColor: blue,
                      onChanged: (value) {
                        setState(() {
                          isPublished = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _createQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Create Quiz",
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