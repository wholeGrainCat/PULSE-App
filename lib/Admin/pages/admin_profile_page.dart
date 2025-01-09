import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/pages/appointment_page.dart';
import 'package:student/Admin/pages/change_password_page.dart';
import 'package:student/Admin/pages/edit_admin_profile_page.dart';
import 'package:student/Admin/pages/help_center_page.dart';
import 'package:student/Admin/pages/notification_page.dart';
import 'package:student/Admin/pages/privacy_policy_page.dart';
import 'package:student/Admin/pages/settings_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  int _currentIndex = 4;
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
                    'images/background.png',
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
                                : const AssetImage('images/placeholder.png')
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
                              'icons/Edit.svg',
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
                        'icons/notification.png',
                        "Notification",
                        page: const NotificationPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'icons/appointment.png',
                        "Appointment History",
                        page: const AdminAppointmentPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'icons/password.png',
                        "Change Password",
                        page: const ChangePasswordPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'icons/info.png',
                        "Help Center",
                        page: const HelpCenterPage(),
                      ),
                    ),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'icons/settings.png',
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
                          color: const Color(
                              0xFFDFFF66), // Light yellow background
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigate based on the tab index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/adminresource');
              break;
            case 1:
              Navigator.pushNamed(context, '/adminappointment');
              break;
            case 2:
              Navigator.pushNamed(context, '/admindashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/adminchat');
              break;
            case 4:
              Navigator.pushNamed(context, '/adminprofile');
              break;
            default:
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_rounded),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF613CEA),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildMenuContainer(
      BuildContext context, String imagePath, String title,
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
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}
