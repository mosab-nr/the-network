import 'package:flutter/material.dart';
import 'package:the_network/utils/theme/dark_theme.dart';
import 'package:the_network/utils/theme/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      title: "The Network",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("The Network"),
        ),
        body: const Center(
          child: Text("The Network App"),
        ),
      ),
    );
  }
}
