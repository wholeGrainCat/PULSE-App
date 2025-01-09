import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostChatPage extends StatefulWidget {
  final String postId;

  const PostChatPage({super.key, required this.postId});

  @override
  State<PostChatPage> createState() => _PostChatPageState();
}

class _PostChatPageState extends State<PostChatPage> {
  final TextEditingController _replyController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final ScrollController _scrollController = ScrollController();

  void _sendReply() async {
    if (_replyController.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('anonymousPosts')
          .doc(widget.postId)
          .collection('replies')
          .add({
        'message': _replyController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': currentUserId,
      });

      _replyController.clear();

      // Scroll to bottom after sending a message
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Anynomous Post',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section: Show Post Title/Message
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('anonymousPosts')
                .doc(widget.postId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  !snapshot.data!.exists) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text('Error loading post')),
                );
              }

              final post = snapshot.data!;
              final postContent = post['content'] ?? 'No content available';

              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  postContent,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),

          // Chat Section: Show Replies
          Expanded(
            child: Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('anonymousPosts')
                    .doc(widget.postId)
                    .collection('replies')
                    .orderBy('timestamp',
                        descending: true) // Sort messages in descending order
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading replies'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No replies yet. Be the first to reply!'));
                  }

                  final replies = snapshot.data!.docs;

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true, // Start the messages from the bottom
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final reply = replies[index];
                      final message = reply['message'] ?? '';
                      final isCurrentUser = reply['senderId'] == currentUserId;

                      return Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width *
                                0.60, // 75% of screen width
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? const Color.fromRGBO(0, 203, 199,
                                    0.5) // Bubble color for current user
                                : const Color.fromRGBO(217, 246, 92,
                                    0.5), // Bubble color for others
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Bottom Section: Input for Reply
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(30), // Rounded corners for the field
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Subtle shadow effect
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 1), // Position of the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller:
                          _replyController, // Use the existing _replyController
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none, // No border for a clean look
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.paperPlane,
                        color: Color.fromRGBO(0, 203, 199, 1.0)),
                    onPressed: _sendReply, // Use the existing _sendReply method
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
