import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  final Map<String, String> chat; // Chat metadata (e.g., name)
  final String senderId;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.chat,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;

  String getChatRoomId() {
    return widget.senderId.hashCode <= widget.receiverId.hashCode
        ? '${widget.senderId}_${widget.receiverId}'
        : '${widget.receiverId}_${widget.senderId}';
  }

  void markMessagesAsRead(String chatRoomId, String currentUserId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('receiverId',
            isEqualTo:
                currentUserId) // Only mark messages sent to the current user
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Mark messages as read only for the current user
    final chatRoomId = getChatRoomId();
    markMessagesAsRead(
        chatRoomId, widget.senderId); // Only mark messages for sender
  }

  void _updateTypingStatus(bool isTyping) {
    final chatRoomId = getChatRoomId();

    FirebaseFirestore.instance.collection('chats').doc(chatRoomId).update({
      'typing.${widget.senderId}': isTyping,
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final message = {
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
        'message': _controller.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      };

      final chatRoomId = getChatRoomId();

      // Add the message to the messages sub-collection
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message);

      // Update the parent chat document with the latest message
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set(
        {
          'participants': [widget.senderId, widget.receiverId],
          'lastMessage': _controller.text,
          'lastTimestamp': FieldValue.serverTimestamp(),
          'isResolved': false,
          'name': widget.chat['name'] ?? 'Unknown User', // Handle null name
        },
        SetOptions(merge: true),
      );

      _controller.clear();
      _scrollToBottom();
      _updateTypingStatus(false); // Reset typing status
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    _updateTypingStatus(false); // Reset typing status when leaving the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Peer Support', // Fallback for null name
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
          // Header with name and status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(97, 62, 234, 1.0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      widget.chat['name']?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chat['name'] ?? 'Unknown User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .doc(getChatRoomId())
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Text(
                              'Hello',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            );
                          }

                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          final typing =
                              data['typing'] as Map<String, dynamic>?;

                          final isReceiverTyping =
                              typing?[widget.receiverId] ?? false;

                          return Text(
                            isReceiverTyping ? 'Typing...' : '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Chat messages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(getChatRoomId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isSentByUser = message['senderId'] == widget.senderId;

                    return Align(
                      alignment: isSentByUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.60, // 75% of screen width
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isSentByUser
                              ? const Color.fromRGBO(0, 203, 199, 0.5)
                              : const Color.fromRGBO(217, 246, 92, 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message['message'] ?? '',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        if (_typingTimer != null) {
                          _typingTimer!.cancel();
                        }

                        _updateTypingStatus(value.isNotEmpty);

                        if (value.isNotEmpty) {
                          _typingTimer = Timer(const Duration(seconds: 2), () {
                            _updateTypingStatus(false);
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.paperPlane,
                        color: Color.fromRGBO(0, 203, 199, 1.0)),
                    onPressed: _sendMessage,
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
