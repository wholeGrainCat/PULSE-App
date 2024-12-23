import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'login.dart';
import 'package:student/components/text_field.dart';
import 'package:student/components/background_with_emojis.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isButtonEnabled = false;

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
    });
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 180),
                _buildRegistrationForm(context),
              ],
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
              _buildTextField("Email", emailController),
              _buildTextField("Password", passwordController,
                  obscureText: true),
              _buildTextField("Confirm Password", confirmPasswordController,
                  obscureText: true),
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
        onPressed: isButtonEnabled
            ? () {
                if (passwordController.text == confirmPasswordController.text) {
                  // Navigate to the mood tracker or another page
                  Navigator.pushNamed(context, '/studentdashboard');
                } else {
                  // Show a snackbar for mismatched passwords
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              }
            : null,
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
        "or continue with",
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
                MaterialPageRoute(builder: (context) => LoginPage()),
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
