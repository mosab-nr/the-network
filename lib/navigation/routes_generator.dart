import 'package:flutter/material.dart';
import 'package:the_network/model/competition.dart';
import 'package:the_network/navigation/routes_name.dart';
import 'package:the_network/screens/authintication/forgot_password/forgot_password_screen.dart';
import 'package:the_network/screens/authintication/login/login_screen.dart';
import 'package:the_network/screens/authintication/register/register_screen.dart';
import 'package:the_network/screens/competitions/competition_details_screen.dart';
import 'package:the_network/screens/main_screen.dart';

import '../screens/profile/profile_screen.dart';
import '../screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteName.mainScreen:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case RouteName.profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteName.competitionDetailsScreen:
        final competition = settings.arguments as Competition;
        return MaterialPageRoute(
            builder: (_) => CompetitionDetailsScreen(competition: competition));
      default:
        return MaterialPageRoute(builder: (_) => const MainScreen());
    }
  }
}
