import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:the_network/model/competition.dart';

class CompetitionDetailsScreen extends StatefulWidget {
  final Competition competition;

  const CompetitionDetailsScreen({super.key, required this.competition});

  @override
  State<CompetitionDetailsScreen> createState() => _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool isLiked = false;
  int likesCount = 0;
  int commentsCount = 0;

  @override
  void initState() {
    super.initState();
    likesCount = widget.competition.likes;
    commentsCount = widget.competition.comments;
    checkIfLiked();
  }

  void checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('competitions')
          .doc(widget.competition.id)
          .collection('likes')
          .doc(user.uid)
          .get();
      setState(() {
        isLiked = doc.exists;
      });
    }
  }

  void handleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('competitions')
          .doc(widget.competition.id)
          .collection('likes')
          .doc(user.uid);

      if (isLiked) {
        await docRef.delete();
        setState(() {
          isLiked = false;
          likesCount--;
        });
      } else {
        await docRef.set({});
        setState(() {
          isLiked = true;
          likesCount++;
        });
      }

      FirebaseFirestore.instance
          .collection('competitions')
          .doc(widget.competition.id)
          .update({'likes': likesCount});
    }
  }

  void _addComment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _commentController.text.isNotEmpty) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final comment = {
        'text': _commentController.text,
        'username': userDoc['name'] ?? 'Anonymous',
        'profileImageUrl': userDoc['profileImageUrl'] ?? 'https://via.placeholder.com/150',
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('competitions')
          .doc(widget.competition.id)
          .collection('comments')
          .add(comment);

      setState(() {
        commentsCount++;
      });

      FirebaseFirestore.instance
          .collection('competitions')
          .doc(widget.competition.id)
          .update({'comments': commentsCount});

      _commentController.clear();
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else {
      return DateFormat('h:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.competition.title),
        ),
        body: Column(
          children: [
            Image.network(widget.competition.imageUrl),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.competition.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: isLiked ? Colors.blue : Colors.black,
                        ),
                        onPressed: handleLike,
                      ),
                      Text('$likesCount'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          // Handle comment functionality
                        },
                      ),
                      Text('$commentsCount'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('competitions')
                    .doc(widget.competition.id)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment['profileImageUrl']),
                        ),
                        title: Text(comment['username']),
                        subtitle: Text(comment['text']),
                        trailing: Text(formatTimestamp(comment['timestamp'])),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}