import 'package:flutter/material.dart';

class SmartFeaturesScreen extends StatelessWidget {
  final String studentName;
  final double averageScore;
  final String strongestTopic;
  final String weakestTopic;
  final int quizzesCompleted;
  final int lastScore;

  const SmartFeaturesScreen({
    super.key,
    required this.studentName,
    required this.averageScore,
    required this.strongestTopic,
    required this.weakestTopic,
    required this.quizzesCompleted,
    required this.lastScore,
  });

  String getPerformanceLevel() {
    if (averageScore >= 90) return "Excellent";
    if (averageScore >= 80) return "Very Good";
    if (averageScore >= 70) return "Good";
    if (averageScore >= 60) return "Fair";
    return "Needs Improvement";
  }

  String getRecommendation() {
    if (averageScore < 60) {
      return "Focus on reviewing basic concepts and repeat easier quizzes first.";
    } else if (averageScore < 75) {
      return "You are doing well, but you need more practice in weak topics.";
    } else if (averageScore < 90) {
      return "Very good progress. Continue solving quizzes and revise difficult lessons.";
    } else {
      return "Excellent work! You are ready for more advanced content.";
    }
  }

  String getNextAction() {
    if (weakestTopic == "-" || weakestTopic.isEmpty) {
      return "Start solving quizzes to generate smart recommendations.";
    }
    return "Review $weakestTopic and then take another quiz on the same topic.";
  }

  String getProgressNote() {
    if (quizzesCompleted == 0) {
      return "No quiz data available yet.";
    }

    if (lastScore > averageScore) {
      return "Your last quiz score is better than your average. Great improvement!";
    }

    if (lastScore < averageScore) {
      return "Your last quiz score is below your average. A short revision is recommended.";
    }

    return "Your recent performance is stable.";
  }

  Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withAlpha(31),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0E4A6B);
    const bg = Color(0xFFF4F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Smart Features"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Smart Student Analysis",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Student: $studentName",
                  style: TextStyle(
                    color: Colors.white.withAlpha(242),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Quizzes Completed: $quizzesCompleted",
                  style: TextStyle(
                    color: Colors.white.withAlpha(230),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          buildFeatureCard(
            icon: Icons.stars,
            title: "Performance Level",
            value: getPerformanceLevel(),
            color: Colors.amber,
          ),
          buildFeatureCard(
            icon: Icons.lightbulb,
            title: "Study Recommendation",
            value: getRecommendation(),
            color: Colors.blue,
          ),
          buildFeatureCard(
            icon: Icons.trending_up,
            title: "Strongest Topic",
            value: strongestTopic,
            color: Colors.green,
          ),
          buildFeatureCard(
            icon: Icons.warning_amber_rounded,
            title: "Needs More Focus",
            value: weakestTopic,
            color: Colors.red,
          ),
          buildFeatureCard(
            icon: Icons.menu_book,
            title: "Suggested Next Step",
            value: getNextAction(),
            color: Colors.purple,
          ),
          buildFeatureCard(
            icon: Icons.insights,
            title: "Progress Note",
            value: getProgressNote(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}