import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateCounsellorPage extends StatelessWidget {
  const CreateCounsellorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      appBar: appBar(context),
      body: padding(emailController, imageController, nameController,
          phoneNumberController, context),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Counsellors\' Information',
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
      TextEditingController emailController,
      TextEditingController imageController,
      TextEditingController nameController,
      TextEditingController phoneNumberController,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Counsellor's Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter counsellor's name here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Contact Information",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "Enter contact information here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Email Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter email address here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Profile Picture URL",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: imageController,
              decoration: InputDecoration(
                hintText: "Enter profile picture URL here.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final String name = nameController.text.trim();
                  final String phoneNumber = phoneNumberController.text.trim();
                  final String email = emailController.text.trim();
                  final String image = imageController.text.trim();
                  if (name.isNotEmpty &&
                      phoneNumber.isNotEmpty &&
                      email.isNotEmpty &&
                      image.isNotEmpty) {
                    FirebaseFirestore.instance.collection('counsellors').add({
                      'name': name,
                      'phoneNumber': phoneNumber,
                      'email': email,
                      'image': image,
                      'createdOn': FieldValue.serverTimestamp(),
                    }).then((_) {
                      _showDialog(
                        context,
                        "Counsellor's information added successfully.",
                        Icons.check_circle,
                        Colors.green,
                        navigateBack: true,
                      );
                    }).catchError((error) {
                      _showDialog(
                        context,
                        "Failed to add counsellor's information: $error",
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
