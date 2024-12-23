import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Text to display on the button
  final Color backgroundColor; // Button background color
  final Color textColor; // Text color
  final double fontSize; // Font size for the text
  final VoidCallback onPressed; // Action to perform when pressed

  const CustomButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.fontSize = 16, // Default font size
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Custom background color
          minimumSize: const Size(double.infinity, 50), // Full-width button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
        ),
        onPressed: onPressed, // Button action
        child: Text(
          text, // Display custom text
          style: TextStyle(
            color: textColor, // Custom text color
            fontSize: fontSize, // Custom font size
          ),
        ),
      ),
    );
  }
}
