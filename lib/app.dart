import 'package:flutter/material.dart';
import 'package:the_network/presentation/screens/authintication/create_new_password/create_new_password_screen.dart';
import 'package:the_network/presentation/screens/authintication/universities/universities_screen.dart';

import 'core/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      home: UniversitiesScreen()
    );
  }
}
