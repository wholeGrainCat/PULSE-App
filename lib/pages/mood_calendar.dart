import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/components/app_colour.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:student/components/background_style_three.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodCalendarPage extends StatefulWidget {
  const MoodCalendarPage({super.key});

  @override
  _MoodCalendarPageState createState() => _MoodCalendarPageState();
}

class _MoodCalendarPageState extends State<MoodCalendarPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of mood options
  final List<Map<String, dynamic>> moods = [
    {"icon": Fluents.flSmilingFace, "label": "Great"},
    {"icon": Fluents.flSlightlySmilingFace, "label": "Good"},
    {"icon": Fluents.flNeutralFace, "label": "Okay"},
    {"icon": Fluents.flSlightlyFrowningFace, "label": "Not Great"},
    {"icon": Fluents.flFrowningFace, "label": "Bad"},
  ];

//initialize currently focused and selected day to today
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, String> moodData = {}; // Updated to handle one mood per day

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  // Load all mood data for the current user
  Future<void> _loadMoodData() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Fetch mood data from Firestore
      final querySnapshot = await _firestore
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<DateTime, String> fetchedMoodData = {};

        for (var doc in querySnapshot.docs) {
          final moodEntry =
              doc.data(); // Retrieves the data stored in a Firestore document
          DateTime date = DateFormat('yyyy-MM-dd').parse(moodEntry['date']);
          date = DateTime(date.year, date.month, date.day); // Strip time
          String mood = moodEntry['mood'];
          // print('Fetched mood data: ${date} -> ${mood}');

          // Add the mood to the corresponding date
          fetchedMoodData[date] = mood;
        }

        setState(() {
          moodData = fetchedMoodData; // Update the moodData map in the state
        });
      }
    } catch (e) {
      print('Error loading mood data: $e');
    }
  }

  Future<void> _selectMood(DateTime selectedDay) async {
    String? selectedMood;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Your Mood"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: moods.map((mood) {
              return ListTile(
                leading: FluentUiEmojiIcon(
                  fl: mood['icon'],
                  w: 40,
                  h: 40,
                ),
                title: Text(mood['label']),
                onTap: () {
                  selectedMood = mood['label'];
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedMood != null) {
      await _firestore
          .collection('mood_entries')
          .doc(
              '${FirebaseAuth.instance.currentUser?.uid}_${DateFormat('yyyy-MM-dd').format(selectedDay)}')
          .set({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'date': DateFormat('yyyy-MM-dd').format(selectedDay),
        'mood': selectedMood,
        'timestamp': FieldValue.serverTimestamp(),
        'journalTitle': '',
        'journalDescription': '',
      });

      setState(() {
        moodData[selectedDay] = selectedMood!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mood Calendar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = DateTime.now();
          });
        },
        child: Center(
          child: Stack(
            children: [
              const BackgroundStyleThree(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffD9D9D9).withOpacity(.7),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TableCalendar(
                        firstDay: DateTime(2024),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _selectedDay),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: const BoxDecoration(
                            color: AppColors
                                .pri_purple, // Set color for selected day
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.pri_purple, width: 2),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            color:
                                Colors.black, // Set today's text color to black
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            // Normalize the day to match the format stored in moodData
                            DateTime normalizedDay =
                                DateTime(day.year, day.month, day.day);
                            print('Checking mood for: $normalizedDay');

                            // Check if the mood for this day exists in the data
                            if (moodData.containsKey(normalizedDay)) {
                              String mood = moodData[
                                  normalizedDay]!; // Fetch the mood for the day
                              print('Mood for $normalizedDay: $mood');

                              // Find the emoji that corresponds to the stored mood
                              var moodEntry = moods.firstWhere(
                                (moodMap) => moodMap['label'] == mood,
                              );

                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: 40, // Adjust the size as needed
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200], // Light background
                                    borderRadius: BorderRadius.circular(
                                        10), // Rounded corners
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        day.day.toString(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                          height:
                                              2), // Space between date and emoji
                                      FluentUiEmojiIcon(
                                        fl: moodEntry['icon'],
                                        w: 22,
                                        h: 22,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              print('No mood data for $normalizedDay');
                              return Center(
                                child: Text(
                                  day.day.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                          _selectMood(selectedDay);
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                        },
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.black),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.black),
                          titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, // Bold the header text
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
