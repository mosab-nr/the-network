import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_network/core/constants/routes_name.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال رابط إعادة تعيين كلمة المرور')),
          );
          Navigator.pushReplacementNamed(context, RouteName.login);
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'لم يتم العثور على المستخدم';
        } else {
          message = 'حدث خطأ ما';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نسيت كلمة المرور'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'الإيميل',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'من فضلك أدخل الإيميل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                  ),
                  child: const Text('إرسال التحقق'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}