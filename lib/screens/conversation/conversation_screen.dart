import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  final String universityName;
  final String departmentName;

  const ConversationScreen({
    super.key,
    required this.universityName,
    required this.departmentName,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('chats');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar', null).then((_) {
      _updateUserStatus(true);
    });
  }

  @override
  void dispose() {
    _updateUserStatus(false);
    super.dispose();
  }

  void _updateUserStatus(bool isJoining) {
    if (currentUser != null) {
      final userRef = _messagesRef
          .child('${widget.universityName}_${widget.departmentName}/users')
          .child(currentUser!.uid);
      if (isJoining) {
        userRef.set({'active': true});
      } else {
        userRef.remove();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.universityName} - ${widget.departmentName}'),
              StreamBuilder<DatabaseEvent>(
                stream: _messagesRef
                    .child(
                        '${widget.universityName}_${widget.departmentName}/users')
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return Text('عدد المستخدمين النشطين: 0',
                        style: TextStyle(fontSize: 14));
                  }
                  final usersMap = snapshot.data!.snapshot.value as Map?;
                  final userCount = usersMap?.length ?? 0;
                  return Text('عدد المستخدمين النشطين: $userCount',
                      style: TextStyle(fontSize: 14));
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _messagesRef
                    .child(
                        '${widget.universityName}_${widget.departmentName}/messages')
                    .orderByChild('timestamp')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return Center(child: Text('لا يوجد رسائل'));
                  }
                  final messages =
                      (snapshot.data!.snapshot.value as Map).values.toList();
                  messages
                      .sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

                  if (messages.isEmpty) {
                    return Center(child: Text('لا يوجد رسائل'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageItem(message);
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(Map message) {
    final isCurrentUser = message['uid'] == currentUser?.uid;
    final timestamp = message['timestamp'];
    DateTime messageTime;

    if (timestamp != null) {
      messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      messageTime = DateTime.now();
    }

    final now = DateTime.now();
    final isOlderThanAWeek = now.difference(messageTime).inDays > 7;
    final timeFormat = isOlderThanAWeek ? 'yyyy-MM-dd hh:mm a' : 'EEE hh:mm a';

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(message['uid'])
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        final user = snapshot.data!;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user['profileImageUrl']),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(message['content']),
                    SizedBox(height: 5),
                    Text(
                      DateFormat(timeFormat, 'ar').format(messageTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالة ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessageRef = _messagesRef
        .child('${widget.universityName}_${widget.departmentName}/messages')
        .push();
    newMessageRef.set({
      'uid': currentUser?.uid,
      'content': _messageController.text.trim(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _messageController.clear();
  }
}
