import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:student/components/background_style_three.dart';

class MoodCalendarPage extends StatefulWidget {
  const MoodCalendarPage({super.key});

  @override
  _MoodCalendarPageState createState() => _MoodCalendarPageState();
}

class _MoodCalendarPageState extends State<MoodCalendarPage> {
  final Map<DateTime, String> moodData = {
    DateTime(2024, 12, 1): 'great',
    DateTime(2024, 12, 2): 'good',
    DateTime(2024, 12, 3): 'okay',
    DateTime(2024, 12, 4): 'not great',
    DateTime(2024, 12, 5): 'bad',
  };

  final Map<String, Color> moodColors = {
    'great': Colors.purple,
    'good': Colors.teal,
    'okay': Colors.blueAccent,
    'not great': Colors.yellowAccent,
    'bad': Colors.redAccent,
  };

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
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
      body: Center(
        child: Stack(
          children: [
            const BackgroundStyleThree(),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 500,
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
                  child: TableCalendar(
                    firstDay: DateTime(2024),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    calendarStyle: const CalendarStyle(
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        if (moodData.containsKey(day)) {
                          String mood = moodData[day]!;
                          return Container(
                            decoration: BoxDecoration(
                              color: moodColors[mood],
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              day.day.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month', // Only show month view
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false, // Hide the format button
                      titleCentered: true, // Center the title
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
