import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'university_card.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  int? expandedCardIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('universities').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('لا يوجد بيانات'));
        }
        final universities = snapshot.data!.docs;
        return ListView.builder(
          itemCount: universities.length,
          itemBuilder: (context, index) {
            final university = universities[index];
            return UniversityCard(
              universityName: university['name'],
              departments: List<String>.from(university['departments']),
              isExpanded: expandedCardIndex == index,
              onExpand: () {
                setState(() {
                  expandedCardIndex = expandedCardIndex == index ? null : index;
                });
              },
            );
          },
        );
      },
    );
  }
}