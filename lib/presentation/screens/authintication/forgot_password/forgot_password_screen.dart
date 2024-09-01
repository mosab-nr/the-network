import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                    if (_formKey.currentState!.validate()) {
                      // Perform forgot password action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري إرسال رابط استعادة كلمة المرور ...')),
                      );
                      _showToast('تحقق من بريدك الإلكتروني');
                    }
                  },
                  child: const Text('إرسال التحقق'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}