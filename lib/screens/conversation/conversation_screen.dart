import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ConversationScreen extends StatelessWidget {
  final Map<String, dynamic> conversation;

  ConversationScreen({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(conversation['name']),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref().child('conversations/${conversation['id']}').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          Map data = snapshot.data!.snapshot.value as Map;
          return ListView(
            children: data['messages'].values.map<Widget>((message) {
              return ListTile(
                title: Text(message['text']),
                subtitle: Text('User: ${message['user']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}