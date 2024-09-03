import 'package:flutter/material.dart';
import 'package:the_network/core/constants/routes_name.dart';
import 'package:the_network/routes_generator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      themeMode: ThemeMode.system,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RouteName.login,
    );
  }
}
