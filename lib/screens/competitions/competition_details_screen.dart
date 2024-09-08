import 'package:flutter/material.dart';

class CompetitionDetailsScreen extends StatefulWidget {
  final String title;
  final int reactions;
  final int comments;
  final String image;
  final String description;

  const CompetitionDetailsScreen({
    super.key,
    required this.title,
    required this.reactions,
    required this.comments,
    required this.image,
    required this.description,
  });

  @override
  State<CompetitionDetailsScreen> createState() => _CompetitionDetailsScreenState();
}

class _CompetitionDetailsScreenState extends State<CompetitionDetailsScreen> {
  late int reactions;
  late int comments;
  bool isLiked = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reactions = widget.reactions;
    comments = widget.comments;
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        reactions--;
      } else {
        reactions++;
      }
      isLiked = !isLiked;
    });
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments++;
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
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
                child: Text(widget.description),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked ? Colors.blue : null,
                          ),
                          onPressed: _toggleLike,
                        ),
                        Text('التفاعلات: $reactions'),
                      ],
                    ),
                    Text('التعليقات: $comments'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          labelText: 'أضف تعليقًا',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}