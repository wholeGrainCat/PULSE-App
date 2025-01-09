import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditCounsellorsPage extends StatefulWidget {
  const EditCounsellorsPage({super.key});

  @override
  State<EditCounsellorsPage> createState() => _CounsellorsPageState();
}

class _CounsellorsPageState extends State<EditCounsellorsPage> {
  // Controllers for text input fields
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Function to add new counsellor to Firebase
  Future<void> addCounsellor() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if the counsellor information already exists
      DocumentSnapshot counsellorDoc = await firestore
          .collection('Users')
          .doc(userId)
          .collection('counsellors')
          .doc(
              userId) // Use the user's uid to store counsellor info under a unique ID
          .get();

      if (!counsellorDoc.exists) {
        // If no counsellor information exists, add it
        await firestore
            .collection('Users')
            .doc(userId)
            .collection('counsellors')
            .doc(
                userId) // Ensure that each user can only add one counsellor document
            .set({
          'image': _imageController.text,
          'name': _nameController.text,
          'description': _descriptionController.text,
        });

        // Clear the input fields after adding
        _imageController.clear();
        _nameController.clear();
        _descriptionController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New counsellor added successfully!')),
        );
      } else {
        // Show a message if counsellor information already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('You have already added your counsellor information.')),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add counsellor.')),
      );
    }
  }

  // Function to fetch and display counsellors from Firestore
  Future<List<Map<String, String>>> fetchCounsellors() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch all counsellors for the current user
    QuerySnapshot querySnapshot = await firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('counsellors')
        .get();

    List<Map<String, String>> counsellors = [];
    for (var doc in querySnapshot.docs) {
      counsellors.add({
        'id': doc.id,
        'image': doc['image'],
        'name': doc['name'],
        'description': doc['description'],
      });
    }
    return counsellors;
  }

  // Function to show the edit form
  void showEditDialog(String counsellorId, String currentImage,
      String currentName, String currentDescription) {
    _imageController.text = currentImage;
    _nameController.text = currentName;
    _descriptionController.text = currentDescription;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Counsellor Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Image URL input field
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                  ),
                ),
                // Name input field
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                // Description input field
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  // Update counsellor information in Firestore
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('counsellors')
                      .doc(counsellorId)
                      .update({
                    'image': _imageController.text,
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Counsellor information updated!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to update counsellor.')),
                  );
                } finally {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            // Display existing counsellors
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('counsellors')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return const Text('Error fetching counsellors');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('You have not add any information.');
                }

                // Map documents to a list of widgets
                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    Map<String, dynamic> counsellor =
                        doc.data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  counsellor['name']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  counsellor['description']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    showEditDialog(
                                      doc.id, // Use the document ID as counsellorId
                                      counsellor['image']!,
                                      counsellor['name']!,
                                      counsellor['description']!,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new counsellor
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add New Counsellor'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Image URL input field
                      TextField(
                        controller: _imageController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                      ),
                      // Name input field
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      // Description input field
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addCounsellor();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
