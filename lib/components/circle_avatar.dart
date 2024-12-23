import 'package:flutter/material.dart';

class CircleAvatar extends StatelessWidget {
  final String imagePath;
  const CircleAvatar({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(imagePath),
    );
  }
}
