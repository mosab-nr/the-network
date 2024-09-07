import 'package:flutter/material.dart';

class UniversityCard extends StatefulWidget {
  final String universityName;
  final int departmentCount;

   UniversityCard({
    super.key,
    required this.universityName,
    required this.departmentCount
  });

  @override
  State<UniversityCard> createState() => _UniversityCardState();
}

class _UniversityCardState extends State<UniversityCard> {
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.universityName),
        subtitle: Text('عدد الأقسام : ${widget.departmentCount.toString()}'),
        trailing: IconButton(
          icon: Icon(Icons.arrow_drop_down),
          onPressed: () {
            isExpanded = !isExpanded;
          },
        ),
      ),
    );
  }
}
