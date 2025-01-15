import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;
  final String userId;

  const EditProfilePage({
    required this.initialUsername,
    required this.initialEmail,
    required this.userId,
    super.key,
  });
  
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load current user data from FirebaseAuth and Firestore
  Future<void> _loadUserData() async {
    currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Fetch additional user data from Firestore
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          usernameController.text = data['username'] ?? '';
          emailController.text = currentUser!.email ?? '';
        });
      }
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Save updated data to Firebase Auth and Firestore
  Future<void> _saveChanges() async {
    final updatedUsername = usernameController.text.trim();
    final updatedEmail = emailController.text.trim();

    if (updatedUsername.isEmpty || updatedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username and Email cannot be empty')),
      );
      return;
    }

try {
      // Prepare Firestore updates
      final updates = {
        'username': updatedUsername,
        'email': updatedEmail,
      };

      if (_selectedImage != null) {
        // Save the image path to Firestore (extend this to upload to Firebase Storage)
        updates['profileImageUrl'] = _selectedImage!.path;
      }

      // Navigate to the correct document: /users/<userId>/counsellors/profile
      await _firestore
          .collection('users')
          .doc(widget.userId) // Navigate to userId
          .collection('counsellors')
          .doc('profile') // Navigate to "profile" document
          .update(updates);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      // Return true to indicate successful update
    Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : const AssetImage('assets/images/placeholder.png')
                              as ImageProvider,
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Username Field
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Edit Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Edit Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save Changes Button
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
