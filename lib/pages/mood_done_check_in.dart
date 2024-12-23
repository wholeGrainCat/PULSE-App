import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/components/app_colour.dart';

class MoodDoneCheckIn extends StatefulWidget {
  final String selectedMood;
  final dynamic selectedEmoji;

  MoodDoneCheckIn({
    required this.selectedEmoji,
    required this.selectedMood,
  });

  @override
  _MoodDoneCheckInState createState() => _MoodDoneCheckInState();
}

class _MoodDoneCheckInState extends State<MoodDoneCheckIn> {
  String timestamp = '';
  int _currentIndex = 1;

  void navigateTo(String page) {
    print("Navigating to $page"); // Replace with actual navigation logic
  }

  @override
  void initState() {
    super.initState();
    // Set the timestamp after widget is initialized using Future.delayed to ensure context is available
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          timestamp =
              "Today, ${TimeOfDay.now().format(context)}"; // Get the current time
        });
      }
    });
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
                                  Text(
                                    'Mood of the day:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  // Emoji
                                  FluentUiEmojiIcon(
                                    fl: widget.selectedEmoji,
                                    w: 47,
                                    h: 47,
                                  ),
                                  // Mood
                                  Text(
                                    '${widget.selectedMood}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    timestamp,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  Text(
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
                                        print("Edit button clicked");
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
                    Container(
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

// Custom widget for navigation buttons
class NavigationButton extends StatelessWidget {
  final String label;
  final dynamic icon;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const NavigationButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
  }) : super(key: key);

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
