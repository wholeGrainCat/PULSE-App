import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pulse/pages/appointment_page.dart';
import 'package:pulse/pages/change_password_page.dart';
import 'package:pulse/pages/edit_admin_profile_page.dart';
import 'package:pulse/pages/help_center_page.dart';
import 'package:pulse/pages/notification_page.dart';
import 'package:pulse/pages/privacy_policy_page.dart';
import 'package:pulse/pages/settings_page.dart';


class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}


class _AdminProfilePageState extends State<AdminProfilePage> {
  String username = "";
  String email = "";
  String profilePictureUrl = "";
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }


  void fetchUserData() async {
    try {
      // Hardcoded userId for now; replace with dynamic uid later
      String userId = 'userId1';

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'] ?? 'N/A';
          email = userDoc['email'] ?? 'N/A';
          profilePictureUrl = userDoc['profilePicture'] ?? '';
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User data not found.")),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch user data: $e")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: profilePictureUrl.isNotEmpty
                                ? NetworkImage(profilePictureUrl)
                                : const AssetImage('assets/images/placeholder.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username.isNotEmpty ? username : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  email.isNotEmpty ? email : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    initialUsername: username,
                                    userId: 'userId1', // Pass hardcoded userId
                                  ),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/Edit.svg',
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Additional Pages
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/notification.png',
                        "Notification",
                        page: const NotificationPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/appointment.png',
                        "Appointment History",
                        page: const AppointmentPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/password.png',
                        "Change Password",
                        page: const ChangePasswordPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/info.png',
                        "Help Center",
                        page: const HelpCenterPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/settings.png',
                        "Settings",
                        page: const SettingsPage(),
                      ),
                    ),
                    const SizedBox(height: 30), // Space below menu options
                    // Log Out Button
                    Center(
                      child: Container(
                        width: 300, // Width of the button
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFFF66), // Light yellow background
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        /*child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut(); // Log out user
                              Navigator.pushReplacementNamed(
                                  context, '/login'); // Navigate to login page
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Log out failed: $e")),
                              );
                            }
                          },
                          icon: Image.asset('assets/icons/logout.png'), // Log out icon
                          label: const Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: const Size(double.infinity, 30), // Height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),*/
                      ),
                    ),
                    const SizedBox(height: 20), // Space below log-out button
                    // Terms & Privacy Policy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to Terms & Privacy Policy page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PrivacyPolicyPage()),
                          );
                        },
                        child: const Text(
                          'Terms & Condition | Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildMenuContainer(BuildContext context, String imagePath, String title,
      {required Widget page}) {
    return Container(
      width: 300,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Image.asset(imagePath, width: 30, height: 30),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}