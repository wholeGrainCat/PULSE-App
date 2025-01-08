import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/pages/auth_service.dart';
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
  final _auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;
  String? emailError;
  List<String> passwordErrors = [];

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
                      height: 600,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
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
                            if (emailError != null)
                              Text(
                                emailError!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            const SizedBox(height: 5),
                            CustomTextField(
                              label: "Password",
                              obscureText: true,
                              controller: passwordController,
                            ),
                            if (passwordErrors.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: passwordErrors
                                    .map((error) => Text(
                                          error,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ))
                                    .toList(),
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
        onPressed: isButtonEnabled ? _login : null,
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

  // Input Validation
  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Reset error messages
    emailError = null;
    passwordErrors = [];

    // Email Validation
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}");
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        emailError = "Please enter a valid email address.";
      });
      return false;
    }

    // Password Validation
    if (password.length < 12) {
      passwordErrors.add("Password must be at least 12 characters long.");
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      passwordErrors
          .add("Password must contain at least one uppercase letter.");
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      passwordErrors
          .add("Password must contain at least one lowercase letter.");
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      passwordErrors.add("Password must contain at least one number.");
    }
    if (!RegExp(r'[!@#\\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      passwordErrors
          .add("Password must contain at least one special character.");
    }

    setState(() {}); // Update UI to show errors
    return passwordErrors.isEmpty; // Return true if no errors
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
        onTap: () async {
          final user = await _auth
              .loginWithGoogle(); // Assuming this returns a user or null
          if (user != null) {
            // If Google Sign-In is successful, navigate to the Student Dashboard
            Navigator.pushNamed(context, '/studentdashboard');
          } else {
            // Handle the error if Google Sign-In fails
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google Sign-In failed. Please try again.'),
              ),
            );
          }
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
            onTap: () => _navigateToPage(context, const RegisterPage()),
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
                  builder: (context) => const ForgotPasswordPage(),
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

  _login() async {
    if (!_validateInputs()) return;

    try {
      final user = await _auth.loginWithEmailAndPassword(
          emailController.text.trim(), passwordController.text);

      if (user != null) {
        Navigator.pushNamed(context, '/studentdashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }
}
