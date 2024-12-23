import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:student/components/app_colour.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});
  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  DateTime _focusedDate = DateTime.now(); // Current week
  DateTime? _selectedDate; // Selected date

  Map<DateTime, List<Map<String, String>>> moodHistory = {
    DateTime(2024, 12, 9): [
      {
        'emoji': '😊',
        'mood': 'Good',
        'description': 'Great Day',
        'details': 'Had a productive day and enjoyed it.'
      }
    ],
    DateTime(2024, 12, 10): [
      {
        'emoji': '😟',
        'mood': 'Not Great',
        'description': 'Feeling stressed',
        'details': 'Too many assignments due next week.'
      },
      {
        'emoji': '😐',
        'mood': 'Okay',
        'description': 'Mediocre',
        'details': 'Just an average day, nothing exciting.'
      }
    ],
  };

  // Get mood history for the selected date
  List<Map<String, String>> getMoodHistoryForSelectedDate() {
    return moodHistory[_selectedDate ?? _focusedDate] ?? [];
  }

  // Show a month picker dialog
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
        _focusedDate = picked; // Focus the calendar on the selected date
        _selectedDate = picked; // Highlight the selected date
      });
    }
  }

  // void _clearDateSelection() {
  //   setState(() {
  //     _selectedDate = null; // Clears the selected date
  //   });
  // }

  void _goToToday() {
    setState(() {
      _focusedDate = DateTime.now(); // Updates focused date to today
      _selectedDate = DateTime.now(); // Updates selected date to today
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
      body: Column(
        children: [
// Month Picker Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Go to Today Button
                TextButton.icon(
                  onPressed: _goToToday,
                  icon: const Icon(Icons.today, color: Colors.black),
                  label: const Text(
                    'Today',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8), // Adjust padding for balance
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    side: const BorderSide(
                        color: AppColors.pri_purple,
                        width: 1.5), // Border for the button
                    backgroundColor:
                        Colors.transparent, // Transparent background
                    splashFactory:
                        InkRipple.splashFactory, // Custom splash effect
                  ),
                ),
                // Clear Selection Button
                // TextButton.icon(
                //   onPressed: _clearDateSelection,
                //   icon: const Icon(Icons.clear, color: AppColors.pri_purple),
                //   label: const Text(
                //     'Clear',
                //     style: TextStyle(color: AppColors.pri_purple),
                //   ),
                // ),
                //Select date button
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

          const SizedBox(
            height: 20,
          ),

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
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                calendarFormat: CalendarFormat.week, // Show only one week
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDate = focusedDay; // Updates the visible week
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDate = focusedDay;
                },

                calendarStyle: const CalendarStyle(
                  todayTextStyle:
                      TextStyle(color: Colors.white), // Black text for today
                  selectedTextStyle: TextStyle(
                      color: Colors.black), // Black text for selected date
                  todayDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.pri_greenYellow,
                    shape: BoxShape.circle,
                  ),
                  // weekendTextStyle: TextStyle(color: Colors.red),
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

          const SizedBox(
            height: 20,
          ),
          Text(
            'Current Month: ${_focusedDate.month}/${_focusedDate.year}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.sec_cyan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.emoji_emotions),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Not great',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Today, 4:00pm',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: VerticalDivider(
                    width: 50,
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I feel stressed',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'blablablablablabla',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // // Mood History Section
          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.all(16),
          //     children: getMoodHistoryForSelectedDate()
          //         .map(
          //           (entry) => DiaryEntryCard(
          //             emoji: entry['emoji'] ?? '',
          //             mood: entry['mood'] ?? '',
          //             time: '', // Adjust if time tracking is required
          //             description: entry['description'] ?? '',
          //             details: entry['details'] ?? '',
          //             color: Colors.lightBlue[100]!,
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),

          // Check if there's mood history for the selected date
          // Expanded(
          //   child: getMoodHistoryForSelectedDate().isEmpty
          //       ? Center(
          //           child: Text(
          //             'No mood history for this day.',
          //             style: TextStyle(fontSize: 16, color: Colors.grey),
          //           ),
          //         )
          //       : ListView(
          //           padding: EdgeInsets.all(16),
          //           children: getMoodHistoryForSelectedDate()
          //               .map(
          //                 (entry) => DiaryEntryCard(
          //                   emoji: entry['emoji'] ?? '',
          //                   mood: entry['mood'] ?? '',
          //                   time: '',
          //                   description: entry['description'] ?? '',
          //                   details: entry['details'] ?? '',
          //                   color: Colors.lightBlue[100]!,
          //                 ),
          //               )
          //               .toList(),
          //         ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}

class DiaryEntryCard extends StatelessWidget {
  final String emoji;
  final String mood;
  final String time;
  final String description;
  final String details;
  final Color color;

  const DiaryEntryCard({
    super.key,
    required this.emoji,
    required this.mood,
    required this.time,
    required this.description,
    required this.details,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
