import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentChatPopup extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const StudentChatPopup({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<StudentChatPopup> createState() => _StudentChatPopupState();
}

class _StudentChatPopupState extends State<StudentChatPopup> {
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

  @override
  void initState() {
    super.initState();
    fetchUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      setState(() {
        isLoadingUsers = true;
      });

      final response = await http.get(
        Uri.parse('$baseUrl/messages/users/${widget.currentUserId}'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        allUsers = data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        filteredUsers = List<Map<String, dynamic>>.from(allUsers);
      } else {
        allUsers = [];
        filteredUsers = [];
      }
    } catch (e) {
      debugPrint('fetchUsers error: $e');
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
          final name = (user['name'] ?? '').toString().toLowerCase();
          final email = (user['email'] ?? '').toString().toLowerCase();
          final role = (user['role'] ?? '').toString().toLowerCase();

          return name.contains(query) ||
              email.contains(query) ||
              role.contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchMessages(String otherUserId) async {
    try {
      setState(() {
        isLoadingMessages = true;
        messages = [];
      });

      final response = await http.get(
        Uri.parse(
          '$baseUrl/messages/conversation/${widget.currentUserId}/$otherUserId',
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        messages = data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();
      } else {
        messages = [];
      }
    } catch (e) {
      debugPrint('fetchMessages error: $e');
      messages = [];
    }

    if (mounted) {
      setState(() {
        isLoadingMessages = false;
      });
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
        await fetchUsers();
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

  String _getUserName(Map<String, dynamic> user) {
    return (user['name'] ?? 'Unknown').toString();
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

    return InkWell(
      onTap: () async {
        setState(() {
          selectedUser = user;
        });
        await fetchMessages(user['_id'].toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF3FF) : Colors.white,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE8E8E8)),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _getAvatarColor(role),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role == 'doctor' ? 'Doctor' : 'Student',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage.isNotEmpty ? lastMessage : 'ابدأ محادثة جديدة',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
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

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        width: 1100,
        height: 760,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: mainBlue, width: 8),
        ),
        child: Row(
          children: [
            Container(
              width: 400,
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFE3E3E3)),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'الدردشات',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF202020),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            size: 34,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3F5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'ابحث عن طالب أو دكتور...',
                                hintStyle: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: isLoadingUsers
                        ? const Center(child: CircularProgressIndicator())
                        : filteredUsers.isEmpty
                            ? const Center(
                                child: Text(
                                  'No conversations',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
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
                        'Select a conversation',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF333333),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE3E3E3)),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: _getAvatarColor(
                                  _getUserRole(selectedUser!),
                                ),
                                child: Text(
                                  _getUserName(selectedUser!).isNotEmpty
                                      ? _getUserName(selectedUser!)[0]
                                          .toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getUserName(selectedUser!),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    _getUserRole(selectedUser!) == 'doctor'
                                        ? 'Doctor'
                                        : 'Student',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: isLoadingMessages
                              ? const Center(child: CircularProgressIndicator())
                              : messages.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'ابدأ أول رسالة',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      itemCount: messages.length,
                                      itemBuilder: (context, index) {
                                        return _buildMessageBubble(
                                          messages[index],
                                        );
                                      },
                                    ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFE3E3E3)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  onSubmitted: (_) => sendMessage(),
                                  decoration: InputDecoration(
                                    hintText: 'اكتب رسالتك...',
                                    filled: true,
                                    fillColor: const Color(0xFFF1F3F5),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: isSending ? null : sendMessage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainBlue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: isSending
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.send),
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
    );
  }
}