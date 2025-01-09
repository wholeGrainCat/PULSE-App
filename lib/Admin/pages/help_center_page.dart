import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final List<Map<String, String>> _qnaList = [
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to the login page, click 'Forgot Password', and follow the instructions."
    },
    {
      "question": "How can I contact support?",
      "answer":
          "You can use the 'Start a Conversation' button or email us directly at support@example.com."
    },
    {
      "question": "Where can I find my appointment history?",
      "answer": "Navigate to the 'Appointment History' page from your profile."
    },
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter the Q&A list based on the search query
    final filteredQnA = _qnaList
        .where((qna) =>
            qna['question']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', 
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              // AppBar with Centered Title
              AppBar(
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
              const SizedBox(height: 20),
              // Page Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
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
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFF00CBC7)), // Cyan icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFA4E3E8), // Light blue background
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Q&A Section
                    _buildSectionHeader("Q&A"),
                    const SizedBox(height: 10),
                    filteredQnA.isEmpty
                        ? const Text(
                            "No Data Found",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : _buildQnAList(filteredQnA),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
        color: Colors.black,
      ),
    );
  }

  Widget _buildQnAList(List<Map<String, String>> qnaList) {
    return Column(
      children: qnaList
          .map((qna) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
  }
}
