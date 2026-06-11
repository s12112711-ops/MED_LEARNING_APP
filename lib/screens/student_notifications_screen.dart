import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentNotificationsScreen extends StatefulWidget {
  const StudentNotificationsScreen({super.key});

  @override
  State<StudentNotificationsScreen> createState() =>
      _StudentNotificationsScreenState();
}

class _StudentNotificationsScreenState
    extends State<StudentNotificationsScreen> {
  bool isLoading = true;
  List notifications = [];
  String selectedFilter = "All";

  final String baseUrl = "http://10.0.2.2:5000/api/announcements";

  Set<String> seenNotificationIds = {};

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> loadSeenNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final seenList = prefs.getStringList("seen_notifications") ?? [];
    seenNotificationIds = seenList.toSet();
  }

  Future<void> saveSeenNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "seen_notifications",
      seenNotificationIds.toList(),
    );
  }

  String getNotificationId(Map item) {
    return (item["_id"] ?? item["id"] ?? "").toString();
  }

  bool isUnread(Map item) {
    final id = getNotificationId(item);
    if (id.isEmpty) return false;
    return !seenNotificationIds.contains(id);
  }

  Future<void> markCategoryAsSeen(String category) async {
    bool changed = false;

    for (final item in notifications) {
      if (item is Map) {
        final itemCategory =
            (item["category"] ?? "general").toString().toLowerCase();
        final id = getNotificationId(item);

        if (id.isNotEmpty && itemCategory == category.toLowerCase()) {
          if (!seenNotificationIds.contains(id)) {
            seenNotificationIds.add(id);
            changed = true;
          }
        }
      }
    }

    if (changed) {
      await saveSeenNotifications();
      if (mounted) setState(() {});
    }
  }

  Future<void> markAllAsSeen() async {
    bool changed = false;

    for (final item in notifications) {
      if (item is Map) {
        final id = getNotificationId(item);
        if (id.isNotEmpty && !seenNotificationIds.contains(id)) {
          seenNotificationIds.add(id);
          changed = true;
        }
      }
    }

    if (changed) {
      await saveSeenNotifications();
      if (mounted) setState(() {});
    }
  }

  int getUnreadCountForCategory(String label) {
    if (label == "All") {
      return notifications.where((item) {
        if (item is! Map) return false;
        return isUnread(item);
      }).length;
    }

    return notifications.where((item) {
      if (item is! Map) return false;
      final category = (item["category"] ?? "general").toString().toLowerCase();
      return category == label.toLowerCase() && isUnread(item);
    }).length;
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      await loadSeenNotifications();

      final response = await http.get(Uri.parse(baseUrl));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          notifications = data is List ? data : [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load notifications"),
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

  List get filteredNotifications {
    if (selectedFilter == "All") return notifications;

    return notifications.where((item) {
      final category = (item["category"] ?? "general").toString().toLowerCase();
      return category == selectedFilter.toLowerCase();
    }).toList();
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "lecture":
        return Colors.blue;
      case "exam":
        return Colors.orange;
      case "urgent":
        return Colors.red;
      case "conference":
        return Colors.purple;
      case "reminder":
        return Colors.teal;
      case "material":
        return Colors.green;
      case "quiz":
        return Colors.indigo;
      default:
        return Colors.grey.shade700;
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
      case "conference":
        return Icons.groups_outlined;
      case "reminder":
        return Icons.alarm_outlined;
      case "material":
        return Icons.menu_book_outlined;
      case "quiz":
        return Icons.quiz_outlined;
      default:
        return Icons.notifications_outlined;
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

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
        return Colors.red;
      case "low":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String formatPriority(String priority) {
    if (priority.isEmpty) return "Normal";
    return priority[0].toUpperCase() + priority.substring(1).toLowerCase();
  }

  String formatSourceType(String sourceType) {
    if (sourceType.isEmpty) return "System";
    return sourceType[0].toUpperCase() + sourceType.substring(1).toLowerCase();
  }

  String getSourceText(Map item) {
    final sourceName = (item["sourceName"] ?? "").toString().trim();
    final doctorName = (item["doctorName"] ?? "").toString().trim();
    final sourceType = (item["sourceType"] ?? "").toString().trim();

    if (sourceName.isNotEmpty) return sourceName;
    if (doctorName.isNotEmpty) return doctorName;
    if (sourceType.isNotEmpty) return formatSourceType(sourceType);
    return "System";
  }

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "No date";
    try {
      final date = DateTime.parse(rawDate).toLocal();
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return rawDate;
    }
  }

  String formatDateTime(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "No date";
    try {
      final date = DateTime.parse(rawDate).toLocal();
      return "${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return rawDate;
    }
  }

  Widget buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    final unreadCount = getUnreadCountForCategory(label);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) async {
            setState(() {
              selectedFilter = label;
            });

            if (label == "All") {
              await markAllAsSeen();
            } else {
              await markCategoryAsSeen(label);
            }
          },
          selectedColor: const Color(0xFF0E4A6B),
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1F3B5B),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            right: -4,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                unreadCount > 9 ? "9+" : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildInfoBadge({
    required String text,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "NEW",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget buildNotificationCard(Map item) {
    const blue = Color(0xFF0E4A6B);

    final title = (item["title"] ?? "No title").toString();
    final content = (item["content"] ?? "").toString();
    final category = (item["category"] ?? "general").toString();
    final audience = (item["targetAudience"] ?? "all").toString();
    final createdAt = item["createdAt"]?.toString();
    final isPinned = item["isPinned"] == true;
    final source = getSourceText(item);
    final sourceType = (item["sourceType"] ?? "system").toString();
    final eventDate = item["eventDate"]?.toString() ?? "";
    final eventTime = (item["eventTime"] ?? "").toString();
    final location = (item["location"] ?? "").toString();
    final priority = (item["priority"] ?? "normal").toString();
    final unread = isUnread(item);

    final bool hasEventInfo =
        eventDate.trim().isNotEmpty ||
        eventTime.trim().isNotEmpty ||
        location.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: unread ? const Color(0xFFF8FBFF) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: unread ? Border.all(color: Colors.red.withAlpha(64)) : null,
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
            children: [
              CircleAvatar(
                backgroundColor: getCategoryColor(category).withAlpha(31),
                child: Icon(
                  getCategoryIcon(category),
                  color: getCategoryColor(category),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: blue,
                  ),
                ),
              ),
              if (unread) buildNewBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              buildInfoBadge(
                text: formatCategory(category),
                color: getCategoryColor(category),
                icon: getCategoryIcon(category),
              ),
              buildInfoBadge(
                text: formatAudience(audience),
                color: getAudienceColor(audience),
                icon: Icons.groups_outlined,
              ),
              buildInfoBadge(
                text: "Source: $source",
                color: Colors.grey.shade700,
                icon: Icons.campaign_outlined,
              ),
              buildInfoBadge(
                text: formatPriority(priority),
                color: getPriorityColor(priority),
                icon: Icons.flag_outlined,
              ),
              buildInfoBadge(
                text: formatSourceType(sourceType),
                color: Colors.indigo,
                icon: Icons.account_tree_outlined,
              ),
              if (isPinned)
                buildInfoBadge(
                  text: "Pinned",
                  color: Colors.orange,
                  icon: Icons.push_pin,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          if (hasEventInfo) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: blue.withAlpha(15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: blue.withAlpha(31)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Event Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blue,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (eventDate.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Date: ${formatDate(eventDate)}",
                              style: const TextStyle(fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (eventTime.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Time: $eventTime",
                              style: const TextStyle(fontSize: 13.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (location.trim().isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Location: $location",
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          Text(
            "Published: ${formatDateTime(createdAt)}",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0E4A6B);
    const bg = Color(0xFFF5F8FC);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Notification"),
        backgroundColor: blue,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotifications,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Notification",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Stay updated with lectures, exams, conferences, reminders, and important academic events.",
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildFilterChip("All"),
                buildFilterChip("General"),
                buildFilterChip("Lecture"),
                buildFilterChip("Exam"),
                buildFilterChip("Urgent"),
                buildFilterChip("Conference"),
                buildFilterChip("Reminder"),
                buildFilterChip("Material"),
                buildFilterChip("Quiz"),
              ],
            ),
            const SizedBox(height: 18),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filteredNotifications.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                  child: Text(
                    "No notifications found",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ...filteredNotifications.map(
                (item) => buildNotificationCard(item as Map),
              ),
          ],
        ),
      ),
    );
  }
}