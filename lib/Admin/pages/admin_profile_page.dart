import 'package:flutter/material.dart';
import 'package:student/Admin/pages/appointment_page.dart';
import 'package:student/Admin/pages/change_password_page.dart';
import 'package:student/Admin/pages/edit_admin_profile_page.dart';
import 'package:student/Admin/pages/help_center_page.dart';
import 'package:student/Admin/pages/notification_page.dart';
import 'package:student/Admin/pages/privacy_policy_page.dart';
import 'package:student/Admin/pages/settings_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  String profilePictureUrl = "";
  bool isLoading = true;
  int _currentIndex = 4;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userData = await _authService.getCurrentUserData();

      if (userData != null) {
        setState(() {
          username = userData['username'] ?? 'N/A';
          email = userData['email'] ?? 'N/A';
          profilePictureUrl = userData['profileImageUrl'] ?? '';
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
    try {
      await _authService.signout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Log out failed: $e")),
        );
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
                                : const AssetImage(
                                        'assets/images/placeholder.png')
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
                                    userId: FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        '',
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
                    // Log Out Button
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
          // Navigate based on the tab index
          switch (index) {
            case 0:
              // Navigate to Resources page
              Navigator.pushNamed(context, '/adminresource');
              break;
            case 1:
              // Navigate to Appointment page
              Navigator.pushNamed(context, '/adminappointment');
              break;
            case 2:
              // Navigate to Chat page
              Navigator.pushNamed(
                  context, '/admindashboard'); // Use named route for chat
              break;
            case 3:
              // Navigate to Profile page
              Navigator.pushNamed(context, '/adminchat');
              break;
            case 4:
              // Navigate to Profile page
              Navigator.pushNamed(context, '/adminprofile');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
