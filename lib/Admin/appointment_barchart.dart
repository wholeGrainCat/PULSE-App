import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AppointmentBarChart extends StatefulWidget {
  const AppointmentBarChart({super.key});

  @override
  _AppointmentBarChartState createState() => _AppointmentBarChartState();
}

class _AppointmentBarChartState extends State<AppointmentBarChart> {
  String period = "This Week"; // Default period is This Week

  // Example data for different periods
  List<List<BarChartGroupData>> periodData = [
    // This Week Data
    [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 5, color: const Color(0xFF613EEA))],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 7, color: const Color(0xFF613EEA))],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 9, color: const Color(0xFF613EEA))],
      ),
    ],

    // This Month Data
    [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 12, color: const Color(0xFF00CBC7))],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 15, color: const Color(0xFF00CBC7))],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 18, color: const Color(0xFF00CBC7))],
      ),
    ],
  ];

  // Function to navigate between "This Week" and "This Month"
  void _navigatePeriod(int direction) {
    setState(() {
      if (direction == -1 && period == "This Month") {
        period = "This Week";
      } else if (direction == 1 && period == "This Week") {
        period = "This Month";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int periodIndex = (period == "This Week") ? 0 : 1;

    return Column(
      children: [
        // Navigation buttons with period label
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: period == "This Week"
                    ? const Color(0xFFAF96F5)
                    : const Color(0xFF613EEA),
              ),
              onPressed:
                  period == "This Week" ? null : () => _navigatePeriod(-1),
            ),
            Text(
              period,
            ),
            IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: period == "This Month"
                    ? const Color(0xFFAF96F5)
                    : const Color(0xFF613EEA),
              ),
              onPressed:
                  period == "This Month" ? null : () => _navigatePeriod(1),
            ),
          ],
        ),
        // Bar chart
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                      reservedSize: 25,
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(
                  show: false,
                ),
                borderData: FlBorderData(show: true),
                barGroups: periodData[periodIndex],
              ),
              duration: const Duration(milliseconds: 500),
            ),
          ),
        ),
      ],
    );
  }
}
