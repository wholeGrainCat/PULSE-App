import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/app_colour.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodCheckInPage extends StatefulWidget {
  final String selectedMood;
  final dynamic selectedEmoji;

  const MoodCheckInPage({
    super.key,
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> _saveMoodAndJournal() async {
    String title = _titleController.text;
    String description = _descriptionController.text;
    final User? user = FirebaseAuth.instance.currentUser;
    String uid =
        user?.uid ?? 'unknown'; // This retrieves the logged-in user's uid.
    try {
      await _firestore.collection('mood_entries').add({
        'mood': widget.selectedMood,
        'date': DateTime.now().toIso8601String().split('T').first,
        'journalTitle': title,
        'journalDescription': description,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': uid, // Store user ID with the mood
      });
      print('Mood and journal saved successfully!');
      // Navigate to MoodDoneCheckInPage
      Navigator.pushNamed(context, '/mooddonecheckin');
    } catch (e) {
      print('Failed to save mood and journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to save mood and journal. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
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
                            const SizedBox(
                              height: 9,
                            ),
                            // Mood check-in message
                            const Text(
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
                  const Text(
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
                          borderSide: const BorderSide(
                              color: AppColors.pri_purple, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  const Text(
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
                              _saveMoodAndJournal();
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
                            onPressed: () async {
                              await _saveMoodAndJournal();
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
