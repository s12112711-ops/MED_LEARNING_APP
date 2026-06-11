import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController doctorNameController =
      TextEditingController(text: "Dr Ahmad");
  final TextEditingController sourceNameController =
      TextEditingController(text: "Dr Ahmad");
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String selectedCategory = "general";
  String selectedAudience = "all";
  String selectedSourceType = "doctor";
  String selectedPriority = "normal";
  bool isPinned = false;
  bool isLoading = false;

 String get baseUrl =>
      kIsWeb ? "http://127.0.0.1:5000" : "http://10.0.2.2:5000";


  Future<void> _pickEventDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      eventDateController.text =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _pickEventTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final hour = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
      final minute = pickedTime.minute.toString().padLeft(2, '0');
      final period = pickedTime.period == DayPeriod.am ? "AM" : "PM";
      eventTimeController.text = "$hour:$minute $period";
    }
  }

  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });
 final url = Uri.parse("$baseUrl/api/announcements");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": titleController.text.trim(),
          "content": contentController.text.trim(),
          "category": selectedCategory,
          "doctorName": doctorNameController.text.trim(),
          "sourceName": sourceNameController.text.trim(),
          "sourceType": selectedSourceType,
          "targetAudience": selectedAudience,
          "eventDate": eventDateController.text.trim().isEmpty
              ? null
              : eventDateController.text.trim(),
          "eventTime": eventTimeController.text.trim(),
          "location": locationController.text.trim(),
          "priority": selectedPriority,
          "isPinned": isPinned,
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
            content: Text(data["message"] ?? "Announcement created"),
            backgroundColor: Colors.green,
          ),
        );

        titleController.clear();
        contentController.clear();
        eventDateController.clear();
        eventTimeController.clear();
        locationController.clear();

        setState(() {
          selectedCategory = "general";
          selectedAudience = "all";
          selectedSourceType = "doctor";
          selectedPriority = "normal";
          isPinned = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to create announcement"),
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
    titleController.dispose();
    contentController.dispose();
    doctorNameController.dispose();
    sourceNameController.dispose();
    eventDateController.dispose();
    eventTimeController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0E4A6B);
    const Color bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Create Announcement"),
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
                      "Create smart notification / announcement",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: doctorNameController,
                      decoration: const InputDecoration(
                        labelText: "Doctor Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: sourceNameController,
                      decoration: const InputDecoration(
                        labelText: "Source Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Source name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedSourceType,
                      decoration: const InputDecoration(
                        labelText: "Source Type",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "doctor",
                          child: Text("Doctor"),
                        ),
                        DropdownMenuItem(
                          value: "admin",
                          child: Text("Admin"),
                        ),
                        DropdownMenuItem(
                          value: "system",
                          child: Text("System"),
                        ),
                        DropdownMenuItem(
                          value: "faculty",
                          child: Text("Faculty"),
                        ),
                        DropdownMenuItem(
                          value: "conference",
                          child: Text("Conference"),
                        ),
                        DropdownMenuItem(
                          value: "other",
                          child: Text("Other"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedSourceType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Title is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Content",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Content is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "general",
                          child: Text("General"),
                        ),
                        DropdownMenuItem(
                          value: "lecture",
                          child: Text("Lecture"),
                        ),
                        DropdownMenuItem(
                          value: "exam",
                          child: Text("Exam"),
                        ),
                        DropdownMenuItem(
                          value: "urgent",
                          child: Text("Urgent"),
                        ),
                        DropdownMenuItem(
                          value: "conference",
                          child: Text("Conference"),
                        ),
                        DropdownMenuItem(
                          value: "reminder",
                          child: Text("Reminder"),
                        ),
                        DropdownMenuItem(
                          value: "material",
                          child: Text("Material"),
                        ),
                        DropdownMenuItem(
                          value: "quiz",
                          child: Text("Quiz"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedAudience,
                      decoration: const InputDecoration(
                        labelText: "Target Audience",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "all",
                          child: Text("All"),
                        ),
                        DropdownMenuItem(
                          value: "students",
                          child: Text("Students"),
                        ),
                        DropdownMenuItem(
                          value: "doctors",
                          child: Text("Doctors"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedAudience = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: "Priority",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "low",
                          child: Text("Low"),
                        ),
                        DropdownMenuItem(
                          value: "normal",
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(
                          value: "high",
                          child: Text("High"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: eventDateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "Event Date",
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: _pickEventDate,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: eventTimeController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "Event Time",
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            onTap: _pickEventTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "Location",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Pin this announcement"),
                      subtitle: const Text(
                        "Pinned announcements appear first",
                      ),
                      value: isPinned,
                      activeColor: blue,
                      onChanged: (value) {
                        setState(() {
                          isPinned = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitAnnouncement,
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
                                "Publish Announcement",
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