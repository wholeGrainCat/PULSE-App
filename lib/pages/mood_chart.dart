import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:student/components/app_colour.dart'; // For formatting dates

class MoodChartPage extends StatefulWidget {
  @override
  _MoodChartPageState createState() => _MoodChartPageState();
}

class _MoodChartPageState extends State<MoodChartPage> {
  // Sample mood data for multiple weeks
  final List<double> moodData = [
    5,
    4,
    3,
    5,
    2,
    1,
    4,
    3,
    4,
    5,
    2,
    2,
    3,
    4,
    4,
    5,
    3,
    4,
    2,
    3,
    4,
    5,
    1,
    3,
  ]; // Mood ratings
  final List<DateTime> dates = List.generate(
    24,
    (index) => DateTime.now().subtract(Duration(days: 23 - index)),
  ); // Generate dates for the past 24 days

  final Map<String, int> moodCounts = {
    "😁": 5, // Great
    "🙂": 4, // Good
    "😐": 3, // Okay
    "😞": 2, // Not Great
    "😢": 1, // Bad
  }; // Mood distribution

  // To track the range of data points being displayed
  double scrollOffset = 0;
  final double visibleDataRange =
      10.0; // Number of data points visible at a time

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
              "Mood Trend Over Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _buildScrollableLineChart(), // Scrollable curve chart with lazy loading
            ),
            const SizedBox(height: 30),
            const Text(
              "Mood Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Period: ${_formatDate(dates.first)} - ${_formatDate(dates.last)}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ), // Period display
            const SizedBox(height: 5),
            Text(
              "Total Mood Entries: ${moodData.length}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ), // Total entries display
            const SizedBox(height: 20),
            Expanded(
              child: _buildPieChartWithLegend(), // Pie chart with legend
            ),
          ],
        ),
      ),
    );
  }

  // Scrollable Line Chart with Lazy Loading
  Widget _buildScrollableLineChart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: dates.length * 50.0, // Adjust width based on data length
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              scrollOffset -= details.primaryDelta ?? 0;
              scrollOffset = scrollOffset.clamp(
                  0.0, (moodData.length - visibleDataRange) * 50.0);
            });
          },
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < dates.length) {
                        // Calculate the index of the visible data based on scrollOffset
                        final startIndex = (scrollOffset / 50).toInt();
                        final endIndex = startIndex + visibleDataRange.toInt();

                        // Only show dates for the visible range
                        if (index >= startIndex && index < endIndex) {
                          return Text(
                            DateFormat('MMM d').format(dates[index]),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1:
                          return const Text('😢');
                        case 2:
                          return const Text('😞');
                        case 3:
                          return const Text('😐');
                        case 4:
                          return const Text('🙂');
                        case 5:
                          return const Text('😁');
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    moodData.length,
                    (index) {
                      // Only display the visible data range
                      if (index >= (scrollOffset / 50).toInt() &&
                          index <
                              ((scrollOffset + visibleDataRange * 50) / 50)
                                  .toInt()) {
                        return FlSpot(index.toDouble(), moodData[index]);
                      }
                      return null; // Skip out of range points
                    },
                  ).whereType<FlSpot>().toList(), // Filter out null values
                  isCurved: true,
                  color: AppColors.pri_cyan,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.pri_cyan.withOpacity(0.2),
                  ),
                ),
              ],
              minY: 1,
              maxY: 5,
              minX: 0,
              maxX: (moodData.length - 1).toDouble(),
            ),
          ),
        ),
      ),
    );
  }

  // Pie Chart with Legend
  Widget _buildPieChartWithLegend() {
    final List<PieChartSectionData> pieSections =
        moodCounts.entries.map((entry) {
      final mood = entry.key;
      final count = entry.value;
      final percentage =
          count / moodCounts.values.reduce((a, b) => a + b) * 100;

      return PieChartSectionData(
        color: _getMoodColor(mood),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: pieSections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
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
                const SizedBox(width: 4),
                Text(mood, style: const TextStyle(fontSize: 20)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper function to get colors for each mood
  Color _getMoodColor(String mood) {
    switch (mood) {
      case "😁":
        return AppColors.pri_purple;
      case "🙂":
        return AppColors.sec_purple;
      case "😐":
        return AppColors.pri_greenYellow;
      case "😞":
        return AppColors.pri_cyan;
      case "😢":
        return AppColors.sec_cyan;
      default:
        return Colors.grey;
    }
  }

  // Helper function to format dates
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
