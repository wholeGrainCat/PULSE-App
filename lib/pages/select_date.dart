import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:student/components/app_colour.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SelectDate extends StatefulWidget {
  final selectedDate;

  const SelectDate({
    required this.selectedDate,
    super.key,
  });

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String timestamp = '';
  String selectedMood = '';
  dynamic selectedEmoji;
  bool isLoading = true; // For loading state
  late DateTime selectedDate;

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
    selectedDate = widget.selectedDate ?? DateTime.now();
    // Initialize selectedDate from the parent widget
    fetchMoodDataForSelectedDate();
  }

//Set State
  void handleMoodSelection(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

//Fetch mood and journal from database
  Future<void> fetchMoodDataForSelectedDate() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      final String selectedDateString =
          DateFormat('yyyy-MM-dd').format(selectedDate);
      final moodCollection = FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: selectedDateString)
          .limit(1);

      final querySnapshot = await moodCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        final moodData = querySnapshot.docs.first.data();
        setState(() {
          selectedMood = moodData['mood'] ?? 'Unknown';
          timestamp = DateFormat('d MMM yyyy, h:mm a').format(
            (moodData['timestamp'] as Timestamp).toDate(),
          );
          _titleController.text = moodData['journalTitle'] ?? '';
          _descriptionController.text = moodData['journalDescription'] ?? '';
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

//Save new mood and new journal
  Future<void> _saveMoodAndJournal() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    final User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? 'unknown';
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      // Query the database for an existing entry for the same date and user
      final moodCollection = _firestore
          .collection('mood_entries')
          .where('userId', isEqualTo: uid)
          .where('date', isEqualTo: formattedDate)
          .limit(1);

      final querySnapshot = await moodCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        //Update the existing entry
        final existingDocRef = querySnapshot
            .docs.first.reference; // Get the reference to the existing document
        await existingDocRef.update({
          'mood': selectedMood,
          'journalTitle': title,
          'journalDescription': description,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('New mood and journal saved successfully!');
      } else {
        print('Failed. No records');
      }
      // Navigate to MoodDoneCheckInPage
      Navigator.pushNamed(context, '/mooddonecheckin');
    } catch (e) {
      print('Failed to save mood and journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save mood and journal. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              children: [
                Text(
                  'Edit Mood',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MoodSelectionSection(
                  moods: moods,
                  selectedMood: selectedMood,
                  onMoodSelect:
                      handleMoodSelection, //callback function: inform the parent widget when a new mood is selected
                ),
                SizedBox(
                  height: 30,
                ),

                //Journal Title
                const Text(
                  '- Journal Entry -',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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

                //Journal Description
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
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cancel button
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
                            'Cancel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Save button
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
