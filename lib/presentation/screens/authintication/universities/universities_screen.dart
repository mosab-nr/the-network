import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/botton_navigation_bar.dart';
import '../../../widgets/university_card.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  late Future<List<Map<String, dynamic>>> _universitiesFuture;

  @override
  void initState() {
    super.initState();
    _universitiesFuture = _fetchUniversities();
  }

  Future<List<Map<String, dynamic>>> _fetchUniversities() async {
    final snapshot = await FirebaseFirestore.instance.collection('universities').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الجامعات'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _universitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading universities'));
          }
          final universities = snapshot.data!;
          return ListView.builder(
            itemCount: universities.length,
            itemBuilder: (context, index) {
              return UniversityCard(
                universityId: universities[index]['id'],
                universityName: universities[index]['name'],
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}