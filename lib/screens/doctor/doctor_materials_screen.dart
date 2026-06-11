import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'upload_material_screen.dart';

class DoctorMaterialsScreen extends StatefulWidget {
  const DoctorMaterialsScreen({super.key});

  @override
  State<DoctorMaterialsScreen> createState() => _DoctorMaterialsScreenState();
}

class _DoctorMaterialsScreenState extends State<DoctorMaterialsScreen> {
  bool isLoading = true;
  List materials = [];

  final String baseUrl = "http://127.0.0.1:5000/api/materials";

  @override
  void initState() {
    super.initState();
    fetchMaterials();
  }

  Future<void> fetchMaterials() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          materials = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load materials"),
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

  Future<void> deleteMaterial(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Material deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        fetchMaterials();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete material"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Delete error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return "No date";
    try {
      final date = DateTime.parse(createdAt).toLocal();
      return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return createdAt;
    }
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case "video":
        return Colors.red;
      case "image":
        return Colors.purple;
      case "link":
        return Colors.blue;
      case "document":
        return Colors.orange;
      case "other":
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case "video":
        return Icons.play_circle_outline;
      case "image":
        return Icons.image_outlined;
      case "link":
        return Icons.link_outlined;
      case "document":
        return Icons.description_outlined;
      case "other":
        return Icons.insert_drive_file_outlined;
      default:
        return Icons.picture_as_pdf_outlined;
    }
  }

  String formatType(String type) {
    if (type.isEmpty) return "PDF";
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }

  Color getPublishColor(bool isPublished) {
    return isPublished ? Colors.green : Colors.orange;
  }

  String getPublishText(bool isPublished) {
    return isPublished ? "Published" : "Draft";
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Materials"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UploadMaterialScreen(),
                    ),
                  );
                  fetchMaterials();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Upload Material",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : materials.isEmpty
                    ? const Center(
                        child: Text(
                          "No materials yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchMaterials,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: materials.length,
                          itemBuilder: (context, index) {
                            final item = materials[index];
                            final id = item["_id"];
                            final title = item["title"] ?? "No title";
                            final description = item["description"] ?? "";
                            final fileUrl = item["fileUrl"] ?? "";
                            final uploadedByName =
                                item["uploadedByName"] ?? "Unknown doctor";
                            final type = item["type"] ?? "pdf";
                            final subject = item["subject"] ?? "";
                            final topic = item["topic"] ?? "";
                            final isPublished =
                                item["isPublished"] == true ? true : false;
                            final createdAt = item["createdAt"];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
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
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.folder_open, color: blue),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: blue,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final confirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text("Delete Material"),
                                              content: const Text(
                                                "Are you sure you want to delete this material?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true && id != null) {
                                            deleteMaterial(id);
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (subject.toString().trim().isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF4FA),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            subject,
                                            style: const TextStyle(
                                              color: blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      if (topic.toString().trim().isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.indigo
                                                .withAlpha(26),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            topic,
                                            style: const TextStyle(
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              getTypeColor(type).withAlpha(31),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              getTypeIcon(type),
                                              size: 16,
                                              color: getTypeColor(type),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              formatType(type),
                                              style: TextStyle(
                                                color: getTypeColor(type),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getPublishColor(isPublished)
                                              .withAlpha(31),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          getPublishText(isPublished),
                                          style: TextStyle(
                                            color: getPublishColor(isPublished),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (description.toString().trim().isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        description,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Uploaded by: $uploadedByName",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatDate(createdAt),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (fileUrl.toString().trim().isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF4FA),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.link, color: blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              fileUrl,
                                              style: const TextStyle(
                                                color: blue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}