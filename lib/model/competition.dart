import 'package:cloud_firestore/cloud_firestore.dart';

class Competition {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int likes;
  final int comments;
  final Timestamp timestamp;

  Competition({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.timestamp,
  });

  factory Competition.fromDocument(DocumentSnapshot doc) {
    return Competition(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      imageUrl: doc['imageUrl'],
      likes: doc['likes'],
      comments: doc['comments'],
      timestamp: doc['timestamp'],
    );
  }
}