import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String baseUrl = 'http://127.0.0.1:5000/api';
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/profile/${widget.userId}'));
      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Profile fetch error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getLevelBadge(int points) {
    if (points >= 2000) return "Consultant";
    if (points >= 1000) return "Specialist";
    if (points >= 500) return "Resident";
    if (points >= 200) return "Intern";
    return "Medical Student";
  }

  Color getBadgeColor(String level) {
    switch (level) {
      case "Consultant": return Colors.purple;
      case "Specialist": return Colors.red;
      case "Resident": return Colors.orange;
      case "Intern": return Colors.blue;
      default: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final int points = profileData?['totalPoints'] ?? 0;
    final int streak = profileData?['currentStreak'] ?? 0;
    final String level = getLevelBadge(points);
    final List badges = profileData?['badges'] ?? [];
    final List recentQuizzes = profileData?['recentQuizzes'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text("Student Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F4C75),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProfile,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF3282B8).withAlpha(26),
                    child: Text(
                      widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : "?",
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF3282B8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profileData?['fullName'] ?? widget.userName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B262C)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: getBadgeColor(level).withAlpha(26),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(color: getBadgeColor(level), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatItem("Total Points", points.toString(), Icons.stars, Colors.amber),
                  _buildStatItem("Streak", "$streak 🔥", Icons.local_fire_department, Colors.orange),
                  _buildStatItem("Badges", badges.length.toString(), Icons.emoji_events, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Badges Section
            _buildSectionHeader("Badges & Achievements"),
            SizedBox(
              height: 120,
              child: badges.isEmpty 
                ? const Center(child: Text("No badges earned yet. Keep learning!", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      return _buildBadgeCard(badges[index]);
                    },
                  ),
            ),

            const SizedBox(height: 24),

            // Recent Activity
            _buildSectionHeader("Recent Quiz Activity"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: recentQuizzes.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No quiz history found.", style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recentQuizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = recentQuizzes[index];
                      return _buildActivityTile(quiz);
                    },
                  ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B262C))),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String name) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3282B8).withAlpha(26)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified, color: Color(0xFF3282B8), size: 36),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> quiz) {
    final DateTime date = DateTime.parse(quiz['createdAt']);
    final double scorePercent = (quiz['score'] / quiz['totalQuestions']) * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: (scorePercent >= 60 ? Colors.green : Colors.red).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${scorePercent.toInt()}%",
                style: TextStyle(
                  color: scorePercent >= 60 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz['subject'] ?? "Quiz Result",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "+${quiz['pointsEarned']} pts",
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }
}
