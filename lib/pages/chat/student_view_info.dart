import 'package:student/pages/chat/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentViewInfo extends StatefulWidget {
  const StudentViewInfo({super.key});

  @override
  State<StudentViewInfo> createState() => _StudentViewInfoState();
}

class _StudentViewInfoState extends State<StudentViewInfo> {
  // Fetch counsellors information from Firestore
  Future<List<Map<String, String>>> fetchCounsellors() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot usersSnapshot = await firestore.collection('Users').get();
      List<Map<String, String>> counsellors = [];

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot counsellorsSnapshot =
            await userDoc.reference.collection('counsellors').get();

        for (var counsellorDoc in counsellorsSnapshot.docs) {
          var data = counsellorDoc.data() as Map<String, dynamic>;
          counsellors.add({
            'userId': userDoc.id,
            'id': counsellorDoc.id,
            'image': data['image'] ?? 'https://via.placeholder.com/150',
            'name': data['name'] ?? 'No Name',
            'description': data['description'] ?? 'No Description',
          });
        }
      }
      return counsellors;
    } catch (e) {
      print("Error fetching counsellors: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Counsellor Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchCounsellors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching counsellors'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No counsellors found.'));
          }

          // Get the counsellors data
          List<Map<String, String>> counsellors = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: counsellors.map((counsellor) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Counsellor image
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            counsellor['image']!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Counsellor name and description
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              counsellor['name']!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              counsellor['description']!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // Actions: View Info and Chat
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 20, left: 20, bottom: 20),
                        child: Row(
                          children: [
                            // View Information Button
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  minimumSize: const Size(double.infinity, 60),
                                ),
                                onPressed: () {
                                  // Handle viewing counsellor info
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Counsellor Info"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name: ${counsellor['name']}",
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Description: ${counsellor['description']}",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Close"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "View Information",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Chat Button
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 203, 199, 100),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  minimumSize: const Size(double.infinity, 60),
                                ),
                                onPressed: () async {
                                  // Get the current user's ID (senderId)
                                  String senderId =
                                      FirebaseAuth.instance.currentUser?.uid ??
                                          ''; // Get the logged-in user's ID

                                  // Get the receiverId (counselor's ID) from the counsellor data
                                  String receiverId = counsellor[
                                      'id']!; // Assuming 'id' is the counselor's unique ID from the data

                                  if (senderId.isNotEmpty &&
                                      receiverId.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          chat: {
                                            "name": counsellor['name']!,
                                          }, // Passing counselor's name
                                          senderId: senderId,
                                          receiverId: receiverId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Handle case when IDs are not available
                                    print(
                                        'Error: Sender or receiver ID is missing');
                                  }
                                },
                                child: const Text(
                                  "Chat",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
