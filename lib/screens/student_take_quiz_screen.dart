import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentTakeQuizScreen extends StatefulWidget {
  final Map quiz;

  const StudentTakeQuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<StudentTakeQuizScreen> createState() => _StudentTakeQuizScreenState();
}

class _StudentTakeQuizScreenState extends State<StudentTakeQuizScreen> {
  final TextEditingController studentNameController =
      TextEditingController(text: "Student 1");

  int lives = 3;
  int currentQuestionIndex = 0;
  bool isGameOver = false;
  List<Map<String, dynamic>> wrongAnswersList = [];
  Map<int, String> selectedAnswers = {};
  bool submitted = false;
  bool isSaving = false;
  bool isCheckingSubmission = true;
  bool alreadySubmitted = false;
  int score = 0;

  final String baseUrl = "http://127.0.0.1:5000/api/quizResults";

  // مؤقتًا إلى أن تربطي login حقيقي
  final String studentId = "student_1";

  @override
  void initState() {
    super.initState();
    checkIfAlreadySubmitted();
  }

  Future<void> checkIfAlreadySubmitted() async {
    try {
      final quizId = widget.quiz["_id"]?.toString() ?? "";

      if (quizId.isEmpty) {
        setState(() {
          isCheckingSubmission = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/check/$quizId/$studentId"),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          alreadySubmitted = data["alreadySubmitted"] == true;
          isCheckingSubmission = false;
          submitted = alreadySubmitted;
        });

        if (alreadySubmitted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("Quiz already submitted"),
                content: const Text(
                  "You have already submitted this quiz and cannot retake it.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          });
        }
      } else {
        setState(() {
          isCheckingSubmission = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isCheckingSubmission = false;
      });
    }
  }

    // Logic moved to answer selection to make it interactive per question
  
  void handleAnswerSelection(int questionIndex, String selected) async {
    if (submitted || isGameOver || alreadySubmitted) return;

    final questions = widget.quiz["questions"] as List? ?? [];
    final question = questions[questionIndex] as Map;
    final correctAnswer = (question["correctAnswer"] ?? "").toString();

    setState(() {
      selectedAnswers[questionIndex] = selected;
    });

    if (selected == correctAnswer) {
      // Correct Answer logic
      setState(() {
        score++;
      });
      _showPointsPopup();
    } else {
      // Wrong Answer logic
      setState(() {
        lives--;
        wrongAnswersList.add({
          "questionText": question["questionText"],
          "correctAnswer": correctAnswer,
          "selectedAnswer": selected,
          "explanation": question["explanation"],
        });
        if (lives <= 0) {
          isGameOver = true;
        }
      });
      _triggerShake();
    }

    // Auto-advance or finish
    if (questionIndex < questions.length - 1 && !isGameOver) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            currentQuestionIndex++;
          });
        }
      });
    } else if (questionIndex == questions.length - 1 || isGameOver) {
      // Finish Quiz
      submitResult();
    }
  }

  void _showPointsPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Correct! +10 Points 🌟", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  void _triggerShake() {
    // Simple shake feedback via snackbar for now, or we can use an animation controller
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Wrong Answer! -1 Life ❤️", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> submitResult() async {
    setState(() => isSaving = true);
    try {
      final questions = widget.quiz["questions"] as List? ?? [];
      await http.post(
        Uri.parse("$baseUrl/submit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "quizId": widget.quiz["_id"],
          "studentId": widget.quiz["studentId"] ?? "temp_student_id",
          "studentName": studentNameController.text.trim(),
          "score": score,
          "totalQuestions": questions.length,
          "subject": widget.quiz["subject"] ?? "General",
          "pointsEarned": score * 10,
          "wrongAnswers": wrongAnswersList,
        }),
      );
      setState(() {
        isSaving = false;
        submitted = true;
      });
    } catch (e) {
      debugPrint("Submit error: $e");
      setState(() => isSaving = false);
    }
  }

  Widget buildOptionTile({
    required int questionIndex,
    required String optionText,
  }) {
    return RadioListTile<String>(
      value: optionText,
      groupValue: selectedAnswers[questionIndex],
      onChanged: submitted || alreadySubmitted
          ? null
          : (value) {
              setState(() {
                selectedAnswers[questionIndex] = value!;
              });
            },
      title: Text(optionText),
      activeColor: const Color(0xFF0E4A6B),
    );
  }

  @override
  void dispose() {
    studentNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    final title = widget.quiz["title"] ?? "Quiz";
    final questions = widget.quiz["questions"] as List? ?? [];

    if (isCheckingSubmission) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: Text("No questions found")));
    }

    // Game Over Overlay
    if (isGameOver) {
      return _buildResultOverlay(
        title: "Game Over 💔",
        msg: "You've lost all your lives. Better luck next time!",
        color: Colors.red,
        icon: Icons.heart_broken,
      );
    }

    // Success / Finished Overlay
    if (submitted) {
      return _buildResultOverlay(
        title: "Quiz Finished! 🎓",
        msg: "You scored $score out of ${questions.length}\nPoints Earned: +${score * 10} pts",
        color: Colors.green,
        icon: Icons.emoji_events,
        isSuccess: true,
      );
    }

    final currentQuestion = questions[currentQuestionIndex] as Map;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(3, (index) {
                return Icon(
                  index < lives ? Icons.favorite : Icons.favorite_border,
                  color: index < lives ? Colors.red : Colors.white38,
                );
              }),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Linear Progress Bar
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            minHeight: 6,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   // Question Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: blue.withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Question ${currentQuestionIndex + 1} of ${questions.length}",
                      style: const TextStyle(color: blue, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion["questionText"] ?? "",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        ...((currentQuestion["options"] as List? ?? []).map((opt) {
                          bool isSelected = selectedAnswers[currentQuestionIndex] == opt;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isSelected ? blue : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected ? blue.withAlpha(13) : Colors.transparent,
                            ),
                            child: RadioListTile<String>(
                              value: opt,
                              groupValue: selectedAnswers[currentQuestionIndex],
                              onChanged: (val) => handleAnswerSelection(currentQuestionIndex, val!),
                              title: Text(opt, style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? blue : Colors.black87,
                              )),
                              activeColor: blue,
                            ),
                          );
                        })),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultOverlay({required String title, required String msg, required Color color, required IconData icon, bool isSuccess = false}) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E4A6B),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: color),
              const SizedBox(height: 20),
              Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 12),
              Text(msg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text("Go Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              if (isSuccess && wrongAnswersList.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizMistakesReviewScreen(wrongAnswers: wrongAnswersList),
                      ),
                    );
                  },
                  child: const Text("Review Mistakes", style: TextStyle(decoration: TextDecoration.underline)),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class QuizMistakesReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> wrongAnswers;

  const QuizMistakesReviewScreen({
    super.key,
    required this.wrongAnswers,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Review Mistakes"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: wrongAnswers.isEmpty
          ? const Center(
              child: Text("No mistakes found"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wrongAnswers.length,
              itemBuilder: (context, index) {
                final item = wrongAnswers[index];
                final questionText = (item["questionText"] ?? "").toString();
                final selectedAnswer = (item["selectedAnswer"] ?? "").toString();
                final correctAnswer = (item["correctAnswer"] ?? "").toString();
                final explanation = (item["explanation"] ?? "").toString();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wrong Question ${index + 1}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        questionText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withAlpha(64),
                          ),
                        ),
                        child: Text(
                          "Your Answer: ${selectedAnswer.isEmpty ? "No answer selected" : selectedAnswer}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withAlpha(89),
                          ),
                        ),
                        child: Text(
                          "Correct Answer: $correctAnswer",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      if (explanation.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: blue.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: blue.withAlpha(51),
                            ),
                          ),
                          child: Text(
                            "Explanation: $explanation",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: blue,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}