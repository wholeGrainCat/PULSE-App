import 'package:flutter/material.dart';
import 'package:student/components/background_style_three.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/background_with_emojis.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            const BackgroundStyleThree(),
            const BackgroundWithEmojis(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "PULSE",
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "You are Logged Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 18),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 320, // Adjust the maxWidth as needed
                    ),
                    child: Text(
                      "Take care of yourself and we're here if you need us!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Student Button with style
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text("SIGN IN"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pri_purple,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(200, 60),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
