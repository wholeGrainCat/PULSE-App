import 'package:flutter/material.dart';
import 'package:student/pages/appoinment_screen.dart';

class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({super.key});

  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  String selectedLocation = "";

  final List<String> availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  final List<String> availableLocations = [
    'Counseling Room 1',
    'Counseling Room 2',
    'Counseling Room 3',
    'Counseling Room 4',
  ];

  bool isWeekend = false;

  @override
  Widget build(BuildContext context) {
    // Check if the selected date is a weekend (Saturday or Sunday)
    isWeekend = selectedDate.weekday == 6 || selectedDate.weekday == 7;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appointment Scheduler",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Section
            const SizedBox(height: 20),
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Available Time Slots
            const Text(
              "Available Times",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            if (isWeekend)
              const Text(
                "Weekend is not available. Please choose another date.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Prevent grid scrolling
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns for time slots
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5, // Adjust ratio for button height/width
                ),
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final time = availableTimes[index];
                  final isSelected = selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = isSelected ? "" : time;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.deepPurple : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // Location Selection
            if (selectedTime.isNotEmpty) ...[
              const Text(
                "Select Location",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedLocation.isEmpty ? null : selectedLocation,
                hint: const Text("Select a Counseling Room"),
                onChanged: (String? newLocation) {
                  setState(() {
                    selectedLocation = newLocation ?? '';
                  });
                },
                items: availableLocations
                    .map((location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
              ),
            ],

            // Spacer to push button to bottom
            const Spacer(),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedTime.isEmpty ||
                        selectedLocation.isEmpty ||
                        isWeekend
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Your appointment is on:"),
                            content: Text(
                              "Date: ${selectedDate.toLocal().toString().split(' ')[0]} \nTime: $selectedTime \nLocation: $selectedLocation",
                              style: const TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppointmentScreen(),
                                    ),
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      },
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
