import 'package:flutter/material.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centers the children vertically
      children: [
        // App name "PULSE" displayed at the top
        const Padding(
          padding: EdgeInsets.only(bottom: 10), // Adds space below the app name
          child: Text(
            "PULSE", // App name
            style: TextStyle(
              fontSize: 40, // Large font size for emphasis
              fontWeight: FontWeight.bold, // Makes the text bold
              color: Color(0xFF9747FF), // Sets a vibrant purple color
              letterSpacing:
                  2, // Adds spacing between letters for a modern look
              shadows: [
                Shadow(
                  offset: Offset(0, 3), // Adds a shadow below the text
                  blurRadius: 5, // Makes the shadow slightly blurry
                  color: Colors.black26, // Sets the shadow color
                ),
              ],
            ),
            textAlign: TextAlign.center, // Centers the text horizontally
          ),
        ),
        // Image displayed below the app name
        Image.asset(
            "assets/images/screen4.png"), // Displays the specified image from the assets
        const SizedBox(
            height: 40), // Adds vertical space between the image and text
        // Title text displayed below the image
        const Text(
          "Empowering wellness,\nin one step.", // Main title with a line break
          style: TextStyle(
            color: Colors.black, // Text color
            fontSize: 25, // Font size of the title
            fontWeight: FontWeight.bold, // Makes the title bold
          ),
          textAlign: TextAlign.center, // Centers the text horizontally
        ),
        // Subtitle text displayed below the title
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20), // Adds horizontal padding
          child: Text(
            "Start the journey with us.", // Subtitle text
            style: TextStyle(
              color: Colors.black.withOpacity(
                  0.6), // Sets text color with opacity for a subtle effect
              fontSize: 16, // Font size of the subtitle
              fontWeight: FontWeight.bold, // Makes the subtitle bold
            ),
            textAlign: TextAlign.center, // Centers the text horizontally
          ),
        ),
      ],
    );
  }
}
