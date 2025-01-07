import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/components/app_colour.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';

class MoodChartPage extends StatefulWidget {
  const MoodChartPage({super.key});

  @override
  _MoodChartPageState createState() => _MoodChartPageState();
}

class _MoodChartPageState extends State<MoodChartPage> {
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
                  .format(DateTime.now().subtract(const Duration(days: 30))))
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
        for (var doc in snapshot.docs) {
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
        }

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mood Chart",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "- Mood Trend Over Time -",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildScrollableLineChart()),
            const SizedBox(height: 30),
            const Text(
              "- Mood Distribution -",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              dates.isNotEmpty
                  ? "Period: ${_formatDate(dates.first)} - ${_formatDate(dates.last)}"
                  : "No mood data available.",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 5),
            Text(
              "Total Mood Entries: ${moodData.length}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildPieChartWithLegend()),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableLineChart() {
    if (moodData.isEmpty || dates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ensure only the most recent `visibleDataRange` data points are shown.
    final int startIndex = moodData.length > visibleDataRange
        ? moodData.length - visibleDataRange.toInt()
        : 0;
    final List<double> visibleMoodData = moodData.sublist(startIndex);
    final List<DateTime> visibleDates = dates.sublist(startIndex);

    return Row(
      children: [
        // Y-axis labels
        SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final mood = moods[index]; // Get the mood from the list
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
              margin: const EdgeInsets.all(10),
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
                    getDrawingVerticalLine: (value) => const FlLine(
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
                              padding: const EdgeInsets.only(top: 8.0),
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
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
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
                      dotData: const FlDotData(show: true),
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

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildPieChartWithLegend() {
    if (moodCounts.values.every((count) => count == 0)) {
      return const Center(
        child: Text(
          "No mood data available.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final totalMoods = moodCounts.values.reduce((a, b) => a + b);
    final List<PieChartSectionData> pieSections =
        moodCounts.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final percentage = count / totalMoods * 100;

      return PieChartSectionData(
        color: _getMoodColor(mood),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color:
              (mood == "Great" || mood == "Good") ? Colors.white : Colors.black,
        ),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: pieSections,
              centerSpaceRadius: 40,
              sectionsSpace: 0,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: moodCounts.keys.map((mood) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: _getMoodColor(mood),
                ),
                const SizedBox(width: 6),
                Text(mood, style: const TextStyle(fontSize: 14)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Great":
        return const Color(0XFF9747FF);
      case "Good":
        return AppColors.sec_purple;
      case "Okay":
        return AppColors.pri_greenYellow;
      case "Not Great":
        return AppColors.pri_cyan;
      case "Bad":
        return AppColors.sec_cyan;
      default:
        return Colors.grey;
    }
  }
}
