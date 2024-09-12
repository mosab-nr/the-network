import 'package:flutter/material.dart';
import 'package:the_network/navigation/routes_name.dart';
import 'package:the_network/screens/authintication/forgot_password/forgot_password_screen.dart';
import 'package:the_network/screens/authintication/login/login_screen.dart';
import 'package:the_network/screens/authintication/register/register_screen.dart';
import 'package:the_network/screens/competitions/competitions_screen.dart';
import 'package:the_network/screens/main_screen.dart';
import 'package:the_network/screens/universities/universities_screen.dart';

import '../screens/competitions/competition_details_screen.dart';
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
      case RouteName.competitionsScreen:
        return MaterialPageRoute(builder: (_) => const CompetitionsScreen());
      case RouteName.competitionDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => CompetitionDetailsScreen(
                  title: args['title'],
                  reactions: args['reactions'],
                  comments: args['comments'],
                  image: args['image'],
                  description: args['description'],
                ));
      default:
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
  }
}
