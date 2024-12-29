import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:student/pages/resource_library.dart';
import 'package:student/pages/mood_tracker.dart';
import 'package:student/pages/student_dashboard.dart';
import 'package:student/pages/profile/profile_screen.dart';

void main() {
  runApp(const CrisisSupport());
}

class CrisisSupport extends StatelessWidget {
  const CrisisSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CrisisSupportPage(),
      routes: {
        '/resource': (context) => const ResourceLibraryPage(),
        '/moodtracker': (context) => const MoodTrackerPage(),
        '/studentdashboard': (context) => const StudentDashboard(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class CrisisSupportPage extends StatefulWidget {
  const CrisisSupportPage({super.key});

  @override
  _CrisisSupportPageState createState() => _CrisisSupportPageState();
}

class _CrisisSupportPageState extends State<CrisisSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/studentdashboard');
          },
        ),
        actions: [], // Removed the notification icon
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFA4E3E8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Enable horizontal scrolling
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Are You Feeling Suicidal?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          width: 16), // Added spacing between text and image
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          'assets/images/suicidal_feeling.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const MentalHealthHotline(),
            const EmergencyHotline(),
          ],
        ),
      ),
    );
  }
}

class MentalHealthHotline extends StatelessWidget {
  const MentalHealthHotline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mental Health Hotline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          HotlineButton(
            title: 'Befrienders 082-242800',
            icon: Icons.phone,
            iconColor: Colors.black,
            backgroundColor: Color(0xFFD9F65C),
            textColor: Colors.black,
            phoneNumber: '082242800',
          ),
        ],
      ),
    );
  }
}

class EmergencyHotline extends StatelessWidget {
  const EmergencyHotline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contact Hotline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          HotlineButton(
            title: 'Polis Bantuan UNIMAS +6017-212 7464',
            icon: Icons.local_police,
            backgroundColor: Colors.red,
            phoneNumber: '+60172127464',
          ),
          HotlineButton(
            title: 'Rescue 991',
            icon: Icons.fire_truck,
            backgroundColor: Colors.red,
            phoneNumber: '991',
          ),
          HotlineButton(
            title: 'Hotline 082-244444',
            icon: Icons.support_agent,
            backgroundColor: Colors.red,
            phoneNumber: '082244444',
          ),
          HotlineButton(
            title: '082-230689',
            icon: Icons.local_hospital,
            backgroundColor: Colors.red,
            phoneNumber: '082230689',
          ),
        ],
      ),
    );
  }
}

class HotlineButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final String phoneNumber;

  const HotlineButton({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.phoneNumber,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          // Call the phone number asynchronously
          // await FlutterPhoneDirectCaller.callNumber(phoneNumber);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
