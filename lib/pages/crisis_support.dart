import 'package:flutter/material.dart';

class CrisisSupport extends StatelessWidget {
  const CrisisSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crisis Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous screen
          },
        ),
      ),
    );
  }
}
