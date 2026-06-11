import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaderboardScreen extends StatefulWidget {
  final String currentUserId;

  const LeaderboardScreen({super.key, required this.currentUserId});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final String baseUrl = 'http://127.0.0.1:5000/api';
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  String activeTab = "Weekly";

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/leaderboard/weekly'));
      if (response.statusCode == 200) {
        setState(() {
          leaderboard = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Leaderboard fetch error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Find current user rank
    Map<String, dynamic>? currentUserRank;
    try {
      currentUserRank = leaderboard.firstWhere(
        (e) => e['userId'].toString() == widget.currentUserId.toString(),
        orElse: () => null,
      );
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7),
      appBar: AppBar(
        title: const Text("Leaderboard 🏆", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F4C75),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchLeaderboard),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Tab Selector
              _buildTabSelector(),

              // Podium Section (Top 3)
              if (leaderboard.length >= 3) _buildPodium(),

              // List Section (Ranks 4+)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 80),
                  itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final student = leaderboard[index + 3];
                    return _buildRankTile(student);
                  },
                ),
              ),
            ],
          ),

          // Pinned Current User Row
          if (currentUserRank != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCurrentUserPinned(currentUserRank),
            ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0F4C75),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabItem("Weekly", true),
            _buildTabItem("All Time", false),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => activeTab = title);
          if (title == "Weekly") fetchLeaderboard();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: activeTab == title ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: activeTab == title ? const Color(0xFF0F4C75) : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double podiumHeight = 240;
        return Container(
          height: podiumHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: const Color(0xFF0F4C75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (leaderboard.length >= 2) 
                _buildPodiumSpot(leaderboard[1], 2, podiumHeight * 0.4, Colors.grey.shade300, constraints),
              if (leaderboard.length >= 1) 
                _buildPodiumSpot(leaderboard[0], 1, podiumHeight * 0.55, Colors.amber, constraints),
              if (leaderboard.length >= 3) 
                _buildPodiumSpot(leaderboard[2], 3, podiumHeight * 0.35, Colors.orange.shade300, constraints),
            ],
          ),
        );
      }
    );
  }

  Widget _buildPodiumSpot(Map<String, dynamic> student, int rank, double baseHeight, Color color, BoxConstraints constraints) {
    double avatarSize = rank == 1 ? 32 : 26;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: avatarSize,
              backgroundColor: Colors.white24,
              child: Text(
                student['studentName'][0].toUpperCase(),
                style: TextStyle(fontSize: avatarSize * 0.8, fontWeight: FontWeight.bold, color: color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              student['studentName'],
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text("${student['weeklyPoints']} pts", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: 65,
              height: baseHeight,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  "$rank",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color.withAlpha(204)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankTile(Map<String, dynamic> student) {
    bool isMe = student['userId'].toString() == widget.currentUserId.toString();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFEAF3FF) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Text("#${student['rank']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF3282B8).withAlpha(26),
            child: Text(student['studentName'][0].toUpperCase(), style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              student['studentName'],
              style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Text("${student['weeklyPoints']} pts", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F4C75))),
        ],
      ),
    );
  }

  Widget _buildCurrentUserPinned(Map<String, dynamic> current) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B262C),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Text("Rank #${current['rank']}", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 16),
          const Text("You", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text("${current['weeklyPoints']} PTS", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
