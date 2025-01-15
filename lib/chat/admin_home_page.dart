import 'package:student/chat/chat_page.dart';
import 'package:student/chat/edit_counsellors_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student/components/admin_bottom_navigation.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool showUnread = true;
  int _currentIndex = 3;

  final String currentAdminId = FirebaseAuth.instance.currentUser?.uid ??
      ''; // Get the logged-in admin's ID

  void _confirmResolve(BuildContext context, String chatRoomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Chat'),
        content:
            const Text('Are you sure you want to mark this chat as resolved?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _resolveChat(chatRoomId);
              Navigator.of(context).pop();
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String chatRoomId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text(
            'This action will delete chat for all users. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteChat(chatRoomId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _resolveChat(String chatRoomId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .update({'isResolved': true});
  }

  void _deleteChat(String chatRoomId) async {
    final chatDoc =
        FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

    // Delete all messages in the `messages` sub-collection
    final messages = await chatDoc.collection('messages').get();
    for (var message in messages.docs) {
      await message.reference.delete();
    }

    // Delete the parent chat document
    await chatDoc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Peer Support',
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
        body: Column(
          children: [
            // Toggle Buttons: Unread and Resolved
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: showUnread
                            ? const Color.fromRGBO(97, 62, 234, 1.0)
                            : const Color.fromRGBO(97, 62, 234, 0.5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          showUnread = true;
                        });
                      },
                      child: const Text('Unread', textAlign: TextAlign.center),
                    ),
                  ),
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: !showUnread
                            ? const Color.fromRGBO(97, 62, 234, 1.0)
                            : const Color.fromRGBO(97, 62, 234, 0.5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                      ),
                      onPressed: () {
                        setState(() {
                          showUnread = false;
                        });
                      },
                      child:
                          const Text('Resolved', textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),

            // Edit Counsellors Information Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 203, 199, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditCounsellorsPage()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Counsellors Information',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      FaIcon(
                        FontAwesomeIcons.penToSquare,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Chat List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('participants', arrayContains: currentAdminId)
                    .snapshots(), // Filter chats where admin is a participant
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching chats'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No chats available'));
                  }

                  // Filter chats based on isResolved
                  final chats = snapshot.data!.docs
                      .where(
                          (doc) => (doc['isResolved'] ?? false) != showUnread)
                      .toList();

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final chatRoomId = chat.id;

                      // Extract the student's ID (not the admin's ID)
                      final participants =
                          chat['participants'] as List<dynamic>;
                      final studentId = participants.firstWhere(
                        (id) => id != currentAdminId,
                        orElse: () => null,
                      );

                      final lastMessage =
                          chat['lastMessage'] ?? 'No messages yet';

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(studentId)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return const ListTile();
                          }

                          if (!userSnapshot.hasData ||
                              !userSnapshot.data!.exists) {
                            return const SizedBox
                                .shrink(); // Skip this chat if the user doesn't exist
                          }

                          // Fetch the email field
                          final studentEmail =
                              userSnapshot.data!['email'] ?? 'Unknown Email';

                          // Fetch the unread messages count
                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('chats')
                                .doc(chatRoomId)
                                .collection('messages')
                                .where('isRead', isEqualTo: false)
                                .get(),
                            builder: (context, messagesSnapshot) {
                              if (messagesSnapshot.hasData) {}

                              return Dismissible(
                                key: Key(chatRoomId),
                                background: Container(
                                  color: Colors.green,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(Icons.check,
                                      color: Colors.white),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _confirmResolve(context, chatRoomId);
                                    return false; // Prevent auto-dismiss
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    _confirmDelete(context, chatRoomId);
                                    return false; // Prevent auto-dismiss
                                  }
                                  return false;
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey[300],
                                    child: Text(
                                      studentEmail[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  title: Text(
                                    studentEmail,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    lastMessage,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(chatRoomId)
                                        .collection('messages')
                                        .orderBy('timestamp',
                                            descending:
                                                true) // Fetch the latest message
                                        .limit(1)
                                        .get(),
                                    builder: (context, messagesSnapshot) {
                                      if (messagesSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Icon(
                                          Icons.done_all,
                                          color: Colors
                                              .grey, // Placeholder while loading
                                          size: 20,
                                        );
                                      }

                                      if (messagesSnapshot.hasError) {
                                        print(
                                            "Error fetching messages: ${messagesSnapshot.error}");
                                        return const Icon(
                                          Icons.error,
                                          color: Colors
                                              .red, // Display red icon on error
                                          size: 20,
                                        );
                                      }

                                      if (messagesSnapshot.hasData &&
                                          messagesSnapshot
                                              .data!.docs.isNotEmpty) {
                                        final latestMessage =
                                            messagesSnapshot.data!.docs.first;
                                        final isRead =
                                            latestMessage['isRead'] ?? false;

                                        return Icon(
                                          Icons.done_all,
                                          color: isRead
                                              ? Colors.blue
                                              : Colors.grey,
                                          size: 20,
                                        );
                                      }

                                      return const Icon(
                                        Icons.done_all,
                                        color: Colors
                                            .grey, // Default to grey if no messages
                                        size: 20,
                                      );
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          chat: {'email': studentEmail},
                                          senderId: currentAdminId,
                                          receiverId: studentId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: AdminBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate based on the tab index
            switch (index) {
              case 0:
                // Navigate to Resources page
                Navigator.pushNamed(context, '/adminresource');
                break;
              case 1:
                // Navigate to Appointment page
                Navigator.pushNamed(context, '/adminappointment');
                break;
              case 2:
                // Navigate to Chat page
                Navigator.pushNamed(
                    context, '/admindashboard'); // Use named route for chat
                break;
              case 3:
                // Navigate to Profile page
                Navigator.pushNamed(context, '/adminchat');
                break;
              case 4:
                // Navigate to Profile page
                Navigator.pushNamed(context, '/adminprofile');
                break;
              default:
                break;
            }
          },
        ));
  }
}
