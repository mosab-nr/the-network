import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_network/screens/others/voting/vote_service.dart';

import '../../../model/vote.dart';
import '../../../singleton/shared_pref_manager.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final VoteService _voteService = VoteService();
  final SharedPrefManager _sharedPrefManager = SharedPrefManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Vote> _votes = [];
  Map<String, String?> _userVotes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVotes();
    _loadUserVotes();
  }

  Future<void> _loadVotes() async {
    setState(() {
      _isLoading = true;
    });
    List<Vote> votes = await _voteService.fetchVotes();
    setState(() {
      _votes = votes;
      _isLoading = false;
    });
  }

  Future<void> _loadUserVotes() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userVotesSnapshot = await FirebaseFirestore.instance
          .collection('userVotes')
          .doc(user.uid)
          .get();
      if (userVotesSnapshot.exists) {
        setState(() {
          _userVotes = Map<String, String?>.from(userVotesSnapshot.data()!);
        });
      }
    }
  }

  Future<void> _saveUserVote(String voteId, String itemId) async {
    final user = _auth.currentUser;
    if (user != null) {
      _userVotes['vote_$voteId'] = itemId;
      await FirebaseFirestore.instance
          .collection('userVotes')
          .doc(user.uid)
          .set(_userVotes);
    }
  }

  void _onVote(String voteId, String itemId) async {
    String? previousVote = _userVotes['vote_$voteId'];
    if (previousVote != itemId) {
      // Decrease the count of the previous vote if it exists and is greater than 0
      if (previousVote != null) {
        int previousCount =
            _votes.firstWhere((vote) => vote.id == voteId).items[previousVote]!;
        if (previousCount > 0) {
          await _voteService.updateVote(
              voteId, previousVote, previousCount - 1);
        }
      }
      // Increase the count of the new vote
      int newCount =
          _votes.firstWhere((vote) => vote.id == voteId).items[itemId]! + 1;
      await _voteService.updateVote(voteId, itemId, newCount);
      // Save the user's new vote in Firestore
      await _saveUserVote(voteId, itemId);
      // Reload the votes to reflect the changes
      _loadVotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التصويت'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل الأصوات...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _votes.length,
              itemBuilder: (context, index) {
                Vote vote = _votes[index];
                String? userVote = _userVotes['vote_${vote.id}'];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vote.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(vote.description),
                        const SizedBox(height: 16),
                        ...vote.items.entries.map((entry) {
                          return ListTile(
                            title: Text('${entry.key} (${entry.value})'),
                            leading: Radio<String>(
                              value: entry.key,
                              groupValue: userVote,
                              onChanged: (value) {
                                if (value != null) {
                                  _onVote(vote.id, value);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
