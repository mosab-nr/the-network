import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_network/core/constants/routes_name.dart';
import 'package:the_network/routes_generator.dart';
import 'package:the_network/screens/universities/universities_screen.dart';
import 'package:the_network/screens/universities/university_card.dart';
import 'package:the_network/screens/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
         Locale('ar',''),
      ],
      themeMode: ThemeMode.system,
      // onGenerateRoute: RouteGenerator.generateRoute,
      // initialRoute: RouteName.login,
      home: MainScreen(),
    );
  }
}
