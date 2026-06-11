import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_announcement_screen.dart';

class DoctorAnnouncementsScreen extends StatefulWidget {
  const DoctorAnnouncementsScreen({super.key});

  @override
  State<DoctorAnnouncementsScreen> createState() =>
      _DoctorAnnouncementsScreenState();
}

class _DoctorAnnouncementsScreenState
    extends State<DoctorAnnouncementsScreen> {
  bool isLoading = true;
  List announcements = [];

  final String baseUrl = "http://127.0.0.1:5000/api/announcements";

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          announcements = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load announcements"),
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

  Future<void> deleteAnnouncement(String id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Announcement deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        fetchAnnouncements();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete announcement"),
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

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "lecture":
        return Colors.blue;
      case "exam":
        return Colors.orange;
      case "urgent":
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "lecture":
        return Icons.school_outlined;
      case "exam":
        return Icons.assignment_outlined;
      case "urgent":
        return Icons.priority_high;
      default:
        return Icons.info_outline;
    }
  }

  String formatCategory(String category) {
    if (category.isEmpty) return "General";
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }

  Color getAudienceColor(String audience) {
    switch (audience.toLowerCase()) {
      case "students":
        return Colors.indigo;
      case "doctors":
        return Colors.deepPurple;
      default:
        return Colors.teal;
    }
  }

  String formatAudience(String audience) {
    if (audience.isEmpty) return "All";
    return audience[0].toUpperCase() + audience.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    const Color blue = Color(0xFF0E4A6B);
    const Color bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Announcements"),
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
                      builder: (_) => const CreateAnnouncementScreen(),
                    ),
                  );
                  fetchAnnouncements();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Create Announcement",
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
                : announcements.isEmpty
                    ? const Center(
                        child: Text(
                          "No announcements yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchAnnouncements,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: announcements.length,
                          itemBuilder: (context, index) {
                            final item = announcements[index];
                            final title = item["title"] ?? "No title";
                            final content = item["content"] ?? "";
                            final doctorName =
                                item["doctorName"] ?? "Unknown doctor";
                            final createdAt = item["createdAt"];
                            final id = item["_id"];
                            final category = item["category"] ?? "general";
                            final targetAudience =
                                item["targetAudience"] ?? "all";
                            final isPinned = item["isPinned"] ?? false;

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
                                      const Icon(Icons.campaign, color: blue),
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
                                              title: const Text(
                                                "Delete Announcement",
                                              ),
                                              content: const Text(
                                                "Are you sure you want to delete this announcement?",
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
                                            deleteAnnouncement(id);
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
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getCategoryColor(category)
                                              .withAlpha(31),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              getCategoryIcon(category),
                                              size: 16,
                                              color: getCategoryColor(category),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              formatCategory(category),
                                              style: TextStyle(
                                                color: getCategoryColor(category),
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
                                          color: getAudienceColor(targetAudience)
                                              .withAlpha(31),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          formatAudience(targetAudience),
                                          style: TextStyle(
                                            color:
                                                getAudienceColor(targetAudience),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (isPinned)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber
                                                .withAlpha(46),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.push_pin,
                                                size: 16,
                                                color: Colors.orange,
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                "Pinned",
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    content,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Posted by: $doctorName",
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