import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/complaint.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  final TextEditingController _complaintController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addComplaint() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userData = await _firestore.collection('users').doc(user.uid).get();
      final complaint = Complaint(
        id: '',
        userId: user.uid,
        userName: userData['name'],
        userProfileImageUrl: userData['profileImageUrl'],
        description: _complaintController.text,
        likes: 0,
      );
      await _firestore.collection('complaints').add(complaint.toMap());
      _complaintController.clear();
    }
  }

  void _showAddComplaintDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('أضف شكوى'),
          content: TextField(
            controller: _complaintController,
            decoration: const InputDecoration(
              labelText: 'وصف الشكوى',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                _addComplaint();
                Navigator.of(context).pop();
              },
              child: const Text('نشر الشكوى'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الشكاوى'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('complaints').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final complaints = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final doc = complaints[index];
                      return FutureBuilder<Complaint>(
                        future: Complaint.fromDocument(doc),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final complaint = snapshot.data!;
                          return ComplaintCard(complaint: complaint);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddComplaintDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ComplaintCard extends StatefulWidget {
  final Complaint complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  State<ComplaintCard> createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<ComplaintCard> {
  bool _isLiked = false;
  bool _isExpanded = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final user = _auth.currentUser;
    if (user != null) {
      final likeDoc = await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaint.id)
          .collection('likes')
          .doc(user.uid)
          .get();
      setState(() {
        _isLiked = likeDoc.exists && likeDoc['liked'] == false;
      });
    }
  }

  void _toggleLike() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isLiked = !_isLiked;
      });
      int newLikes =
          _isLiked ? widget.complaint.likes + 1 : widget.complaint.likes - 1;
      if (newLikes < 0) newLikes = 0; // Ensure likes do not go below 0
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaint.id)
          .update({'likes': newLikes});
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaint.id)
          .collection('likes')
          .doc(user.uid)
          .set({'liked': _isLiked});
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.complaint.description;
    final truncatedDescription = description.length > 100
        ? description.substring(0, 100) + '... اقرأ المزيد'
        : description;

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.complaint.userProfileImageUrl),
        ),
        title: Text(widget.complaint.userName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(_isExpanded ? description : truncatedDescription),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: _isLiked ? Colors.blue : null),
                  onPressed: _toggleLike,
                ),
                Text('${widget.complaint.likes} إعجابات'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
