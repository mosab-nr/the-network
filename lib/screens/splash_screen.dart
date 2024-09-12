import 'package:flutter/material.dart';
import 'package:the_network/navigation/routes_name.dart';
import '../singleton/shared_pref_manager.dart';
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await SharedPrefManager().init();
    // Add a delay to ensure the splash screen is visible for a minimum duration
    await Future.delayed(const Duration(milliseconds: 500));
    _determineNextScreen();
  }

  void _determineNextScreen() {
    bool isFirstTime = SharedPrefManager().isFirstTimeLogin();
    if (isFirstTime) {
    Navigator.pushReplacementNamed(context, RouteName.login);
    } else {
      Navigator.pushReplacementNamed(context, RouteName.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isDark ? Image.asset('assets/logos/splashdt.png') : Image.asset('assets/logos/splashlt.png'),
      ),
    );
  }
}