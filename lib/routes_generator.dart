import 'package:flutter/material.dart';
import 'package:the_network/core/constants/routes_name.dart';
import 'package:the_network/screens/authintication/forgot_password/forgot_password_screen.dart';
import 'package:the_network/screens/authintication/login/login_screen.dart';
import 'package:the_network/screens/universities/universities_screen.dart';
import 'package:the_network/screens/authintication/register/register_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteName.universities:
        return MaterialPageRoute(builder: (_) => UniversitiesScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
