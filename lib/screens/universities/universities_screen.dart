import 'package:flutter/material.dart';
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
    final universities = [
      {'name': 'جامعة أ', 'departments': ['قسم 1', 'قسم 2', 'قسم 3']},
      {'name': 'جامعة ب', 'departments': ['قسم 1', 'قسم 2']},
      {'name': 'جامعة ج', 'departments': ['قسم 1', 'قسم 2', 'قسم 3', 'قسم 4']},
    ];

    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (context, index) {
        return UniversityCard(
          universityName: universities[index]['name'].toString(),
          departments: universities[index]['departments'] as List<String>,
          isExpanded: expandedCardIndex == index,
          onExpand: () {
            setState(() {
              expandedCardIndex = expandedCardIndex == index ? null : index;
            });
          },
        );
      },
    );
  }
}