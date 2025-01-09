import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TextEditingControllers for input fields
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Current Password Input
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),

            // New Password Input
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm New Password Input
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.check_circle_outline),
              ),
            ),
            const SizedBox(height: 30),

            // Change Password Button
            ElevatedButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;
                final List<String> passwordErrors = [];

                // Basic Validation
                if (currentPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                  return;
                }

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'New password and confirm password do not match'),
                    ),
                  );
                  return;
                }

                // Password Validation
                if (newPassword.length < 12) {
                  passwordErrors
                      .add("Password must be at least 12 characters long.");
                }
                if (!RegExp(r'[A-Z]').hasMatch(newPassword)) {
                  passwordErrors.add(
                      "Password must contain at least one uppercase letter.");
                }
                if (!RegExp(r'[a-z]').hasMatch(newPassword)) {
                  passwordErrors.add(
                      "Password must contain at least one lowercase letter.");
                }
                if (!RegExp(r'[0-9]').hasMatch(newPassword)) {
                  passwordErrors
                      .add("Password must contain at least one number.");
                }
                if (!RegExp(r'[!@#\\$%^&*(),.?":{}|<>]')
                    .hasMatch(newPassword)) {
                  passwordErrors.add(
                      "Password must contain at least one special character.");
                }

                if (passwordErrors.isNotEmpty) {
                  // Display all validation errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(passwordErrors.join('\n')),
                    ),
                  );
                  return;
                }

                try {
                  // Get the current user
                  User? user = auth.currentUser;

                  // Re-authenticate the user
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(credential);

                  // Update the password
                  await user.updatePassword(newPassword);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully!'),
                    ),
                  );

                  // Clear Text Fields
                  currentPasswordController.clear();
                  newPasswordController.clear();
                  confirmPasswordController.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Error: Please fill in the correct current password'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF96F5),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
