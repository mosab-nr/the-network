import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_network/model/competition.dart';

import 'competition_card.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('competitions').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final competitions = snapshot.data!.docs
            .map((doc) => Competition.fromDocument(doc))
            .toList();

        return ListView.builder(
          itemCount: competitions.length,
          itemBuilder: (context, index) {
            final competition = competitions[index];
            return CompetitionCard(competition: competition);
          },
        );
      },
    );
  }
}
