import 'package:flutter/material.dart';
import '../conversation/conversation_screen.dart';

class UniversityCard extends StatefulWidget {
  final String universityName;
  final List<String> departments;
  final bool isExpanded;
  final VoidCallback onExpand;

  const UniversityCard({
    super.key,
    required this.universityName,
    required this.departments,
    required this.isExpanded,
    required this.onExpand,
  });

  @override
  State<UniversityCard> createState() => _UniversityCardState();
}

class _UniversityCardState extends State<UniversityCard> {
  int? expandedDepartmentIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(widget.universityName),
            subtitle: Text('عدد الأقسام : ${widget.departments.length}'),
            trailing: IconButton(
              icon: Icon(widget.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: widget.onExpand,
            ),
          ),
          if (widget.isExpanded)
            Column(
              children: widget.departments.asMap().entries.map((entry) {
                int index = entry.key;
                String department = entry.value;
                return Column(
                  children: [
                    ListTile(
                      title: Text(department),
                      trailing: IconButton(
                        icon: Icon(expandedDepartmentIndex == index ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            expandedDepartmentIndex = expandedDepartmentIndex == index ? null : index;
                          });
                        },
                      ),
                    ),
                    if (expandedDepartmentIndex == index)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ConversationScreen(
                                      universityName: widget.universityName,
                                      departmentName: department,
                                    ),
                                  ),
                                );
                              },
                              child: Text('محادثة $department'),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}