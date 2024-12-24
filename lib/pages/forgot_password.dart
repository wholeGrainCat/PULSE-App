import 'package:flutter/material.dart';
import 'package:student/components/background_style_three.dart';
import 'package:student/components/background_with_emojis.dart';
import 'package:student/components/text_field.dart';
import 'package:student/components/app_colour.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  bool isButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    // Add listeners to the controllers to update the button state
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate sending a reset link
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset link sent to ${_emailController.text}'),
          ),
        );
        _emailController.clear();
      });
    }
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundStyleThree(),
            const BackgroundWithEmojis(),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 350,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffD9D9D9).withOpacity(.7),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Reset your password',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Enter your email address and we\'ll send you a link to reset your password.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          label: "Email",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            // onPressed: _isProcessing ? null : _sendResetLink,
                            onPressed: () {
                              _isProcessing
                                  ? null
                                  : Navigator.pushNamed(
                                      context, '/resetpassword');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonEnabled
                                  ? AppColors.pri_purple
                                  : Colors.grey[300],
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isProcessing
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    'Request Reset Link',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
