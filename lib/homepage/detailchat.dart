import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  final String otherUserId;
  final String otherUsername;

  const ChatDetail({
    super.key,
    required this.otherUserId,
    required this.otherUsername,
  });

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();
  late String _userId;
  late String _chatRoomId;
  late CollectionReference _messagesCollection;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    _chatRoomId = _createChatRoomId(_userId, widget.otherUserId);
    _messagesCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(_chatRoomId)
        .collection('messages');
  }

  String _createChatRoomId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2];
    userIds.sort();
    return userIds.join('_');
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _messagesCollection.add({
        'senderId': _userId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('chats').doc(_chatRoomId).set(
        {
          'lastMessage': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('images/person.png'),
            ),
            const SizedBox(width: 10),
            Text(widget.otherUsername),
          ],
        ),
        leading: IconButton(
          icon: Image.asset('images/back.png', width: 24, height: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSent = message['senderId'] == _userId;
                    final timestamp = message['timestamp'];

                    String displayTime = 'No time available';
                    if (timestamp != null) {
                      displayTime = DateFormat('hh:mm a').format((timestamp as Timestamp).toDate());
                    }

                    return ChatBubble(
                      message: message['message'],
                      time: displayTime,
                      isSent: isSent,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSent;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFFFFA37B) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 0.3,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
