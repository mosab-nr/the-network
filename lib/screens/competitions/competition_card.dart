import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_network/model/competition.dart';
import 'package:the_network/navigation/routes_name.dart';

class CompetitionCard extends StatefulWidget {
  final Competition competition;

  const CompetitionCard({super.key, required this.competition});

  @override
  _CompetitionCardState createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<CompetitionCard> {
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.competition.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.competition.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.competition.description),
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
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.competitionDetailsScreen,
                          arguments: widget.competition,
                        ).then((_) => setState(() {})); // Refresh on return
                      },
                    ),
                    Text('$commentsCount'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}