import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student/Admin/models/breathing.dart';

class UpdateBreathingPage extends StatelessWidget {
  final String breathingId;
  final Breathing breathing;

  const UpdateBreathingPage({
    super.key,
    required this.breathingId,
    required this.breathing,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: breathing.title);
    final TextEditingController introductionController =
        TextEditingController(text: breathing.introduction);
    final TextEditingController line1Controller =
        TextEditingController(text: breathing.line1);
    final TextEditingController line2Controller =
        TextEditingController(text: breathing.line2);
    final TextEditingController line3Controller =
        TextEditingController(text: breathing.line3);
    final TextEditingController line4Controller =
        TextEditingController(text: breathing.line4);
    final TextEditingController line5Controller =
        TextEditingController(text: breathing.line5);
    final TextEditingController line6Controller =
        TextEditingController(text: breathing.line6);
    final TextEditingController line7Controller =
        TextEditingController(text: breathing.line7);
    final TextEditingController line8Controller =
        TextEditingController(text: breathing.line8);
    final TextEditingController line9Controller =
        TextEditingController(text: breathing.line9);
    final TextEditingController line10Controller =
        TextEditingController(text: breathing.line10);
    final TextEditingController conclusionController =
        TextEditingController(text: breathing.conclusion);

    return Scaffold(
      appBar: appBar(context),
      body: padding(
        titleController,
        introductionController,
        line1Controller,
        line2Controller,
        line3Controller,
        line4Controller,
        line5Controller,
        line6Controller,
        line7Controller,
        line8Controller,
        line9Controller,
        line10Controller,
        conclusionController,
        context,
      ),
    );
  }

  Padding padding(
    TextEditingController titleController,
    TextEditingController introductionController,
    TextEditingController line1Controller,
    TextEditingController line2Controller,
    TextEditingController line3Controller,
    TextEditingController line4Controller,
    TextEditingController line5Controller,
    TextEditingController line6Controller,
    TextEditingController line7Controller,
    TextEditingController line8Controller,
    TextEditingController line9Controller,
    TextEditingController line10Controller,
    TextEditingController conclusionController,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title (Required)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Introduction (Required)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: introductionController,
              decoration: InputDecoration(
                hintText: "Enter Introduction here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 1 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line1Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 1 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 2 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line2Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 2 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 3 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line3Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 3 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 4 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line4Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 4 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 5 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line5Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 5 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 6 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line6Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 6 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 7 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line7Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 7 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 8 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line8Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 8 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 9 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line9Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 9 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Step 10 (Optional)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: line10Controller,
              decoration: InputDecoration(
                hintText: "Enter Step 10 here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Conclusion (Required)",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: conclusionController,
              decoration: InputDecoration(
                hintText: "Enter Conclusion here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String title = titleController.text.trim();
                  final String introduction =
                      introductionController.text.trim();
                  final String line1 = line1Controller.text.trim();
                  final String line2 = line2Controller.text.trim();
                  final String line3 = line3Controller.text.trim();
                  final String line4 = line4Controller.text.trim();
                  final String line5 = line5Controller.text.trim();
                  final String line6 = line6Controller.text.trim();
                  final String line7 = line7Controller.text.trim();
                  final String line8 = line8Controller.text.trim();
                  final String line9 = line9Controller.text.trim();
                  final String line10 = line10Controller.text.trim();
                  final String conclusion = conclusionController.text.trim();

                  if (title.isNotEmpty &&
                      introduction.isNotEmpty &&
                      conclusion.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('breaths')
                        .doc(breathingId)
                        .update({
                      'title': title,
                      'introduction': introduction,
                      'line1': line1,
                      'line2': line2,
                      'line3': line3,
                      'line4': line4,
                      'line5': line5,
                      'line6': line6,
                      'line7': line7,
                      'line8': line8,
                      'line9': line9,
                      'line10': line10,
                      'conclusion': conclusion
                    }).then((_) {
                      _showDialog(
                        context,
                        "Breathing Exercise updated successfully.",
                        Icons.check_circle,
                        Colors.green,
                        navigateBack: true,
                      );
                    }).catchError((error) {
                      _showDialog(
                        context,
                        "Failed to update Breathing Exercise: $error",
                        Icons.cancel,
                        Colors.red,
                      );
                    });
                  } else {
                    _showDialog(
                      context,
                      "All fields are required!",
                      Icons.error,
                      Colors.orange,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Breathing',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Back.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/Bell.svg',
              height: 20,
              width: 20,
            ),
          ),
        )
      ],
    );
  }

  void _showDialog(
      BuildContext context, String message, IconData icon, Color iconColor,
      {bool navigateBack = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 80, color: iconColor),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (navigateBack) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Okay",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
