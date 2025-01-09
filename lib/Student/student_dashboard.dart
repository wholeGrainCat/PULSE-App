import 'package:flutter/material.dart';
import 'package:student/Student/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:intl/intl.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/components/background_style_two.dart';
import 'package:student/Student/appoinment/appoinment_screen.dart';
import 'package:student/Student/crisis_support.dart';
import 'package:student/Student/self_help_tools.dart';
import 'package:student/Student/unimasresources.dart';
import 'package:student/Student/mood/mood_check_in.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 2;
  String nearestDate = "";
  String nearestTime = "";
  String nearestLocation = "";
  String selectedMood = "";
  String username = ""; // Default empty string
  String? profilePicUrl = "";
  final AuthService _auth = AuthService(); // Initialize AuthService

  final List<Map<String, dynamic>> moods = [
    {"icon": Fluents.flSmilingFace, "label": "Great"},
    {"icon": Fluents.flSlightlySmilingFace, "label": "Good"},
    {"icon": Fluents.flNeutralFace, "label": "Okay"},
    {"icon": Fluents.flSlightlyFrowningFace, "label": "Not Great"},
    {"icon": Fluents.flFrowningFace, "label": "Bad"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchNearestAppointment(); // Call the function here
    _loadUserData(); // Load user data when screen initializes
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _auth.getCurrentUserData();
      if (userData != null) {
        setState(() {
          username = userData['username'] ?? "User";
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        username = "User";
      });
    }
  }

  // Fetch the nearest appointment for the user
  void _fetchNearestAppointment() async {
    try {
      // Get the current user's UID
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          nearestDate = "Please login to view appointments";
          nearestTime = "";
          nearestLocation = "";
        });
        return;
      }

      print("Fetching appointments for user: ${user.uid}");

      // Get current date for comparison
      DateTime now = DateTime.now();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('scheduled_appointments')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date') // Order by date first
          .orderBy('time') // Then by time
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No appointments found");
        setState(() {
          nearestDate = "No appointment scheduled";
          nearestTime = "";
          nearestLocation = "";
        });
        return;
      }

      // Find the nearest future appointment
      QueryDocumentSnapshot? nearestFutureAppointment;

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Parse the appointment date and time
        try {
          final dateStr = data['date'];
          final timeStr = data['time'];
          final appointmentDateTime =
              DateFormat("yyyy-MM-dd hh:mm a").parse("$dateStr $timeStr");

          // Check if this appointment is in the future
          if (appointmentDateTime.isAfter(now)) {
            nearestFutureAppointment = doc;
            break; // Found the nearest future appointment
          }
        } catch (e) {
          print("Error parsing date/time for appointment: $e");
          continue;
        }
      }

      // Update the UI with the nearest appointment
      if (nearestFutureAppointment != null) {
        final data = nearestFutureAppointment.data() as Map<String, dynamic>;

        setState(() {
          nearestDate = data['date'] ?? 'Date not specified';
          nearestTime = data['time'] ?? 'Time not specified';
          nearestLocation = data['location'] ?? 'Location not specified';
        });
      } else {
        setState(() {
          nearestDate = "No upcoming appointments";
          nearestTime = "";
          nearestLocation = "";
        });
      }
    } catch (e) {
      print("Error fetching appointments: $e");
      setState(() {
        nearestDate = "Error fetching appointments";
        nearestTime = "";
        nearestLocation = "";
      });
    }
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

  void handleMoodSelection(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

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
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('d MMM yyyy, EEEE').format(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
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
              Navigator.pushNamed(context, '/studentdashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
      body: Stack(
        children: [
          const BackgroundStyleTwo(),
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 40, bottom: 50),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile and Greeting Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor:
                                const Color(0XFFD9D9D9).withOpacity(.7),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: profilePicUrl != null &&
                                      profilePicUrl!.isNotEmpty
                                  ? NetworkImage(profilePicUrl!)
                                      as ImageProvider
                                  : const AssetImage(
                                          'assets/images/profilepic.png')
                                      as ImageProvider, // Default image if no profile pic
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi, $username",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formattedDate,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () => _showNotifications(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Upcoming Appointment Section
                  Center(
                    child: SizedBox(
                      width: 280,
                      height: 140,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0XFFD9D9D9).withOpacity(.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Upcoming Appointment",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            // Date Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color:
                                      AppColors.pri_purple, // Orange icon color
                                  size: 20, // Icon size
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Date: $nearestDate",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Time Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  color: Colors.purple, // Orange icon color
                                  size: 20, // Icon size
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Time: $nearestTime",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Location Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green, // Orange icon color
                                  size: 20, // Icon size
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Location: $nearestLocation",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'How was your day?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  MoodSelectionSection(
                    moods: moods,
                    selectedMood: selectedMood,
                    onMoodSelect: handleMoodSelection,
                  ),
                  const SizedBox(height: 10),
                  CheckInButton(
                    onPressed: selectedMood.isEmpty
                        ? null // Disable button if no mood is selected
                        : () {
                            //Find the selected emoji
                            final selectedEmoji = moods.firstWhere(
                              (mood) => mood['label'] == selectedMood,
                            )['icon'];

                            // Navigate to Mood Check-In Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodCheckInPage(
                                  selectedMood: selectedMood,
                                  selectedEmoji: selectedEmoji,
                                ),
                              ),
                            );
                          },
                  ),

                  // Four card buttons displayed in a 2x2 grid
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final cardColors = [
                        AppColors.sec_purple,
                        AppColors.pri_greenYellow,
                        AppColors.sec_cyan,
                        AppColors.pri_cyan,
                      ];
                      return CardButton(
                        title: _getCardTitle(index),
                        color: cardColors[index % cardColors.length],
                        onTap: () => _navigateToSection(index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notifications"),
          content: const Text("You have no new notifications."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to navigate to respective sections (self-help, crisis support, etc.)
  void _navigateToSection(int index) {
    // Map index to respective screen
    final screens = [
      const SelfHelpTools(), // Screen for Self-Help Tools
      const CrisisSupport(), // Screen for Crisis Support
      const CounsellorInfoScreen(), // Screen for UNIMAS Support
      const AppointmentScreen(), // Screen for Counselling Appointment
    ];

    // Navigate to the respective screen based on the index
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screens[index]),
    );
  }

  // Get card titles based on the index
  String _getCardTitle(int index) {
    switch (index) {
      case 0:
        return "Self-Help Tools";
      case 1:
        return "Crisis Support";
      case 2:
        return "UNIMAS Support";
      case 3:
        return "Counselling Appointment";
      default:
        return "Unknown Section";
    }
  }
}

// Card button widget
class CardButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color color;

  const CardButton(
      {super.key,
      required this.title,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Custom widget for mood selection
class MoodSelectionSection extends StatelessWidget {
  final List<Map<String, dynamic>> moods;
  final String selectedMood;
  final Function(String) onMoodSelect;

  const MoodSelectionSection({
    super.key,
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xfffafafa),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((mood) {
              bool isSelected = selectedMood == mood['label'];
              return Column(
                children: [
                  GestureDetector(
                      onTap: () => onMoodSelect(mood['label']),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: isSelected
                            ? const Color(0xFFE5E5E5)
                            : const Color(0xfffafafa),
                        child: FluentUiEmojiIcon(
                          fl: mood['icon'],
                          w: 34,
                          h: 34,
                        ),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    mood['label'],
                    style: TextStyle(
                      fontSize: 12,
                      color: selectedMood == mood['label']
                          ? Colors.deepPurple
                          : Colors.black,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Custom widget for Check-in button
class CheckInButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CheckInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 106,
        height: 41,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF613EEA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'Check in',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
