import 'package:student/chat/chat_page.dart';
import 'package:student/chat/post_chat_page.dart';
import 'package:student/chat/student_view_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/components/bottom_navigation.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  bool showUnread = true;
  bool showCounsellorButton = false;
  bool showAnonymousPost = false;
  int _currentIndex = 3;

  final String currentStudentId =
      FirebaseAuth.instance.currentUser?.uid ?? ''; // Current student ID

  TextEditingController anonymousMessageController = TextEditingController();
  TextEditingController userMessageController = TextEditingController();

  void navigateTo(String page) {
    print("Navigating to $page");
    // Handle other navigation cases
    if (page == 'Resource') {
      Navigator.pushNamed(context, '/resource');
    } else if (page == 'Dashboard') {
      Navigator.pushNamed(context, '/studentdashboard');
    } else if (page == 'Chat') {
      Navigator.pushNamed(context, '/chat');
    } else if (page == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> checkMoodStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Retrieve the last logged date and mood status
      String? lastLoggedDate = prefs.getString('lastLoggedDate_$userId');
      DateTime today = DateTime.now();
      String todayString = "${today.year}-${today.month}-${today.day}";

      // Check if the last logged date matches today's date
      bool hasLoggedMood = (lastLoggedDate == todayString);
      print("User ID: $userId");
      print("Last Logged Date: $lastLoggedDate");
      print("Has logged mood today: $hasLoggedMood");

      if (hasLoggedMood) {
        // Navigate to the mood done page (only once)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/mooddonecheckin');
        });
      } else {
        // Navigate to the mood tracker page if not logged
        Navigator.pushReplacementNamed(context, '/moodtracker');
      }
    }
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

  void _deleteChat(String chatRoomId) async {
    final chatDoc =
        FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

    try {
      // Only delete the current user's messages
      final messages = await chatDoc
          .collection('messages')
          .where('senderId', isEqualTo: currentStudentId)
          .get();
      for (var message in messages.docs) {
        await message.reference.delete();
      }

      // Check if the chat still has messages; if not, delete the chat document
      final remainingMessages = await chatDoc.collection('messages').get();
      if (remainingMessages.docs.isEmpty) {
        await chatDoc.delete();
      }
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }

  void _submitAnonymousPost() async {
    if (anonymousMessageController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('anonymousPosts').add({
        'content': anonymousMessageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'authorId': currentStudentId,
      });
      anonymousMessageController
          .clear(); // Clear the input field after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Peer Support',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              navigateTo('Resource');
              break;
            case 1:
              checkMoodStatus();
              break;
            case 2:
              navigateTo('Dashboard');
              break;
            case 3:
              navigateTo('Chat');
              break;
            case 4:
              navigateTo('Profile');
              break;
          }
        },
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: showUnread
                          ? const Color.fromRGBO(97, 62, 234, 1.0)
                          : const Color.fromRGBO(97, 62, 234, 0.5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                    ),
                    onPressed: () {
                      setState(() {
                        showUnread = true;
                        showCounsellorButton = false;
                        showAnonymousPost = false;
                      });
                    },
                    child: const Text('Anonymous Post',
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                      backgroundColor: !showUnread
                          ? const Color.fromRGBO(97, 62, 234, 1.0)
                          : const Color.fromRGBO(97, 62, 234, 0.5),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 50),
                    ),
                    onPressed: () {
                      setState(() {
                        showUnread = false;
                        showCounsellorButton = true;
                      });
                    },
                    child: const Text('Personal Message',
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
            ],
          ),
          if (showUnread && !showCounsellorButton)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Anonymous Post Input
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "What's on your mind?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: anonymousMessageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 203, 199,
                                        1.0)), // Default border color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 203, 199,
                                        1.0)), // Same border color when enabled
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(0, 203, 199,
                                        1.0)), // No color change when focused
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              onPressed: _submitAnonymousPost,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(0, 203, 199, 50),
                                  foregroundColor: Colors.white),
                              child: const Text(
                                'Post',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Anonymous Posts List
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('anonymousPosts')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error fetching posts'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No posts available'));
                          }

                          final posts = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              final content = post['content'] ?? '';
                              final authorId = post['authorId'] ?? 'Anonymous';

                              return Card(
                                color: const Color.fromRGBO(164, 227, 232, 1.0),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    content,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    'Posted by ${authorId == currentStudentId ? "You" : "Anonymous"}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostChatPage(postId: post.id),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showCounsellorButton)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 203, 199, 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StudentViewInfo()),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Counsellor Information',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      FaIcon(
                        FontAwesomeIcons.commentMedical,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (!showUnread)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .where('participants', arrayContains: currentStudentId)
                    .snapshots(),
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

                  final chats = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final chatRoomId = chat.id;
                      final lastMessage =
                          chat['lastMessage'] ?? 'No messages yet';
                      final participants =
                          chat['participants'] as List<dynamic>;

                      // Get the receiver (not the current student)
                      final receiverId = participants.firstWhere(
                        (id) => id != currentStudentId,
                        orElse: () => null,
                      );

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(receiverId)
                            .collection('counsellors')
                            .doc('profile')
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

                          final receiverName =
                              userSnapshot.data!['name'] ?? 'Unknown';

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
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _confirmDelete(context, chatRoomId);
                                    return false;
                                  }
                                  return false;
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey[300],
                                    child: Text(
                                      receiverName[0].toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  title: Text(
                                    receiverName,
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
                                          chat: {'name': receiverName},
                                          senderId: currentStudentId,
                                          receiverId: receiverId,
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
    );
  }
}
