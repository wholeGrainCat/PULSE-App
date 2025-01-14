import 'package:flutter/material.dart';
import 'package:student/Admin/counselling_appointment/appointment_page.dart';
import 'admin_profile_page.dart';
import '../counselling_appointment/counsellor_page.dart';
import '../self-help_tools/selfhelp_tools.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  // ignore: override_on_non_overriding_member
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminProfilePage()),
                );
              },
              child: const Text('Admin Profile Page'),
            ),
            const SizedBox(height: 20), // Spacer between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminAppointmentPage()),
                );
              },
              child: const Text('Appointment'),
            ),
            const SizedBox(height: 20), // Spacer between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminCounsellorPage()),
                );
              },
              child: const Text('Counsellor Info'),
            ),
            const SizedBox(height: 20), // Spacer between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelfhelpToolsPage()),
                );
              },
              child: const Text('Self-Help Tools'),
            ),
          ],
        ),
      ),
    );
  }
}
