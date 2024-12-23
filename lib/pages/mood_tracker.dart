import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/bottom_navigation.dart';
import 'mood_check_in.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  String selectedMood = "";
  int _currentIndex = 1;

  // List of mood options
  final List<Map<String, dynamic>> moods = [
    {"icon": Fluents.flSmilingFace, "label": "Great"},
    {"icon": Fluents.flSlightlySmilingFace, "label": "Good"},
    {"icon": Fluents.flNeutralFace, "label": "Okay"},
    {"icon": Fluents.flSlightlyFrowningFace, "label": "Not Great"},
    {"icon": Fluents.flFrowningFace, "label": "Bad"},
  ];

  void handleMoodSelection(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

  void navigateTo(String page) {
    print("Navigating to $page"); // Replace with actual navigation logic
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
                    const SizedBox(height: 28),
                    const Text(
                      'Hi, How do you feel today?',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 14),
                    // Mood Logging
                    MoodSelectionSection(
                      moods: moods,
                      selectedMood: selectedMood,
                      onMoodSelect: handleMoodSelection,
                    ),
                    const SizedBox(height: 20),
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

                    const SizedBox(height: 28),
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
        width: 330,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0),
          padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.map((mood) {
              bool isSelected = selectedMood == mood['label'];
              return Column(
                children: [
                  GestureDetector(
                      onTap: () => onMoodSelect(mood['label']),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: isSelected
                            ? const Color(0xFFE5E5E5)
                            : const Color(0xfffafafa),
                        child: FluentUiEmojiIcon(
                          fl: mood['icon'],
                          w: 40,
                          h: 40,
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
        width: 128,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF613EEA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'Check in',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
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
