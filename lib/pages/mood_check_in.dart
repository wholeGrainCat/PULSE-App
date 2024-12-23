import 'package:flutter/material.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/pages/mood_done_check_in.dart';

class MoodCheckInPage extends StatefulWidget {
  final String selectedMood;
  final dynamic selectedEmoji;

  MoodCheckInPage({
    required this.selectedEmoji,
    required this.selectedMood,
  });

  @override
  State<MoodCheckInPage> createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String timestamp = '';
  int _currentIndex = 2;

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

  void navigateTo(String page) {
    print("Navigating to $page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      // Navigation Bar
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Box
            Center(
              child: Container(
                height: 233,
                width: 304,
                margin: const EdgeInsets.only(top: 70, bottom: 24),
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
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Emoji
                            FluentUiEmojiIcon(
                              fl: widget.selectedEmoji,
                              w: 60,
                              h: 60,
                            ),
                            // Mood
                            Text(
                              '${widget.selectedMood}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            // Timestamp
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
                            // Mood check-in message
                            Text(
                              'Check-in Completed!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Journal Entry Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  Text(
                    '-Journal Entry-',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Title:',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: AppColors.pri_purple, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    'Write a few words to keep you on track:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Describe your day',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.pri_purple, width: 2),
                      ),
                    ),
                    maxLines: 8,
                  ),

                  // Return button to navigate back to the previous page
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip
                        SizedBox(
                          width: 128,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoodDoneCheckIn(
                                            selectedMood: widget.selectedMood,
                                            selectedEmoji: widget.selectedEmoji,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // Save
                        SizedBox(
                          width: 128,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              String title = _titleController.text;
                              String description = _descriptionController.text;
                              // Save mood and journal
                              print('Journal Title: $title');
                              print('Journal Description: $description');
                              print('Timestamp: $timestamp');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MoodDoneCheckIn(
                                            selectedMood: widget.selectedMood,
                                            selectedEmoji: widget.selectedEmoji,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF613EEA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
