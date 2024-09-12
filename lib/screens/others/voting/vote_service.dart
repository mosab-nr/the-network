import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/vote.dart';

class VoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Vote>> fetchVotes() async {
    QuerySnapshot snapshot = await _firestore.collection('votes').get();
    return snapshot.docs.map((doc) => Vote.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> updateVote(String voteId, String itemId, int newCount) async {
    await _firestore.collection('votes').doc(voteId).update({
      'items.$itemId': newCount,
    });
  }
}