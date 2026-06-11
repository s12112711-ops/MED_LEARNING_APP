import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorChatPopup extends StatefulWidget {
  final String currentUserId;
  final String doctorName;
  final VoidCallback onClose;

  const DoctorChatPopup({
    super.key,
    required this.currentUserId,
    required this.doctorName,
    required this.onClose,
  });

  @override
  State<DoctorChatPopup> createState() => _DoctorChatPopupState();
}

class _DoctorChatPopupState extends State<DoctorChatPopup> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  List<Map<String, dynamic>> messages = [];

  Map<String, dynamic>? selectedUser;

  bool isLoadingUsers = true;
  bool isLoadingMessages = false;
  bool isSending = false;

  final String baseUrl = 'http://127.0.0.1:5000/api';

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_filterUsers);
    
    // Auto-refresh every 5 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        fetchUsers(silent: true);
        if (selectedUser != null) {
          fetchMessages(selectedUser!['_id'].toString(), silent: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers({bool silent = false}) async {
    try {
      if (!silent) {
        setState(() {
          isLoadingUsers = true;
        });
      }

      final response = await http.get(
        Uri.parse('$baseUrl/messages/users/${widget.currentUserId}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        debugPrint("Chat Users Data: $data");

        allUsers = data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        filteredUsers = List<Map<String, dynamic>>.from(allUsers);
      } else {
        print("FETCH USERS FAILED: ${response.statusCode}");
        allUsers = [];
        filteredUsers = [];
      }
    } catch (e) {
      print("FETCH USERS ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading users: $e")),
        );
      }
      allUsers = [];
      filteredUsers = [];
    }

    if (mounted) {
      setState(() {
        isLoadingUsers = false;
      });
    }
  }

  void _filterUsers() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredUsers = List<Map<String, dynamic>>.from(allUsers);
      } else {
        filteredUsers = allUsers.where((user) {
          final fullName = (user['fullName'] ?? '').toString().toLowerCase();
          final nameField = (user['name'] ?? '').toString().toLowerCase();
          final email = (user['email'] ?? '').toString().toLowerCase();
          final role = (user['role'] ?? '').toString().toLowerCase();
          final computedName = _getUserName(user).toLowerCase();

          return fullName.contains(query) ||
              nameField.contains(query) ||
              email.contains(query) ||
              role.contains(query) ||
              computedName.contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchMessages(String otherUserId, {bool silent = false}) async {
    try {
      if (!silent) {
        setState(() {
          isLoadingMessages = true;
          messages = [];
        });
      }

      final response = await http.get(
        Uri.parse(
          '$baseUrl/messages/conversation/${widget.currentUserId}/$otherUserId',
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        final newMessages = data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        if (mounted) {
          setState(() {
            messages = newMessages;
            isLoadingMessages = false;
          });
        }
      } else {
        if (mounted && !silent) setState(() => isLoadingMessages = false);
      }
    } catch (e) {
      debugPrint('fetchMessages error: $e');
      if (mounted && !silent) setState(() => isLoadingMessages = false);
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || selectedUser == null || isSending) return;

    try {
      setState(() {
        isSending = true;
      });

      final response = await http.post(
        Uri.parse('$baseUrl/messages/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': widget.currentUserId,
          'receiverId': selectedUser!['_id'],
          'message': text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        messageController.clear();
        await fetchMessages(selectedUser!['_id'].toString());
        await fetchUsers(); // to update last message snippet
      } else {
        debugPrint('sendMessage failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('sendMessage error: $e');
    }

    if (mounted) {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> markAsRead(String otherId) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/messages/mark-read'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.currentUserId,
          'otherId': otherId,
        }),
      );
      // Refresh user list to clear count locally
      await fetchUsers();
    } catch (e) {
      debugPrint('markAsRead error: $e');
    }
  }

  String _formatMessageTime(dynamic timeStr) {
    if (timeStr == null) return "";
    try {
      final DateTime dt = DateTime.parse(timeStr.toString()).toLocal();
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      }
      return "${dt.day}/${dt.month}";
    } catch (e) {
      return "";
    }
  }

  String _getUserName(Map<String, dynamic> user) {
    String name = (user['fullName'] ?? user['name'] ?? '').toString().trim();
    if (name.isEmpty) {
      name = (user['email'] ?? 'Unknown User').toString().split('@').first;
    }
    return name;
  }

  String _getUserRole(Map<String, dynamic> user) {
    return (user['role'] ?? 'student').toString().toLowerCase();
  }

  String _getLastMessage(Map<String, dynamic> user) {
    return (user['lastMessage'] ?? '').toString();
  }

  Color _getAvatarColor(String role) {
    if (role == 'doctor') {
      return const Color(0xFF0E4A6B);
    }
    return const Color(0xFF3A7D44);
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    final String name = _getUserName(user);
    final String role = _getUserRole(user);
    final String lastMessage = _getLastMessage(user);
    final bool isSelected = selectedUser?['_id'] == user['_id'];
    final bool isUnread = (user['unreadCount'] ?? 0) > 0;

    return InkWell(
      onTap: () async {
        setState(() {
          selectedUser = user;
        });
        await markAsRead(user['_id'].toString());
        await fetchMessages(user['_id'].toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFEAF3FF) 
              : (isUnread ? const Color(0xFFFFF0F0) : Colors.white), // Stronger pink for unread
          border: Border(
            bottom: const BorderSide(color: Color(0xFFE8E8E8)),
            left: isUnread ? const BorderSide(color: Colors.redAccent, width: 8) : BorderSide.none, // Even thicker red bar
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: _getAvatarColor(role).withOpacity(isSelected ? 0.3 : 0.12),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: _getAvatarColor(role),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isUnread ? FontWeight.w900 : FontWeight.w700,
                            color: isUnread ? Colors.black : const Color(0xFF444444),
                          ),
                        ),
                      ),
                      if (user['lastMessageTime'] != null)
                        Text(
                          _formatMessageTime(user['lastMessageTime']),
                          style: TextStyle(
                            fontSize: 11,
                            color: isUnread ? Colors.red : Colors.grey,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.isNotEmpty ? lastMessage : 'ابدأ محادثة جديدة',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isUnread ? Colors.black87 : Colors.grey.shade600,
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isUnread)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withAlpha(102),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "${user['unreadCount']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "جديد",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final senderId = (msg['senderId'] ?? '').toString();
    final messageText = (msg['message'] ?? '').toString();
    final isMe = senderId == widget.currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF0E4A6B) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          messageText,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF0E4A6B);

    return Material(
      color: Colors.black.withAlpha(38),
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 880,
              height: 620,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Row(
                  children: [
                    Container(
                      width: 320,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          right: BorderSide(color: Color(0xFFEAEAEA)),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "الدردشات",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: widget.onClose,
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "ابحث عن طالب أو دكتور...",
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: const Color(0xFFF1F3F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: isLoadingUsers
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : filteredUsers.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.search_off, size: 48, color: Colors.grey),
                                            const SizedBox(height: 10),
                                            Text(
                                              searchController.text.isEmpty
                                                  ? "No users loaded (Total: ${allUsers.length})"
                                                  : "No matching results",
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: fetchUsers,
                                              child: const Text("Refresh List"),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.all(0),
                                        itemCount: filteredUsers.length,
                                        itemBuilder: (context, index) {
                                          return _buildUserTile(filteredUsers[index]);
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: selectedUser == null
                          ? const Center(
                              child: Text(
                                "Select a conversation",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFFEAEAEA),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: _getAvatarColor(
                                          _getUserRole(selectedUser!),
                                        ).withAlpha(31),
                                        child: Text(
                                          _getUserName(selectedUser!).isNotEmpty
                                              ? _getUserName(selectedUser!)[0]
                                                  .toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color: _getAvatarColor(
                                              _getUserRole(selectedUser!),
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _getUserName(selectedUser!),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFF7F9FC),
                                    child: isLoadingMessages
                                        ? const Center(child: CircularProgressIndicator())
                                        : messages.isEmpty
                                            ? const Center(
                                                child: Text("ابدأ أول رسالة"),
                                              )
                                            : ListView.builder(
                                                padding: const EdgeInsets.all(16),
                                                itemCount: messages.length,
                                                itemBuilder: (context, index) {
                                                  return _buildMessageBubble(
                                                    messages[index],
                                                  );
                                                },
                                              ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: messageController,
                                          onSubmitted: (_) => sendMessage(),
                                          decoration: InputDecoration(
                                            hintText: "اكتب رسالتك...",
                                            filled: true,
                                            fillColor: const Color(0xFFF1F3F5),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(24),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),
                                          ),
                                          minLines: 1,
                                          maxLines: 4,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: mainBlue,
                                        child: IconButton(
                                          onPressed: isSending ? null : sendMessage,
                                          icon: isSending
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.send,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}