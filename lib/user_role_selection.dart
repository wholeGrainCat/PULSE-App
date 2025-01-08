import 'package:flutter/material.dart';
import 'package:student/components/background_style_three.dart';
import 'package:student/components/app_colour.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(
          children: [
            const BackgroundStyleThree(),
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
                    "Your journey to well-being begins here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Student Button with style
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text("Student"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pri_greenYellow,
                      foregroundColor: Colors.black,
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
                  SizedBox(height: 10),
                  // Admin Button with style
                  ElevatedButton(
                    onPressed: () {
                      // Insert route Navigate to Admin login Page when compiling
                    },
                    child: Text("Admin"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pri_cyan,
                      foregroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 18, // Text size
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
