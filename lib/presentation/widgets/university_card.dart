import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityCard extends StatefulWidget {
  final String universityId;
  final String universityName;

  const UniversityCard({super.key, required this.universityId, required this.universityName});

  @override
  State<UniversityCard> createState() => _UniversityCardState();
}

class _UniversityCardState extends State<UniversityCard> {
  late Future<List<Map<String, dynamic>>> _departmentsFuture;

  /*
  @override
  void initState() {
    super.initState();
    _departmentsFuture = _fetchDepartments();
  }

  Future<List<Map<String, dynamic>>> _fetchDepartments() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc(widget.universityId)
        .collection('departments')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
   */

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.universityName),
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _departmentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading departments'));
              }
              final departments = snapshot.data!;
              return Column(
                children: departments.map((department) {
                  return ExpansionTile(
                    title: Text(department['name']),
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: department['chats'].length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(department['chats'][index]),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}