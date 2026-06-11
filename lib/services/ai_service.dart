//static const String apiKey = "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";
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AiService {
  static const String apiKey = "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";

  // 🔹 حفظ التقرير على الباكند Node/MongoDB
  static Future<bool> saveReport(Map<String, dynamic> data) async {
    try {
      print("Attempting to save report: $data");

      final response = await http.post(
        Uri.parse("http://localhost:5000/api/ai/save-ai-report"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("✅ Report saved successfully");
        return true;
      } else {
        print("❌ Failed to save report: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception during saveReport: $e");
      return false;
    }
  }

  // 🔹 توليد حالة جديدة من AI أو محليًا
  static Future<Map<String, dynamic>> generateCase() async {
    final base = _generateCase();

    try {
      print("Calling AI API for reasoning...");

      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "qwen/qwen2.5-7b-instruct",
          "messages": [
            {
              "role": "system",
              "content": "Provide short clinical reasoning for the diagnosis."
            },
            {"role": "user", "content": jsonEncode(base)}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final content = decoded['choices'][0]['message']['content'];
        final ai = jsonDecode(content);

        return _buildFinalCase(base, ai);
      } else {
        print("⚠️ AI API returned status ${response.statusCode}: ${response.body}");
        return _buildFinalCase(base, null);
      }
    } catch (e) {
      print("⚠️ Exception calling AI API: $e");
      return _buildFinalCase(base, null);
    }
  }

  // 🔹 توليد حالة بشكل عشوائي محليًا
  static Map<String, dynamic> _generateCase() {
    final r = Random();
    final diseases = [
      {
        "name": "Myocardial Infarction",
        "symptoms": "crushing chest pain radiating to the left arm, sweating, nausea",
        "labs": {"Troponin": "Elevated", "ECG": "ST elevation in II, III, aVF"}
      },
      {
        "name": "Pulmonary Embolism",
        "symptoms": "sudden shortness of breath, pleuritic chest pain, tachycardia",
        "labs": {"D-dimer": "Elevated", "Oxygen Saturation": "Low"}
      },
      {
        "name": "Pneumonia",
        "symptoms": "fever, productive cough, shortness of breath",
        "labs": {"WBC": "Elevated", "CRP": "High"}
      },
      {
        "name": "Stroke",
        "symptoms": "sudden weakness, slurred speech, facial droop",
        "labs": {"CT Brain": "Ischemic changes"}
      },
      {
        "name": "Sepsis",
        "symptoms": "fever, confusion, hypotension",
        "labs": {"Lactate": "High", "WBC": "Elevated"}
      }
    ];

    final caseData = diseases[r.nextInt(diseases.length)];
    return {
      "presentation":
          "A ${30 + r.nextInt(40)}-year-old ${r.nextBool() ? "male" : "female"} presents with ${caseData['symptoms']}.",
      "history":
          "Symptoms started acutely and progressively worsened. No significant relief with rest.",
      "vitals": {
        "bloodPressure": "${100 + r.nextInt(40)}/${60 + r.nextInt(30)} mmHg",
        "heartRate": "${90 + r.nextInt(40)} bpm",
        "respiratoryRate": "${18 + r.nextInt(8)} breaths/min",
        "oxygenSaturation": "${88 + r.nextInt(10)}%"
      },
      "labs": caseData['labs'],
      "exam": ["Patient appears distressed", "Abnormal findings consistent with illness"],
      "diagnosis": caseData['name']
    };
  }

  // 🔹 تجهيز الحالة النهائية مع الخيارات الصحيحة والخاطئة
  static Map<String, dynamic> _buildFinalCase(base, ai) {
    final correct = base['diagnosis'];

    final wrongMap = {
      "Myocardial Infarction": ["GERD", "Anxiety Disorder", "Musculoskeletal Pain"],
      "Pulmonary Embolism": ["Pneumonia", "Asthma", "Panic Attack"],
      "Pneumonia": ["Tuberculosis", "Asthma", "Bronchitis"],
      "Stroke": ["Migraine", "Seizure", "Hypoglycemia"],
      "Sepsis": ["Flu", "Dehydration", "Anxiety"]
    };

    final wrong = wrongMap[correct]!..shuffle();
    final options = [correct, wrong[0], wrong[1], wrong[2]]..shuffle();

    return {
      ...base,
      "question": "What is the most likely diagnosis?",
      "options": options,
      "correctIndex": options.indexOf(correct),
      "explanation":
          ai?['explanation'] ?? "The symptoms, vital signs, and investigations strongly indicate $correct."
    };
  }
}