import 'package:flutter/material.dart';
import 'package:the_network/navigation/routes_name.dart';
import 'package:the_network/screens/competitions/competition_details_screen.dart';

class CompetitionCard extends StatefulWidget {
  final String title;
  final int reactions;
  final int comments;
  final String image;
  final String description;

  const CompetitionCard({
    super.key,
    required this.title,
    required this.reactions,
    required this.comments,
    required this.image,
    required this.description,
  });

  @override
  State<CompetitionCard> createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<CompetitionCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.competitionDetailsScreen,
          arguments: {
            'title': widget.title,
            'reactions': widget.reactions,
            'comments': widget.comments,
            'image': widget.image,
            'description': widget.description,
          }
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.description,
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(isExpanded ? 'قراءة أقل' : 'قراءة المزيد'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('التفاعلات: ${widget.reactions}'),
                  Text('التعليقات: ${widget.comments}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}