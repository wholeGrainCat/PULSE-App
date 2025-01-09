import 'package:flutter/material.dart';
import 'package:student/onboarding/screen1.dart';
import 'package:student/onboarding/screen2.dart';
import 'package:student/onboarding/screen3.dart';
import 'package:student/onboarding/screen4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:student/user_role_selection.dart';

// Stateful widget to handle onboarding screen logic and state changes
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController =
      PageController(); // Controller to manage the PageView
  String buttonText =
      "Skip"; // Button text to switch between "Skip" and "Finish"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sets the background color of the screen
      body: Stack(
        children: [
          // PageView to display the onboarding screens
          PageView(
            controller:
                _pageController, // Links the PageView to the PageController
            onPageChanged: (index) {
              // Updates the button text based on the current page index
              setState(() {
                buttonText = index == 3
                    ? "Finish"
                    : "Skip"; // "Finish" on the last page, "Skip" otherwise
              });
            },
            children: const [
              Screen1(), // First onboarding screen
              Screen2(), // Second onboarding screen
              Screen3(), // Third onboarding screen
              Screen4(), // Fourth and last onboarding screen
            ],
          ),
          // Positioned container for the buttons and page indicator
          Container(
            alignment: const Alignment(
                0, 0.8), // Positions the container slightly above the bottom
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Evenly spaces out the child widgets
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigates to the HomeScreen and replaces the current screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Onboarding(),
                      ),
                    );
                  },
                  child: Text(
                    buttonText, // Displays "Skip" or "Finish" depending on the page
                    style: const TextStyle(
                      fontSize: 18, // Font size of the text
                      color: Colors.blue, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
                // SmoothPageIndicator to show the current page indicator
                SmoothPageIndicator(
                  controller:
                      _pageController, // Links the indicator to the PageController
                  count: 4, // Number of pages
                ),
                GestureDetector(
                  onTap: () {
                    if (_pageController.page == 3) {
                      // Navigates to the HomeScreen if on the last page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Onboarding(),
                        ),
                      );
                    } else {
                      // Moves to the next page if not on the last page
                      _pageController.nextPage(
                        duration: const Duration(
                            milliseconds: 500), // Animation duration
                        curve: Curves.easeIn, // Animation curve
                      );
                    }
                  },
                  child: Text(
                    buttonText == "Finish"
                        ? ""
                        : "Next", // "Next" button text unless it's the last page
                    style: const TextStyle(
                      fontSize: 18, // Font size of the text
                      color: Colors.blue, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
