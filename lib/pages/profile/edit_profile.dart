import 'dart:io'; // Import the File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/pages/user_management.dart';

class EditProfilePage extends StatefulWidget {
  final String initialUsername;
  final ValueChanged<String> onUsernameChanged;

  const EditProfilePage({
    required this.initialUsername,
    required this.onUsernameChanged,
    super.key,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.initialUsername;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await UserManagement.getCurrentUserData();
    if (userData != null && mounted) {
      setState(() {
        profileImageUrl = userData['profileImageUrl'];
      });
    }
  }

  Future<void> _pickProfileImage() async {
    // Pick an image from gallery
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Convert the XFile to a File object
      File imageFile = File(pickedFile.path);

      // Upload to Firebase Storage
      try {
        final storageRef = FirebaseStorage.instance.ref().child(
            'profile_pictures/${FirebaseAuth.instance.currentUser!.uid}.jpg');
        await storageRef.putFile(imageFile); // Upload File object
        String downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          profileImageUrl = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload image: $e")));
      }
    }
  }

  Future<void> _saveProfileChanges() async {
    final updatedUsername = usernameController.text;

    if (updatedUsername.isNotEmpty) {
      try {
        await UserManagement.updateProfile(
          username: updatedUsername,
          profileImageUrl: profileImageUrl,
        );

        widget.onUsernameChanged(updatedUsername);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating profile: $e')));
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username cannot be empty')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Profile Picture Section
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : const AssetImage('assets/images/profilepic.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.black),
                    onPressed: _pickProfileImage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Username Field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Edit Username',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            ElevatedButton(
              onPressed: _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAF96F5),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
