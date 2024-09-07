import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:the_network/screens/universities/university_card.dart';
import 'package:the_network/screens/main_screen.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {




  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return UniversityCard(
          universityName: 'جامعة $index',
          departmentCount: 3,
        );
      },
    );
  }
}