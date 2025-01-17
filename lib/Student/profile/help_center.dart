import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = "";

  Future<List<Map<String, String>>> _fetchQnA() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('qna').get();
      return snapshot.docs.map((doc) {
        return {
          "question": doc["question"] as String,
          "answer": doc["answer"] as String,
        };
      }).toList();
    } catch (e) {
      print("Error fetching Q&A: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Help Center',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Have a burning question? 🔥",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search for topics or questions...",
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black54,
                ),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF00CBC7)), // Cyan icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.pri_cyan, // Border color when focused
                    width: 3.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.pri_cyan, // Border color when enabled
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Q&A Section
            Expanded(
              child: FutureBuilder<List<Map<String, String>>>(
                future: _fetchQnA(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        "Error loading Q&A",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final filteredQnA = snapshot.data
                      ?.where((qna) => qna['question']!
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                  if (filteredQnA == null || filteredQnA.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return ListView(
                    children: filteredQnA
                        .map((qna) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    qna['question']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    qna['answer']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
