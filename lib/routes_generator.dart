import 'package:flutter/material.dart';
import 'package:the_network/core/constants/routes_name.dart';
import 'package:the_network/presentation/screens/authintication/create_new_password/create_new_password_screen.dart';
import 'package:the_network/presentation/screens/authintication/forgot_password/forgot_password_screen.dart';
import 'package:the_network/presentation/screens/authintication/login/login_screen.dart';
import 'package:the_network/presentation/screens/authintication/universities/universities_screen.dart';
import 'package:the_network/presentation/screens/authintication/register/register_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case RouteName.universities:
        return MaterialPageRoute(builder: (_) => const UniversitiesScreen());
      case RouteName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case RouteName.createNewPassword:
        return MaterialPageRoute(builder: (_) => const CreateNewPasswordScreen());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ));
    }
  }
}