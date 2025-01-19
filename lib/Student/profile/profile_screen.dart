import 'package:flutter/material.dart';
import 'package:student/auth_service.dart';
import 'package:student/Student/profile/appoinment_history.dart';
import 'package:student/Student/profile/change_password.dart';
import 'package:student/Student/profile/help_center.dart';
import 'package:student/Student/profile/notifications.dart';
import 'package:student/Student/profile/edit_profile.dart';
import 'package:student/Student/profile/settings_page.dart';
import 'package:student/components/background_style_two.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = ""; // Default empty string
  String email = ""; // Default empty string
  bool isLoading = true; // Add loading state

  final AuthService _auth = AuthService(); // Initialize AuthService

  int _currentIndex = 4; // Start with 'Profile' tab selected

  void navigateTo(String page) {
    print("Navigating to $page");
    // Handle other navigation cases
    if (page == 'Resource') {
      Navigator.pushNamed(context, '/resource');
    } else if (page == 'Dashboard') {
      Navigator.pushNamed(context, '/studentdashboard');
    } else if (page == 'Chat') {
      Navigator.pushNamed(context, '/chat');
    } else if (page == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when screen initializes
  }

  Future<void> checkMoodStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Retrieve the last logged date and mood status
      String? lastLoggedDate = prefs.getString('lastLoggedDate_$userId');
      DateTime today = DateTime.now();
      String todayString = "${today.year}-${today.month}-${today.day}";

      // Check if the last logged date matches today's date
      bool hasLoggedMood = (lastLoggedDate == todayString);
      print("User ID: $userId");
      print("Last Logged Date: $lastLoggedDate");
      print("Has logged mood today: $hasLoggedMood");

      if (hasLoggedMood) {
        // Navigate to the mood done page (only once)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/mooddonecheckin');
        });
      } else {
        // Navigate to the mood tracker page if not logged
        Navigator.pushReplacementNamed(context, '/moodtracker');
      }
    }
  }

  // Function to mask email for privacy
  String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final localPart = parts[0];
    final domain = parts[1];

    // Show first 4 characters of email, rest as asterisks
    final maskedLocal = localPart.length > 4
        ? '${localPart.substring(0, 4)}${'*' * (localPart.length - 4)}'
        : localPart;

    return '$maskedLocal@$domain';
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _auth.getCurrentUserData();
      if (userData != null) {
        setState(() {
          username = userData['username'] ?? "User";
          // Add null check for email
          email = userData['email'] != null
              ? maskEmail(userData['email']!)
              : "No email";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        username = "User";
        email = "No email"; // Better default value
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              navigateTo('Resource');
              break;
            case 1:
              checkMoodStatus();
              break;
            case 2:
              navigateTo('Dashboard');
              break;
            case 3:
              navigateTo('Chat');
              break;
            case 4:
              navigateTo('Profile');
              break;
          }
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                const BackgroundStyleTwo(),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor:
                                    Color.fromARGB(255, 170, 239, 232),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                      'assets/images/profilepic.png'),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfilePage(
                                        initialUsername: username,
                                        onUsernameChanged: (newUsername) {
                                          setState(() {
                                            username = newUsername;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildMenuItem(
                          context,
                          icon: Icons.history,
                          title: "Appointment History",
                          page: const AppointmentHistory(),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.lock,
                          title: "Change Password",
                          page: const ChangePasswordPage(),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.help,
                          title: "Help Center",
                          page: const HelpCenterPage(),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.settings,
                          title: "Settings",
                          page: const SettingsPage(),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            bool confirmLogout =
                                await _showLogoutConfirmationDialog(context);
                            if (confirmLogout) {
                              try {
                                await AuthService().signout();
                                Navigator.pushReplacementNamed(
                                    context, '/logout');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Failed to log out: $e")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDFFF66),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Terms & Condition | Privacy Policy',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String title, required Widget page}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Logout"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Cancel
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Confirm
                  child: const Text("Log Out"),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }
}
