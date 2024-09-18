import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_network/navigation/routes_name.dart';

import '../../../singleton/shared_pref_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back navigation
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تسجيل الدخول'),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل البريد الإلكتروني';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'كلمة المرور'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'من فضلك أدخل كلمة المرور';
                          }
                          if (value.length < 8) {
                            return 'يجب أن تتكون كلمة المرور من 8 خانات على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.forgotPassword);
                        },
                        child: const Text('هل نسيت كلمة المرور؟'),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48.0),
                        ),
                        child: const Text('تسجيل الدخول'),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ليس لديك حساب؟'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, RouteName.register);
                            },
                            child: const Text('سجل الآن'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text('جاري تسجيل الدخول ...')
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final email = _emailController.text;
        final password = _passwordController.text;

        final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (credential.user!.emailVerified) {
          SharedPrefManager().setFirstTimeLogin(false);
          SharedPrefManager().setUserName(credential.user!.displayName ?? 'unknown_user');
          Navigator.pushReplacementNamed(context, RouteName.mainScreen);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يرجى التحقق من بريدك الإلكتروني لتسجيل الدخول.')),
          );
          await _auth.signOut();
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          message = 'كلمة المرور غير صحيحة. يرجى التحقق من بريدك الإلكتروني وكلمة المرور.';
          log('Log Cat ${e.toString()}');
        } else if (e.code == 'invalid-email') {
          message = 'تنسيق البريد الإلكتروني غير صالح.';
          log('Log Cat ${e.toString()}');
        } else {
          message = 'حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة مرة أخرى.';
          log('Log Cat ${e.toString()}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        log(e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ ما. يرجى المحاولة مرة أخرى.')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}