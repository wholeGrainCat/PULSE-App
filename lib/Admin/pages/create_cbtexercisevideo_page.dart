import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateCbtexerciseVideoPage extends StatelessWidget {
  const CreateCbtexerciseVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController thumbnailController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: appBar(context),
      body: padding(
        thumbnailController,
        titleController,
        urlController,
        context,
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'CBT Exercises',
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

  Padding padding(
    TextEditingController thumbnailController,
    TextEditingController titleController,
    TextEditingController urlController,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
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
              "YouTube Thumbnail URL",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: thumbnailController,
              decoration: InputDecoration(
                hintText: "Enter YouTube Thumbnail URL here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "YouTube Video URL",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: "Enter YouTube Video URL here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String thumbnail = thumbnailController.text.trim();
                  final String title = titleController.text.trim();
                  final String url = urlController.text.trim();
                  if (thumbnail.isNotEmpty &&
                      title.isNotEmpty &&
                      url.isNotEmpty) {
                    FirebaseFirestore.instance
                      .collection('cbtvideos').add({
                      'thumbnail': thumbnail,
                      'title': title,
                      'url': url
                    }).then((_) {
                      _showDialog(
                        context,
                        "CBT Video added successfully.",
                        Icons.check_circle,
                        Colors.green,
                        navigateBack: true,
                      );
                    }).catchError((error) {
                      _showDialog(
                        context,
                        "Failed to add CBT video: $error",
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

  void _showDialog(BuildContext context, String message, IconData icon, Color iconColor, {bool navigateBack = false}) {
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
