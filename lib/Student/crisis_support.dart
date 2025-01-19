import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CrisisSupportPage extends StatefulWidget {
  const CrisisSupportPage({super.key});

  @override
  _CrisisSupportPageState createState() => _CrisisSupportPageState();
}

class _CrisisSupportPageState extends State<CrisisSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Crisis Support',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/studentdashboard');
          },
        ),
        actions: const [], // Removed the notification icon
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

  Future<List<Map<String, dynamic>>> fetchMentalHealthHotlines() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('mentalHealthHotline')
        .get();
    return snapshot.docs
        .map((doc) => {'name': doc['name'], 'number': doc['number']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMentalHealthHotlines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading hotlines.'));
        }

        final hotlines = snapshot.data ?? [];
        if (hotlines.isEmpty) {
          return const Center(
            child: Text('No mental health hotlines available.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mental Health Hotline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...hotlines.map((hotline) {
                return HotlineButton(
                  title: hotline['name'],
                  backgroundColor: const Color(0xFFD9F65C),
                  textColor: Colors.black,
                  phoneNumber: hotline['number'],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class EmergencyHotline extends StatelessWidget {
  const EmergencyHotline({super.key});

  Future<List<Map<String, dynamic>>> fetchEmergencyHotlines() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('emergencyHotline').get();
    return snapshot.docs
        .map((doc) => {'name': doc['name'], 'number': doc['number']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchEmergencyHotlines(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading hotlines.'));
        }

        final hotlines = snapshot.data ?? [];
        if (hotlines.isEmpty) {
          return const Center(
            child: Text('No emergency hotlines available.'),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emergency Contact Hotline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...hotlines.map((hotline) {
                return HotlineButton(
                  title: hotline['name'],
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  phoneNumber: hotline['number'],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class HotlineButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final String phoneNumber;

  const HotlineButton({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.phoneNumber,
    this.textColor = Colors.white,
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
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              phoneNumber,
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
