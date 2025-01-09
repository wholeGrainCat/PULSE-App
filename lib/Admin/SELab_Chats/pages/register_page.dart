import 'package:chat/components/my_button.dart';
import 'package:chat/components/my_textfield.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // email, password, and confirm password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // Role dropdown
  String _selectedRole = "student"; // Default role

  void register(BuildContext context) async {
    // get auth service
    final _auth = AuthService();

    // Check if passwords match
    if (_pwController.text == _confirmPwController.text) {
      try {
        await _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
          _selectedRole, // Pass the selected role
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      // Show error if passwords don't match
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.message,
                size: 60,
                color: Color.fromARGB(98, 14, 122, 121),
              ),
              const SizedBox(height: 50),
              const Text(
                "Let's create an account!",
                style: TextStyle(
                  color: Color.fromRGBO(4, 58, 97, 0.612),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 10),
              MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(height: 25),
              // Dropdown for role selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Role",
                  ),
                  items: const [
                    DropdownMenuItem(value: "student", child: Text("Student")),
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 25),
              MyButton(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
