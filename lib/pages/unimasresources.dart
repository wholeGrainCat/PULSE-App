import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counsellor Info',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounsellorInfoScreen(),
    );
  }
}

class CounsellorInfoScreen extends StatelessWidget {
  const CounsellorInfoScreen({super.key});

  // Fetch counsellor data from Firestore
  Future<List<Map<String, dynamic>>> _fetchCounsellorData() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('counsellors_info').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psycon Counsellor'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCounsellorData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No counsellors available'));
          }

          final counsellors = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUnitInfo(),
                  const SizedBox(height: 32.0),
                  ...counsellors.map((counsellor) => _CounsellorCard(
                        imageUrl: counsellor['imageUrl'],
                        name: counsellor['name'],
                        phone: counsellor['phone'],
                        email: counsellor['email'],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitInfo() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color(0xFFD9F65C),
            ),
            padding: const EdgeInsets.all(24.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Psychology & Counseling Unit',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  'Operating Hours:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '''
Monday to Thursday:
8.30 am - 12.30 pm | 2.00 pm - 4.30 pm

Friday:
8.30 am - 11.30 pm | 2.30 pm - 4.30 pm
                  ''',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CounsellorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String phone;
  final String email;

  const _CounsellorCard({
    required this.imageUrl,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 36.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16.0, color: Colors.green),
                      const SizedBox(width: 8.0),
                      Text(
                        phone,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16.0, color: Colors.blue),
                      const SizedBox(width: 8.0),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
