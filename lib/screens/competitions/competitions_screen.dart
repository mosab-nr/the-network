import 'package:flutter/material.dart';
import 'competition_card.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final competitions = [
      {
        'title': 'مسابقة أ',
        'reactions': 120,
        'comments': 45,
        'image': 'assets/logos/splashlt.png',
        'description': 'هذه وصف موجز للمسابقة أ. إنها مسابقة مثيرة للغاية يجب أن تشارك فيها.'
      },
      {
        'title': 'مسابقة ب',
        'reactions': 85,
        'comments': 30,
        'image': 'assets/logos/splashlt.png',
        'description': 'هذه وصف موجز للمسابقة ب. إنها مسابقة مثيرة للغاية يجب أن تشارك فيها.'
      },
      // Add more competitions here
    ];

    return ListView.builder(
      itemCount: competitions.length,
      itemBuilder: (context, index) {
        return CompetitionCard(
          title: competitions[index]['title'].toString(),
          reactions: competitions[index]['reactions'] as int,
          comments: competitions[index]['comments'] as int,
          image: competitions[index]['image'].toString(),
          description: competitions[index]['description'].toString(),
        );
      },
    );
  }
}