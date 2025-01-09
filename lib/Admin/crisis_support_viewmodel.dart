import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Admin/crisis_support_repository.dart';

class CrisisSupport extends StatefulWidget {
  const CrisisSupport({super.key});

  @override
  State<CrisisSupport> createState() => _CrisisSupportState();
}

class _CrisisSupportState extends State<CrisisSupport> {
  final CrisisSupportRepository fireStoreService = CrisisSupportRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  int _selectedIndex = 2; // Default selected index (Crisis Support)

  void openNoteBox({String? docID, String? type}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Enter hotline name"),
            ),
            TextField(
              controller: numberController,
              decoration:
                  const InputDecoration(hintText: "Enter hotline number"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                // Add new hotline based on type
                if (type == 'mentalHealth') {
                  fireStoreService.addMentalHealthHotline(
                    nameController.text,
                    numberController.text,
                  );
                } else {
                  fireStoreService.addEmergencyHotline(
                    nameController.text,
                    numberController.text,
                  );
                }
              } else {
                // Update existing hotline
                if (type == 'mentalHealth') {
                  fireStoreService.updateMentalHealthHotline(
                    docID,
                    nameController.text,
                    numberController.text,
                  );
                } else {
                  fireStoreService.updateEmergencyHotline(
                    docID,
                    nameController.text,
                    numberController.text,
                  );
                }
              }
              nameController.clear();
              numberController.clear();
              Navigator.pop(context);
            },
            child: Text(docID == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  // Navigation Bar onTap logic
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Thumbnail(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Mental Health Hotline',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MentalHealthHotline(
              fireStoreService: fireStoreService,
              onEdit: (docID) =>
                  openNoteBox(docID: docID, type: 'mentalHealth'),
              onDelete: (docID) =>
                  fireStoreService.deleteMentalHealthHotline(docID),
              onAdd: () => openNoteBox(type: 'mentalHealth'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Emergency Hotline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            EmergencyHotline(
              fireStoreService: fireStoreService,
              onEdit: (docID) => openNoteBox(docID: docID, type: 'emergency'),
              onDelete: (docID) =>
                  fireStoreService.deleteEmergencyHotline(docID),
              onAdd: () => openNoteBox(type: 'emergency'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_rounded),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_rounded),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF613CEA),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFA4E3E8),
          borderRadius: BorderRadius.circular(10),
        ),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/suicidal_feeling.png', // Ensure the file exists
                width: 60,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MentalHealthHotline extends StatelessWidget {
  final CrisisSupportRepository fireStoreService;
  final Function(String docID)? onEdit;
  final Function(String docID)? onDelete;
  final Function()? onAdd;

  const MentalHealthHotline({
    super.key,
    required this.fireStoreService,
    this.onEdit,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStoreService.getMentalHealthHotlineStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List noteList = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: noteList.length + 1,
            itemBuilder: (context, index) {
              if (index == noteList.length) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: ListTile(
                        tileColor: const Color(0xFFD9F65C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 13,
                        ),
                        trailing: const Icon(Icons.add_circle_outline,
                            color: Colors.black),
                        onTap: onAdd,
                      ),
                    ),
                  ],
                );
              }

              DocumentSnapshot document = noteList[index];
              String docID = document.id;
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // Safely access fields and use default values if null
              String name = data['name'] ?? 'Unknown Name'; // Default value
              String number =
                  data['number'] ?? 'No Number Available'; // Default value

              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: ListTile(
                      tileColor: const Color(0xFFD9F65C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      title: Text(name, textAlign: TextAlign.center),
                      subtitle: Text(
                        number, // Display hotline number in subtitle
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => onEdit?.call(docID),
                            icon: const Icon(Icons.edit, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => onDelete?.call(docID),
                            icon: const Icon(Icons.delete, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        } else {
          return const Text("No mental health hotline available. Create Now!");
        }
      },
    );
  }
}

class EmergencyHotline extends StatelessWidget {
  final CrisisSupportRepository fireStoreService;
  final Function(String docID)? onEdit;
  final Function(String docID)? onDelete;
  final Function()? onAdd;

  const EmergencyHotline({
    super.key,
    required this.fireStoreService,
    this.onEdit,
    this.onDelete,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: fireStoreService.getEmergencyHotlineStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List noteList = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: noteList.length + 1,
            itemBuilder: (context, index) {
              if (index == noteList.length) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: ListTile(
                        tileColor: const Color(0xFFD9F65C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 13,
                        ),
                        trailing: const Icon(Icons.add_circle_outline,
                            color: Colors.black),
                        onTap: onAdd,
                      ),
                    ),
                  ],
                );
              }

              DocumentSnapshot document = noteList[index];
              String docID = document.id;
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String name = data['name'] ?? 'Unknown Name';
              String number = data['number'] ?? 'No Number Available';

              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: ListTile(
                      tileColor: const Color(0xFFD9F65C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      title: Text(name, textAlign: TextAlign.center),
                      subtitle: Text(
                        number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => onEdit?.call(docID),
                            icon: const Icon(Icons.edit, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => onDelete?.call(docID),
                            icon: const Icon(Icons.delete, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          );
        } else {
          return const Text("No emergency hotline available. Create Now!");
        }
      },
    );
  }
}
