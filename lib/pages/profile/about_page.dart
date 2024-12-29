import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About App',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            const SizedBox(height: 30),
            // PULSE Logo and App Information Section
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/images/pulse_logo.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "PULSE",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // About the App Section
            _buildCard(
              icon: Icons.info_outline,
              title: "About the App",
              content:
                  "PULSE is a mental health support application designed to help "
                  "UNIMAS students tackle mental health challenges. It bridges the gap between "
                  "students and mental health resources, addressing stigma, accessibility issues, "
                  "and limited engagement with traditional support systems.",
              color: const Color(0xFF00CBC7),
            ),
            const SizedBox(height: 40),
            // PsyCon Logo and Information Section
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/images/psycon_logo.png',
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Psychology and Counselling Unit (PsyCon)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Acknowledgment Section
            _buildCard(
              icon: Icons.people_alt_outlined,
              title: "Acknowledgments",
              content:
                  "Developed in collaboration with UNIMAS's Psychology and Counselling Unit (PsyCon), "
                  "this app is a product of the dedicated efforts of the Appitude project team, "
                  "aimed at enhancing student mental health and well-being.",
              color: const Color(0xFF9747FF),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget function to build styled cards
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
