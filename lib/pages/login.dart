import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'register.dart';
import 'package:student/components/text_field.dart';
import 'package:student/components/background_with_emojis.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to the controllers to update the button state
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Clean up controllers to avoid memory leaks
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundWithEmojis(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 180),
                  Center(
                    child: SizedBox(
                      height: 590,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              label: "Email",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              label: "Password",
                              obscureText: true,
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            _buildSignInButton(context),
                            const SizedBox(height: 40),
                            _buildContinueWithText(),
                            const SizedBox(height: 14),
                            _buildGoogleSignIn(),
                            const SizedBox(height: 28),
                            _buildSignUpAndForgotPasswordLinks(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 0,
              top: 90,
              right: 0,
              child: Center(
                child: Text(
                  "Student Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sign In Button
  Widget _buildSignInButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isButtonEnabled ? AppColors.pri_purple : Colors.grey[300],
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: isButtonEnabled
            ? () {
                Navigator.pushNamed(context, '/studentdashboard');
              }
            : null, // Disable the button when not enabled
        child: const Text(
          "SIGN IN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Continue with text
  Widget _buildContinueWithText() {
    return const Center(
      child: Text(
        "or continue with",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  // Google Sign In Button
  Widget _buildGoogleSignIn() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Handle Google Sign-In
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF613EEA),
              width: 1.0,
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 14,
            backgroundImage: AssetImage('assets/images/google.png'),
          ),
        ),
      ),
    );
  }

  // Sign Up and Forgot Password Links
  Widget _buildSignUpAndForgotPasswordLinks(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _navigateToPage(context, RegisterPage()),
            child: const Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "SIGN UP",
                    style: TextStyle(
                      color: Color(0xFF613EEA),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFF613EEA),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                ),
              );
            },
            child: const Text(
              "FORGOT PASSWORD",
              style: TextStyle(
                color: Color(0xFF613EEA),
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF613EEA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
