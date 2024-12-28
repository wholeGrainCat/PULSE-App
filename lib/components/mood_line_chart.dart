// mood_line_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:student/components/app_colour.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodLineChart extends StatefulWidget {
  const MoodLineChart({super.key});
  @override
  _MoodLineChartState createState() => _MoodLineChartState();
}

class _MoodLineChartState extends State<MoodLineChart> {
  List<double> moodData = [];
  List<DateTime> dates = [];
  List<Color> gradientColors = [
    AppColors.pri_cyan,
    AppColors.pri_greenYellow,
    AppColors.sec_cyan,
  ];

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
    _fetchAndAnalyzeMoodData();
  }

  // To track the range of data points being displayed
  double scrollOffset = 0;
  final double visibleDataRange =
      7.0; // Number of data points visible at a time

  final Map<String, int> moodCounts = {
    "Great": 0,
    "Good": 0,
    "Okay": 0,
    "Not Great": 0,
    "Bad": 0,
  };

  double _convertMoodToDouble(String mood) {
    switch (mood) {
      case "Great":
        return 5.0;
      case "Good":
        return 4.0;
      case "Okay":
        return 3.0;
      case "Not Great":
        return 2.0;
      case "Bad":
        return 1.0;
      default:
        throw Exception("Unknown mood string: $mood");
    }
  }

  Future<void> _fetchAndAnalyzeMoodData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User is not logged in");
      return;
    }

    try {
      // Query mood entries for the user within the last 30 days
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('mood_entries')
          .where('userId', isEqualTo: userId)
          .where('date',
              isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(Duration(days: 30))))
          .get();

      // Initialize moodCounts map
      Map<String, int> fetchedMoodCounts = {
        "Great": 0,
        "Good": 0,
        "Okay": 0,
        "Not Great": 0,
        "Bad": 0,
      };
      List<double> fetchedMoodData = [];
      List<DateTime> fetchedDates = [];

      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) {
          if (doc['date'] != null && doc['mood'] != null) {
            final date = DateTime.parse(
                doc['date']); // Assuming 'date' is stored as a string

            final moodString = doc['mood'] as String;
            final mood = _convertMoodToDouble(
                moodString); // Convert mood string to double
            fetchedMoodData.add(mood);
            fetchedDates.add(date);
            if (fetchedMoodCounts.containsKey(moodString)) {
              fetchedMoodCounts[moodString] =
                  fetchedMoodCounts[moodString]! + 1;
            }
          }
        });

        print("Mood Counts: $fetchedMoodCounts");
      } else {
        print("No mood data found for the user.");
      }

      setState(() {
        moodData = fetchedMoodData;
        dates = fetchedDates;
        moodCounts.clear();
        moodCounts.addAll(fetchedMoodCounts);
      });
    } catch (e) {
      print('Error fetching and analyzing mood data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (moodData.isEmpty || dates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final int startIndex = moodData.length > visibleDataRange
        ? moodData.length - visibleDataRange.toInt()
        : 0;
    final List<double> visibleMoodData = moodData.sublist(startIndex);
    final List<DateTime> visibleDates = dates.sublist(startIndex);

    return Row(
      children: [
        // Y-axis labels
        Container(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final mood = index < 5
                  ? moods[index]
                  : moods[0]; // Define `moods` here if needed
              return FluentUiEmojiIcon(
                fl: mood["icon"], // Use the Fluent UI icon
                w: 24, // You can adjust the size
                h: 24,
              );
            }),
          ),
        ),
        // Scrollable chart
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.all(10),
              width: visibleMoodData.length *
                  50.0, // Adjust the width based on visible data points
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.transparent,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < visibleDates.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('d').format(visibleDates[index]),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        visibleMoodData.length,
                        (index) =>
                            FlSpot(index.toDouble(), visibleMoodData[index]),
                      ),
                      isCurved: true,
                      gradient: LinearGradient(colors: gradientColors),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  minY: 1,
                  maxY: 6,
                  minX: 0,
                  maxX: (visibleMoodData.length + 1.0) - 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
