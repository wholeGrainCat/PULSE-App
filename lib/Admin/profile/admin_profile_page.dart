import 'package:flutter/material.dart';
import 'package:student/Admin/counselling_appointment/appointment_page.dart';
import 'package:student/Admin/profile/change_password_page.dart';
import 'package:student/Admin/profile/edit_admin_profile_page.dart';
import 'package:student/Admin/profile/help_center_page.dart';
import 'package:student/Admin/profile/privacy_policy_page.dart';
import 'package:student/Admin/profile/settings_page.dart';
import 'package:student/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/components/admin_bottom_navigation.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  String username = "";
  String email = "";
  String profileImageUrl = "";
  bool isLoading = true;
  int _currentIndex = 4;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await _auth.getCurrentUserData();

      if (userData != null) {
        setState(() {
          username = userData['username'] ?? 'N/A';
          email = userData['email'] ?? 'N/A';
          profileImageUrl = userData['profileImageUrl'] ?? '';
          isLoading = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Admin profile not found.")),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch admin data: $e")),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await _showLogoutConfirmationDialog(context);
    if (shouldLogout) {
      try {
        await _auth.signout();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Log out failed: $e")),
          );
        }
      }
    }
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
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 5),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? AssetImage(profileImageUrl)
                                : const AssetImage(
                                    'assets/images/placeholder.png'),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  username.isNotEmpty ? username : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 16,
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
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.black), // Material Edit Icon
                              iconSize: 30,
                              onPressed: () async {
                                final bool? updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      initialUsername:
                                          username, // Pass username from profile page
                                      initialEmail:
                                          email, // Pass email from profile page
                                      userId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                    ),
                                  ),
                                );
                                // If the profile was updated, refresh the profile data
                                if (updated == true) {
                                  await fetchUserData();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: _buildMenuContainer(
                        context,
                        'assets/icons/appointment.png',
                        "Appointment History",
                        page: const AdminAppointmentPage(),
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
                    const SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFFF66),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _handleLogout,
                          icon: Image.asset('assets/icons/logout.png'),
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
                            minimumSize: const Size(double.infinity, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyPage(),
                            ),
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
      bottomNavigationBar: AdminBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Logout"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Log Out"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
