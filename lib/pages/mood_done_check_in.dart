import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/components/app_colour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/pages/edit_mood.dart';
import 'mood_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/components/mood_line_chart.dart';

class MoodDoneCheckIn extends StatefulWidget {
  @override
  _MoodDoneCheckInState createState() => _MoodDoneCheckInState();
}

class _MoodDoneCheckInState extends State<MoodDoneCheckIn> {
  String timestamp = '';
  String selectedMood = '';
  dynamic selectedEmoji;
  bool isLoading = true; // For loading state
  int _currentIndex = 1;

  // List of mood options
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
    // Fetch the mood data and timestamp when the widget is initialized
    fetchMoodData();
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

//Check whether user already log in their mood today
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

// Fetch the latest mood data for the current user from Firestore
  Future<void> fetchMoodData() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      // Get today's date in 'yyyy-MM-dd' format
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final moodCollection = FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: todayDate)
          .orderBy('timestamp', descending: true)
          .limit(1);

      final querySnapshot = await moodCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        final moodData = querySnapshot.docs.first.data();
        setState(() {
          selectedMood = moodData['mood'] ?? 'Unknown';
          timestamp = DateFormat('d MMM yyyy, h:mm a').format(
            (moodData['timestamp'] as Timestamp).toDate(),
          );
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // No mood data found
        });
      }
    } catch (e) {
      print('Error fetching mood data: $e');
      setState(() {
        isLoading = false; // Stop loading even if an error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current date and format it
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
              navigateTo('Dashboard');
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 250,
                        width: 304,
                        margin: const EdgeInsets.only(top: 14, bottom: 18),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Mood of the day:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  // Emoji
                                  isLoading
                                      ? CircularProgressIndicator()
                                      : FluentUiEmojiIcon(
                                          fl: moods.firstWhere(
                                            (mood) =>
                                                mood['label'] == selectedMood,
                                          )['icon'],
                                          w: 47,
                                          h: 47,
                                        ),
                                  // Mood
                                  isLoading
                                      ? SizedBox()
                                      : Text(
                                          '$selectedMood',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  // Timestamp
                                  isLoading
                                      ? SizedBox()
                                      : Text(
                                          timestamp,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  const Text(
                                    'Awesome! You\'re one step closer to understanding your emotions.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                ],
                              ),
                              Positioned(
                                  right: 10,
                                  top: 10,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.pri_greenYellow,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditMoodPage()));
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Mood Chart Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MoodChartPage()),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mood Analysis',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                              width:
                                  8.0), // Adds spacing between text and arrow
                          Icon(Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black), // Right arrow icon
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: constraints.maxHeight * 0.28, // Responsive height
                      child: MoodLineChart(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NavigationButton(
                          label: "Mood Calendar",
                          icon: Fluents.flCalendar,
                          onPressed: () {
                            Navigator.pushNamed(context, '/moodcalendar');
                          },
                          backgroundColor: const Color(0xffD9F65C),
                        ),
                        NavigationButton(
                          label: "Mood Diary",
                          icon: Fluents.flNotebook,
                          onPressed: () {
                            Navigator.pushNamed(context, '/mooddiary');
                          },
                          backgroundColor: const Color(0xffA4E3E8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom widget for navigation buttons
class NavigationButton extends StatelessWidget {
  final String label;
  final dynamic icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const NavigationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 101,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: FluentUiEmojiIcon(
          w: 35,
          h: 35,
          fl: icon,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
