import 'package:flutter/material.dart';
import 'package:the_network/navigation/routes_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDark = ThemeData().brightness == Brightness.dark;


  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(
      context,
      RouteName.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isDark ? Image.asset('assets/logos/splashdt.png'): Image.asset('assets/logos/splashlt.png'),
      ),
    );
  }
}