import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_report_screen.dart';

class StudentReportsListScreen extends StatefulWidget {
  final String doctorId;

  const StudentReportsListScreen({super.key, required this.doctorId});

  @override
  State<StudentReportsListScreen> createState() =>
      _StudentReportsListScreenState();
}

class _StudentReportsListScreenState extends State<StudentReportsListScreen> {
  static const navy = Color(0xFF0F3554);
  static const background = Color(0xFFF4F7FA);
  static const border = Color(0xFFE3EBF2);
  static const muted = Color(0xFF627D98);
  static const heading = Color(0xFF102A43);

  String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";

  bool isLoading = true;
  // قائمة الطلاب الفريدين من حالات الدكتور
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
            "$baseUrl/api/doctor-evaluations/doctor/${widget.doctorId}"),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        // استخرج الطلاب الفريدين
        final Map<String, Map<String, dynamic>> uniqueStudents = {};
        for (var c in data) {
          final id = c["studentId"].toString();
          if (!uniqueStudents.containsKey(id)) {
            uniqueStudents[id] = {
              "studentId": id,
              "studentName": c["studentName"] ?? "Unknown",
              // عدد الحالات المراجعة لهذا الطالب
              "reviewedCount": data
                  .where((x) =>
                      x["studentId"].toString() == id &&
                      x["status"] == "reviewed")
                  .length,
              "totalCount": data
                  .where((x) => x["studentId"].toString() == id)
                  .length,
            };
          }
        }

        setState(() {
          students = uniqueStudents.values.toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Student Reports"),
        backgroundColor: navy,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(
                  child: Text(
                    "No students found.",
                    style: TextStyle(color: muted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(18),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final s = students[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        children: [
                          // أيقونة الطالب
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: navy.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.person_rounded,
                                color: navy),
                          ),
                          const SizedBox(width: 14),

                          // اسم + عدد الحالات
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s["studentName"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: heading,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Cases: ${s["totalCount"]}  •  Reviewed: ${s["reviewedCount"]}",
                                  style: const TextStyle(
                                      fontSize: 12.5, color: muted),
                                ),
                              ],
                            ),
                          ),

                          // زر فتح التقرير
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentReportScreen(
                                  studentId: s["studentId"],
                                  studentName: s["studentName"],
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: navy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("View Report"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}