import 'package:flutter/material.dart';
import 'package:the_network/screens/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // localizationsDelegates: [
      //   DefaultMaterialLocalizations.delegate,
      //   DefaultCupertinoLocalizations.delegate,
      //   DefaultWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [
      //    Locale('ar',''),
      // ],
      themeMode: ThemeMode.system,
      // onGenerateRoute: RouteGenerator.generateRoute,
      // initialRoute: RouteName.login,
      home: MainScreen(),
    );
  }
}
