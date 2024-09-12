import 'package:cloud_firestore/cloud_firestore.dart';

class Suggestion {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImageUrl;
  final String description;
  final int likes;

  Suggestion({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImageUrl,
    required this.description,
    this.likes = 0,
  });

  static Future<Suggestion> fromDocument(DocumentSnapshot doc) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(doc['userId'])
        .get();
    return Suggestion(
      id: doc.id,
      userId: doc['userId'],
      userName: userDoc['name'],
      userProfileImageUrl: userDoc['profileImageUrl'],
      description: doc['description'],
      likes: doc['likes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userProfileImageUrl': userProfileImageUrl,
      'description': description,
      'likes': likes,
    };
  }
}
