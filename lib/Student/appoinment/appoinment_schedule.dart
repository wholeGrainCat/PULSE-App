import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/Student/appoinment/appoinment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleAppointment extends StatefulWidget {
  final String documentId; // Add documentId as a parameter

  const ScheduleAppointment({super.key, required this.documentId});

  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = "";
  String selectedLocation = "";
  String selectedCounsellor = "";
  bool isLoading = false;

  final List<String> availableLocations = [
    'Counseling Room 1',
    'Counseling Room 2',
    'Counseling Room 3',
    'Counseling Room 4',
  ];

  final List<String> counsellors = [
    'Madam Fauziah Bee binti Mohd Salleh',
    'Madam Saptuyah binti Barahim',
    'Madam Debra Adrian',
    'Encik Lawrence Sengkuai Anak Henry',
    'Miss Ummikhairah Sofea binti Jaafar'
  ];

  final List<String> allAvailableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM'
  ];

  List<String> availableTimes = [];
  List<String> bookedTimes = [];
  List<String> bookedLocations = [];

  bool isWeekend = false;

  @override
  void initState() {
    super.initState();
    availableTimes = List<String>.from(allAvailableTimes);
  }

  // Load both booked times and locations from Firebase
  Future<void> _loadBookedTimesAndLocations() async {
    try {
      String formattedDate = selectedDate.toLocal().toString().split(' ')[0];

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentDate', isEqualTo: formattedDate)
          .where('time', isEqualTo: selectedTime)
          .get();

      if (mounted) {
        setState(() {
          bookedLocations = snapshot.docs.isEmpty
              ? []
              : snapshot.docs.map((doc) => doc['location'] as String).toList();
        });

        QuerySnapshot timeSnapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .where('appointmentDate', isEqualTo: formattedDate)
            .where('counsellor', isEqualTo: selectedCounsellor)
            .get();

        if (mounted) {
          setState(() {
            bookedTimes = timeSnapshot.docs.isEmpty
                ? []
                : timeSnapshot.docs
                    .map((doc) => doc['time'] as String)
                    .toList();
          });
        }
      }
    } catch (e) {
      print("Error loading booked data: $e");
    }
  }

  // Check if a location is available
  bool isLocationAvailable(String location) {
    return !bookedLocations.contains(location);
  }

  // Save appointment data to Firebase with availability check
  Future<bool> _checkAvailability() async {
    try {
      String formattedDate = selectedDate.toLocal().toString().split(' ')[0];

      // Check counsellor availability
      QuerySnapshot counsellorCheck = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentDate', isEqualTo: formattedDate)
          .where('time', isEqualTo: selectedTime)
          .where('counsellor', isEqualTo: selectedCounsellor)
          .get();

      if (counsellorCheck.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Counsellor is not available at this time')),
        );
        return false;
      }

      // Check location availability
      QuerySnapshot locationCheck = await FirebaseFirestore.instance
          .collection('appointments')
          .where('appointmentDate', isEqualTo: formattedDate)
          .where('time', isEqualTo: selectedTime)
          .where('location', isEqualTo: selectedLocation)
          .get();

      if (locationCheck.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location is already booked for this time')),
        );
        return false;
      }

      return true;
    } catch (e) {
      print("Error checking availability: $e");
      return false;
    }
  }

  Future<void> _saveAppointment() async {
    if (selectedCounsellor.isEmpty ||
        selectedTime.isEmpty ||
        selectedLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // First check availability
      bool isAvailable = await _checkAvailability();
      if (!isAvailable) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // If available, proceed with saving
      String formattedDate = selectedDate.toLocal().toString().split(' ')[0];

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.documentId)
          .update({
        'appointmentDate': formattedDate,
        'time': selectedTime,
        'location': selectedLocation,
        'counsellor': selectedCounsellor,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'status': 'Pending', // Adding a status field
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment Scheduled successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AppointmentScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to schedule appointment: ${e.toString()}')),
        );
      }
      print("Error saving appointment: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appointment Scheduler",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Counsellor Selection
            const SizedBox(height: 20),
            const Text(
              "Select Counsellor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCounsellor.isEmpty ? null : selectedCounsellor,
              hint: const Text("Select a Counsellor"),
              onChanged: (String? newCounsellor) {
                setState(() {
                  selectedCounsellor = newCounsellor ?? '';
                  _loadBookedTimesAndLocations(); // Load available times when counsellor changes
                });
              },
              items: counsellors
                  .map((counsellor) => DropdownMenuItem<String>(
                        value: counsellor,
                        child: Text(counsellor),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Calendar Section
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
                    // Check if the selected date is a weekend
                    isWeekend = selectedDate.weekday == DateTime.saturday ||
                        selectedDate.weekday == DateTime.sunday;
                    // Reload booked times when date changes
                    _loadBookedTimesAndLocations();
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Show message if weekend is selected
            if (isWeekend) ...[
              const Text(
                "Appointments are not available on weekends.",
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Available Time Slots
              const Text(
                "Available Times",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: availableTimes.length,
                itemBuilder: (context, index) {
                  final time = availableTimes[index];
                  final isSelected = selectedTime == time;
                  final isBooked = bookedTimes
                      .contains(time); // Check if the time is already booked

                  return GestureDetector(
                    onTap: isBooked
                        ? null // Disable tap if booked
                        : () {
                            setState(() {
                              selectedTime = isSelected ? "" : time;
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.grey // Gray out booked times
                            : isSelected
                                ? Colors.deepPurple
                                : Colors.grey[200],
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
                          color: isBooked
                              ? Colors
                                  .black54 // Make booked time text less visible
                              : isSelected
                                  ? Colors.white
                                  : Colors.black87,
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                FutureBuilder(
                  future: _loadBookedTimesAndLocations(),
                  builder: (context, snapshot) {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: selectedLocation.isEmpty ? null : selectedLocation,
                      hint: const Text("Select Location"),
                      onChanged: (String? newLocation) {
                        if (newLocation != null &&
                            !bookedLocations.contains(newLocation)) {
                          setState(() {
                            selectedLocation = newLocation;
                          });
                        }
                      },
                      items: availableLocations.map((location) {
                        bool isBooked = bookedLocations.contains(location);
                        return DropdownMenuItem<String>(
                          value: location,
                          enabled: !isBooked,
                          child: Text(
                            location + (isBooked ? " (Booked)" : ""),
                            style: TextStyle(
                              color: isBooked ? Colors.grey : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),

              /// Book Appointment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : selectedCounsellor.isEmpty ||
                              selectedTime.isEmpty ||
                              selectedLocation.isEmpty
                          ? null // Disable button if fields are empty
                          : _saveAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF6200EA), // Updated to specific purple
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Book Appointment',
                          style: TextStyle(
                            color: Colors.white, // Explicit text color
                            fontSize: 18, // Font size as per request
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
