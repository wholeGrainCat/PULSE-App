import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          SafeArea(
            child: Column(
              children: [
                // AppBar
                AppBar(
                  title: const Text(
                    'Privacy Policy',
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
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Effective Date Section
                      _buildSectionCard(
                        title: "Effective Date",
                        contentWidget: const Text(
                          "This Privacy Policy is effective as of 1st February 2025. Last updated on 3rd January 2025.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFE0F7F5), // Lighter Cyan
                      ),
                      const SizedBox(height: 20),
                      // Introduction Section
                      _buildSectionCard(
                        title: "Welcome to PULSE",
                        contentWidget: const Text(
                          "PULSE is a student mental health support application for the UNIMAS community. "
                          "We are committed to protecting your personal information. This Privacy Policy "
                          "explains how we collect, use, and safeguard your data.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFF2E4FF), // Lighter Violet
                      ),
                      const SizedBox(height: 20),
                      // Information We Collect Section
                      _buildSectionCard(
                        title: "1. Information We Collect",
                        contentWidget: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "1.1 Personal Information:\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "> Account Information: Email address, username, and password.\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "> Counseling Appointments: Appointment times and preferences.\n\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text: "1.2 Non-Personal Information:\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "> Mood Tracking Data: Anonymous logs of your mood entries.\n"
                                    "> Peer Support Chats: Anonymized chat logs.\n"
                                    "> Usage Data: Features accessed and session durations.\n",
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: const Color(0xFFF9FBD4), // Lighter Green Yellow
                      ),
                      const SizedBox(height: 20),
                      // How We Use Your Information Section
                      _buildSectionCard(
                        title: "2. How We Use Your Information",
                        contentWidget: const Text(
                          "> Facilitate app functionalities like mood tracking and peer support.\n"
                          "> Provide seamless scheduling of counseling appointments.\n"
                          "> Analyze usage trends to improve user experience.\n"
                          "> Ensure confidentiality of interactions.\n"
                          "> Send important updates and policy changes.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFECE3FF), // Lighter Deep Violet
                      ),
                      const SizedBox(height: 20),
                      // Data Sharing and Disclosure Section
                      _buildSectionCard(
                        title: "3. Data Sharing and Disclosure",
                        contentWidget: const Text(
                          "> UNIMAS PsyCon: To facilitate counseling services.\n"
                          "> Legal Compliance: If required by law or legal processes.\n"
                          "> Anonymized Aggregates: For research or reporting.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFE0F7F5), // Lighter Cyan
                      ),
                      const SizedBox(height: 20),
                      // Data Security Section
                      _buildSectionCard(
                        title: "4. Data Security",
                        contentWidget: const Text(
                          "> End-to-end encryption for peer support chats.\n"
                          "> Secure cloud storage for data.\n"
                          "> Regular security audits to prevent unauthorized access.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFF2E4FF), // Lighter Violet
                      ),
                      const SizedBox(height: 20),
                      // Your Rights Section
                      _buildSectionCard(
                        title: "5. Your Rights",
                        contentWidget: const Text(
                          "> Access and Edit: Update your profile and preferences.\n"
                          "> Delete Data: Request deletion of your account and data.\n"
                          "> Withdraw Consent: Opt-out of analytics or data collection.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFF9FBD4), // Lighter Green Yellow
                      ),
                      const SizedBox(height: 20),
                      // Contact Us Section
                      _buildSectionCard(
                        title: "6. Contact Us",
                        contentWidget: const Text(
                          "Email: counsellor@unimas.my\n"
                          "Address: UNIMAS Psychology and Counselling Unit, Universiti Malaysia Sarawak.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        color: const Color(0xFFECE3FF), // Lighter Deep Violet
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable method to build section cards
  Widget _buildSectionCard({
    required String title,
    required Widget contentWidget,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.black, size: 30), // Icon example
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          contentWidget, // Pass a RichText or any Widget
        ],
      ),
    );
  }
}
