import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png', // Background image for the page
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // AppBar Section
                AppBar(
                  title: const Text(
                    'About App', // Title for the page
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  backgroundColor: Colors.transparent, // Transparent background
                  elevation: 0, // No shadow
                  centerTitle: true, // Center the title text
                  iconTheme: const IconThemeData(
                      color: Colors.black), // Black icon color
                ),
                // Main Content Area
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // Page padding
                    children: [
                      const SizedBox(
                          height: 30), // Space between AppBar and content

                      // PULSE Logo and App Information Section
                      Center(
                        child: Column(
                          children: [
                            // Container for the logo with styling
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(0, 5), // Subtle shadow
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'assets/images/pulse_logo.png', // Path to the PULSE logo
                                height: 100, // Logo size
                              ),
                            ),
                            const SizedBox(
                                height: 20), // Space between logo and app name
                            const Text(
                              "PULSE", // App name
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(
                                height:
                                    10), // Space between app name and version
                            const Text(
                              "Version 1.0.0", // App version
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Space after PULSE section

                      // About the App Section in a Cyan Card
                      _buildCard(
                        icon: Icons.info_outline, // Icon for this card
                        title: "About the App", // Title for the card
                        content:
                            "PULSE is a mental health support application designed to help "
                            "UNIMAS students tackle mental health challenges. It bridges the gap between "
                            "students and mental health resources, addressing stigma, accessibility issues, "
                            "and limited engagement with traditional support systems.", // Description
                        color: const Color(0xFF00CBC7), // Cyan card color
                      ),
                      const SizedBox(height: 40), // Space before next section

                      // PsyCon Logo and Information Section
                      Center(
                        child: Column(
                          children: [
                            // Container for PsyCon logo
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(0, 5), // Subtle shadow
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'images/psycon.png', // Path to PsyCon logo
                                height: 80, // Logo size
                              ),
                            ),
                            const SizedBox(
                                height: 20), // Space between logo and text
                            const Text(
                              "Psychology and Counselling Unit (PsyCon)", // Title text
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
                      const SizedBox(
                          height: 20), // Space before acknowledgment card

                      // Acknowledgment Section in a Light Violet Card
                      _buildCard(
                        icon: Icons.people_alt_outlined, // Icon for the card
                        title: "Acknowledgments", // Title for the card
                        content:
                            "Developed in collaboration with UNIMAS's Psychology and Counselling Unit (PsyCon), "
                            "this app is a product of the dedicated efforts of the Appitude project team, "
                            "aimed at enhancing student mental health and well-being.", // Description
                        color:
                            const Color(0xFF9747FF), // Light violet card color
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

  // Reusable widget function to build styled cards
  Widget _buildCard({
    required IconData icon, // Icon for the card
    required String title, // Card title
    required String content, // Card content/description
    required Color color, // Card background color
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0), // Space between cards
      decoration: BoxDecoration(
        color: color, // Background color of the card
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: Offset(0, 5), // Shadow effect
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0), // Padding inside the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title with an icon
          Row(
            children: [
              Icon(icon,
                  color: Colors.white, size: 30), // Icon with white color
              const SizedBox(width: 10), // Space between icon and title
              Text(
                title, // Card title text
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Space between title and content
          // Card content/description
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Colors.white70, // Light text color
            ),
          ),
        ],
      ),
    );
  }
}
