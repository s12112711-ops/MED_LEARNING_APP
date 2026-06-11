class FakeAIService {
  static Future<String> simplifyTopic({
    required String topic,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    switch (topic) {
      case "Heart Overview":
        return "The heart is a muscular organ that pumps blood through the body. The right side sends blood to the lungs, and the left side sends blood to the rest of the body.";
      case "Heart Chambers":
        return "The heart has four chambers. The atria receive blood, and the ventricles pump blood out. The right side handles blood going to the lungs, while the left side handles blood going to the body.";
      case "Heart Valves":
        return "Heart valves act like one-way doors. They open to let blood move forward and close to stop blood from flowing backward.";
      case "Major Vessels":
        return "Major vessels are the large blood vessels connected to the heart. They carry blood either into the heart or away from it.";
      case "Blood Circulation":
        return "Blood flows from the body to the heart, then to the lungs, then back to the heart, and finally out to the body again.";
      default:
        return "This topic has been simplified into an easier medical explanation for student learning.";
    }
  }

  static Future<String> generateSummary({
    required String topic,
    required String content,
    required List<String> bullets,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final keyPoints = bullets.map((e) => "• $e").join("\n");

    return "Topic: $topic\n\n"
        "Quick Summary:\n"
        "$keyPoints\n\n"
        "Core idea:\n$content";
  }

  static Future<String> generateQuestions({
    required String topic,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    switch (topic) {
      case "Heart Overview":
        return "• What is the main function of the heart?\n"
            "• Why is the heart described as a dual pump?\n"
            "• Where is the heart located anatomically?";
      case "Heart Chambers":
        return "• Which chamber receives oxygenated blood from the lungs?\n"
            "• Which ventricle pumps blood into systemic circulation?\n"
            "• What is the difference between atria and ventricles?";
      case "Heart Valves":
        return "• Which valve lies between the left atrium and left ventricle?\n"
            "• Why are valves important for circulation?\n"
            "• What happens if a valve does not close properly?";
      case "Major Vessels":
        return "• What is the role of the aorta?\n"
            "• Which vessels return blood to the heart?\n"
            "• Which vessel carries blood from the right ventricle to the lungs?";
      case "Blood Circulation":
        return "• What is the sequence of pulmonary circulation?\n"
            "• How does oxygenated blood return to the heart?\n"
            "• Which side of the heart pumps blood to the body?";
      default:
        return "• What is the main role of this structure?\n"
            "• Why is it clinically important?\n"
            "• What should be studied next?";
    }
  }

  static Future<String> generateClinicalInsight({
    required String topic,
    required String clinicalNote,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return "Clinical Insight for $topic:\n\n$clinicalNote\n\n"
        "This means the topic is not only anatomical, but also important in diagnosis, imaging, and real patient care.";
  }
}