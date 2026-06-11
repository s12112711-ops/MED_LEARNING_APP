import 'dart:convert';
import 'package:http/http.dart' as http;

class ClinicalResultService {
  static const String baseUrl =
      'http://localhost:5000/api/clinical-results';

  static Future<Map<String, dynamic>> saveResult({
    required String studentName,
    required String caseTitle,
    required String diagnosisSelected,
    required String firstActionSelected,
    required List<String> selectedInvestigations,
    required int score,
    required String performanceLabel,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentName': studentName,
        'caseTitle': caseTitle,
        'diagnosisSelected': diagnosisSelected,
        'firstActionSelected': firstActionSelected,
        'selectedInvestigations': selectedInvestigations,
        'score': score,
        'performanceLabel': performanceLabel,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getStudentResults(String studentName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/student/$studentName'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);
    return data['data'] ?? [];
  }
}