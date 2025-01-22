import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/auth_service.dart';
import 'login.dart';
import 'package:student/components/text_field.dart';
import 'package:student/components/background_with_emojis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final _firestore = FirebaseFirestore.instance;

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
    final usernameRegex = RegExp(r"^[a-zA-Z0-9._]{3,15}$");
    if (!usernameRegex.hasMatch(username)) {
      setState(() {
        usernameError =
            "Username must be 3-15 characters long and contain only letters, numbers, dots, or underscores.";
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

// Function to check if the username is already taken
  Future<bool> _isUsernameTaken(String username) async {
    try {
      bool exists = false;
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction
            .get(_firestore.collection('usernames').doc(username));
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      print('Error checking username: $e');
      throw Exception('Error checking username availability');
    }
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

    // Check if the username is already taken
    final isTaken = await _isUsernameTaken(usernameController.text.trim());
    if (isTaken) {
      setState(() {
        usernameError = "Username is already taken. Please choose another.";
      });
      return;
    }

    final user = await _auth.createUserWithEmailAndPassword(
      usernameController.text,
      emailController.text,
      passwordController.text,
      'student',
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
                  const SizedBox(height: 100), // Adjust for title spacing
                  _buildTitle(), // Add the title at the top
                  const SizedBox(height: 20),
                  _buildRegistrationForm(context),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
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
    return Center(
      child: Text(
        "Student Sign Up",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
