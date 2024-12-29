import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/components/app_colour.dart';

class MoodDoneCheckIn extends StatefulWidget {
  const MoodDoneCheckIn({super.key});

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

  void navigateTo(String page) {
    print("Navigating to $page"); // Replace with actual navigation logic
  }

  @override
  void initState() {
    super.initState();
    // Fetch the mood data and timestamp when the widget is initialized
    fetchMoodData();
  }

  /// Fetch the latest mood data for the current user from Firestore
  Future<void> fetchMoodData() async {
    try {
      //final userId = 'currentUserId';
      final moodCollection = FirebaseFirestore.instance
          .collection('mood_entries')
          // .where('userId', isEqualTo: userId)
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
              navigateTo("Resource");
              break;
            case 1:
              navigateTo("Mood");
              break;
            case 2:
              Navigator.pushNamed(context, '/studentdashboard');
              break;
            case 3:
              navigateTo("Chat");
              break;
            case 4:
              navigateTo("Profile");
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
                                      ? const CircularProgressIndicator()
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
                                      ? const SizedBox()
                                      : Text(
                                          selectedMood,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  // Timestamp
                                  isLoading
                                      ? const SizedBox()
                                      : Text(
                                          timestamp,
                                          style: const TextStyle(
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
                                        _showEditDialog(
                                            context); // Open edit dialog
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Mood Analysis',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: constraints.maxHeight * 0.28, // Responsive height
                      child: _buildMoodGraph(),
                    ),
                    const SizedBox(height: 26),
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

  Widget _buildMoodGraph() {
    // Placeholder for the mood graph
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Text('Mood Graph Here'),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    String newMood = selectedMood; // Initialize with the current selected mood

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Mood'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mood selection options (like the emoji picker)
            ...moods.map((mood) {
              return RadioListTile<String>(
                title: Text(mood['label']),
                value: mood['label'],
                groupValue: newMood,
                onChanged: (value) {
                  setState(() {
                    newMood = value ?? '';
                  });
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without making changes
            },
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () async {
              // Update mood in Firestore if it has changed
              if (newMood != selectedMood) {
                try {
                  //final userId = 'currentUserId'; // Get the current user's ID
                  final moodCollection =
                      FirebaseFirestore.instance.collection('mood_entries');

                  // Update the mood document for the current user
                  await moodCollection
                      //.where('userId', isEqualTo: userId)
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .get()
                      .then((snapshot) {
                    if (snapshot.docs.isNotEmpty) {
                      snapshot.docs.first.reference.update({
                        'mood': newMood,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }
                  });

                  // Update the selectedMood state variable
                  setState(() {
                    selectedMood = newMood;
                  });

                  Navigator.pop(
                      context); // Close the dialog after saving changes
                } catch (e) {
                  print('Error updating mood: $e');
                }
              } else {
                Navigator.pop(
                    context); // Close the dialog without making changes if mood is the same
              }
            },
            child: const Text('Save'),
          ),
        ],
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
