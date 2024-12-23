import 'package:flutter/material.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';

class EditMood extends StatefulWidget {
  final String selectedMood;
  final dynamic selectedEmoji;

  const EditMood({
    super.key,
    required this.selectedEmoji,
    required this.selectedMood,
  });

  @override
  State<EditMood> createState() => _EditMoodState();
}

class _EditMoodState extends State<EditMood> {
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
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
      ),
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
                              widget.selectedMood,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            // Timestamp
                            Text(
                              timestamp,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
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

            // Journal Entry Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
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
                        borderSide: const BorderSide(
                            color: AppColors.pri_purple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
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
                        borderSide: const BorderSide(
                            color: AppColors.pri_purple, width: 2),
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
                              Navigator.pop(context);
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
