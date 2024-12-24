import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:student/components/app_colour.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  // Initialize Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == false) {
      return ''; // Return an empty string if no timestamp exists
    }
    DateTime date = timestamp.toDate(); // Convert Timestamp to DateTime (UTC)
    DateTime localDate = date.toLocal(); // Convert DateTime to local time
    return DateFormat('h:mm a').format(localDate); // Format the local time
  }

  // Fetch mood history for the selected date from Firestore
  Future<List<Map<String, dynamic>>> getMoodHistoryForSelectedDate() async {
    // Ensure the selected date is correctly set
    String formattedDate =
        (_selectedDate ?? _focusedDate).toIso8601String().split('T').first;

    // Print the formatted date to ensure it's correct
    print('Fetching data for date: $formattedDate');
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('mood_entries')
          .where('date', isEqualTo: formattedDate)
          .get();
      print(snapshot.docs.map((doc) => doc.data()));

      return snapshot.docs.map((doc) {
        return {
          'mood': doc['mood'],
          'title': doc['journalTitle'],
          'description': doc['journalDescription'],
          'date': doc['date'],
          'timestamp': doc['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching mood history: $e');
      return [];
    }
  }

  Future<void> addMoodEntry(
      String emoji, String mood, String description, String details) async {
    await _firestore.collection('moodHistory').add({
      'date':
          _selectedDate?.toIso8601String() ?? _focusedDate.toIso8601String(),
      'emoji': emoji,
      'mood': mood,
      'description': description,
      'details': details,
    });
    setState(() {}); // Refresh the page after adding a mood entry
  }

  Future<void> _pickMonth() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _focusedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select a Date',
      fieldHintText: 'Enter a date (MM/DD/YYYY)',
    );

    if (picked != null) {
      setState(() {
        _focusedDate = picked;
        _selectedDate = picked;
      });
    }
  }

  void _goToToday() {
    setState(() {
      _focusedDate = DateTime.now();
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Diary',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _goToToday,
                      icon: const Icon(Icons.today, color: Colors.black),
                      label: const Text(
                        'Today',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickMonth,
                      icon: const Icon(Icons.calendar_today,
                          color: AppColors.pri_purple),
                      label: const Text(
                        'Select Date',
                        style: TextStyle(color: AppColors.pri_purple),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Weekly Calendar Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: const Color(0XFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDate,
                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDate, day),
                    calendarFormat: CalendarFormat.week,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDate = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDate = focusedDay;
                    },
                    calendarStyle: const CalendarStyle(
                      todayTextStyle: TextStyle(color: Colors.white),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      todayDecoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.pri_greenYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Current Month: ${_focusedDate.month}/${_focusedDate.year}',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              // Mood History Section
              FutureBuilder<List<Map<String, dynamic>>>(
                future: getMoodHistoryForSelectedDate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No mood history for this day.'));
                  } else {
                    final moodHistory = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: moodHistory.length,
                      itemBuilder: (context, index) {
                        final entry = moodHistory[index];
                        return DiaryEntryCard(
                          mood: entry['mood'] ?? '',
                          time: formatTimestamp(entry['timestamp']),
                          description: entry['description'] ?? '',
                          title: entry['title'] ?? '',
                        );
                      },
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 128,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, '/moodtracker');
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 128,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pri_purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to Add Mood Page
                        },
                        child: const Text(
                          'Add Mood',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }
}

class DiaryEntryCard extends StatelessWidget {
  final String mood;
  final String time;
  final String title;
  final String description;

  DiaryEntryCard({
    super.key,
    required this.mood,
    required this.time,
    required this.title,
    required this.description,
  });
  // List of mood options
  final List<Map<String, dynamic>> moods = [
    {"icon": Fluents.flSmilingFace, "label": "Great"},
    {"icon": Fluents.flSlightlySmilingFace, "label": "Good"},
    {"icon": Fluents.flNeutralFace, "label": "Okay"},
    {"icon": Fluents.flSlightlyFrowningFace, "label": "Not Great"},
    {"icon": Fluents.flFrowningFace, "label": "Bad"},
  ];
// Method to get emoji based on the mood
  dynamic getEmojiForMood(String mood) {
    final moodEntry = moods.firstWhere(
      (entry) => entry['label'] == mood,
    );
    return moodEntry['icon'];
  }

  @override
  Widget build(BuildContext context) {
    // Get the corresponding emoji for the mood
    dynamic emoji = getEmojiForMood(mood);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        // color: AppColors.pri_greenYellow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FluentUiEmojiIcon(
            fl: emoji,
            w: 47,
            h: 47,
          ),
          const SizedBox(width: 16),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  time, // Display the time here
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
