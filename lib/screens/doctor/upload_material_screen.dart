import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadMaterialScreen extends StatefulWidget {
  const UploadMaterialScreen({super.key});

  @override
  State<UploadMaterialScreen> createState() => _UploadMaterialScreenState();
}

class _UploadMaterialScreenState extends State<UploadMaterialScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController fileUrlController = TextEditingController();
  final TextEditingController uploadedByNameController =
      TextEditingController(text: "Dr Ahmad");

  String selectedType = "pdf";
  bool isPublished = true;
  bool isLoading = false;

  Future<void> _uploadMaterial() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("http://127.0.0.1:5000/api/materials");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "title": titleController.text.trim(),
          "description": descriptionController.text.trim(),
          "subject": subjectController.text.trim(),
          "topic": topicController.text.trim(),
          "type": selectedType,
          "fileUrl": fileUrlController.text.trim(),
          "uploadedByName": uploadedByNameController.text.trim(),
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
            content: Text(data["message"] ?? "Material uploaded successfully"),
            backgroundColor: Colors.green,
          ),
        );

        titleController.clear();
        descriptionController.clear();
        subjectController.clear();
        topicController.clear();
        fileUrlController.clear();

        setState(() {
          selectedType = "pdf";
          isPublished = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Failed to upload material"),
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
    descriptionController.dispose();
    subjectController.dispose();
    topicController.dispose();
    fileUrlController.dispose();
    uploadedByNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0E4A6B);
    const Color bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Upload Material"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
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
                      "Upload a new learning material",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: uploadedByNameController,
                      decoration: const InputDecoration(
                        labelText: "Doctor Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Doctor name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Material Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Material title is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Subject is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: topicController,
                      decoration: const InputDecoration(
                        labelText: "Topic",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: "Material Type",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "pdf",
                          child: Text("PDF"),
                        ),
                        DropdownMenuItem(
                          value: "video",
                          child: Text("Video"),
                        ),
                        DropdownMenuItem(
                          value: "image",
                          child: Text("Image"),
                        ),
                        DropdownMenuItem(
                          value: "link",
                          child: Text("Link"),
                        ),
                        DropdownMenuItem(
                          value: "document",
                          child: Text("Document"),
                        ),
                        DropdownMenuItem(
                          value: "other",
                          child: Text("Other"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: fileUrlController,
                      decoration: const InputDecoration(
                        labelText: "File URL / Material Link",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Publish now"),
                      subtitle: const Text(
                        "Published materials appear to students",
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
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _uploadMaterial,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Upload Material",
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