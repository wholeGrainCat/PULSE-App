import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/pages/auth_service.dart';
import 'login.dart';
import 'package:student/components/text_field.dart';
import 'package:student/components/background_with_emojis.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final AuthService _auth = AuthService();
  bool isButtonEnabled = false;
  String? usernameError;
  String? emailError;
  List<String> passwordErrors = [];

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    confirmPasswordController.removeListener(_updateButtonState);
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
      usernameController.text.isNotEmpty;
    });
  }

  bool _validateInputs() {
    setState(() {
      usernameError = null;
      emailError = null;
      passwordErrors.clear();
    });

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Username validation
    if (username.length < 3) {
      setState(() {
        usernameError = "Username must be at least 3 characters long.";
      });
      return false;
    }

    // Email validation
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        emailError = "Please enter a valid email address.";
      });
    }

    // Password validation
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
    return usernameError == null &&
        emailError == null &&
        passwordErrors.isEmpty;
  }

  Future<void> _signup() async {
    if (!_validateInputs()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final user = await _auth.createUserWithEmailAndPassword(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );

    if (user != null) {
      log("Sign up successful");

      // Show the success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Sign up successful! Redirecting to login...')),
      );

      // Delay to allow SnackBar to appear
      await Future.delayed(const Duration(seconds: 2));

      // Redirect to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign up failed. Please try again.')),
      );
    }
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
                  _buildRegistrationForm(context),
                ],
              ),
            ),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 600,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              _buildTextField("Username", usernameController),
              if (usernameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    usernameError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              _buildTextField("Email", emailController),
              if (emailError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              _buildTextField("Password", passwordController,
                  obscureText: true),
              _buildTextField("Confirm Password", confirmPasswordController,
                  obscureText: true),
              if (passwordErrors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: passwordErrors
                        .map((error) => Text(
                              error,
                              style: const TextStyle(color: Colors.red),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 30),
              _buildSignUpButton(context),
              const SizedBox(height: 40),
              _buildContinueWithText(),
              const SizedBox(height: 14),
              _buildGoogleSignInButton(),
              const SizedBox(height: 28),
              _buildLoginRedirect(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: label,
          controller: controller,
          obscureText: obscureText,
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
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
        onPressed: isButtonEnabled ? _signup : null, // Call _signup here
        child: const Text(
          "SIGN UP",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildContinueWithText() {
    return const Center(
      child: Text(
        "or sign up with",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
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

  Widget _buildLoginRedirect(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text.rich(TextSpan(
              text: "Already have an account? ",
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: "SIGN IN",
                  style: TextStyle(
                    color: Color(0xFF613EEA),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF613EEA),
                  ),
                )
              ],
            )),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Positioned(
      left: 0,
      top: 90,
      right: 0,
      child: Center(
        child: Text(
          "Create Student Account",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
