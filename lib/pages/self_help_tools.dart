import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SelfHelpTools extends StatelessWidget {
  const SelfHelpTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Help Tools'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Let\'s explore tools designed to help you relax, focus and navigate challenging emotions!',
              ),
              const SizedBox(height: 16),
              CarouselSlider(
                items: [
                  Image.asset('assets/images/slider1.png', fit: BoxFit.cover),
                  Image.asset('assets/images/slider1.png', fit: BoxFit.cover),
                  Image.asset('assets/images/slider1.png', fit: BoxFit.cover),
                ],
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tips for dealing with anxiety',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ToolCard(
                imagePath: 'assets/images/breathing.png',
                title: 'Breathing',
                description:
                    'Follow guided breathing exercises to calm your mind and reduce stress in just a few minutes.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailScreen(
                        title: 'Breathing',
                        details:
                            'Guided breathing exercises can help slow down your heart rate and relax your mind. Focus on inhaling deeply through your nose and exhaling through your mouth for a few minutes.',
                      ),
                    ),
                  );
                },
              ),
              ToolCard(
                imagePath: 'assets/images/meditation.png',
                title: 'Meditation',
                description:
                    'Practice mindfulness with guided meditations to help you relax and focus on the present moment.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailScreen(
                        title: 'Meditation',
                        details:
                            'Meditation helps you center your thoughts and focus on the present. Start with 5-minute guided meditations and gradually increase the duration.',
                      ),
                    ),
                  );
                },
              ),
              ToolCard(
                imagePath: 'assets/images/cbt.png',
                title: 'CBT Exercise',
                description:
                    'Learn to identify and reframe negative thoughts with interactive Cognitive Behavioral Therapy techniques.',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailScreen(
                        title: 'CBT Exercise',
                        details:
                            'Cognitive Behavioral Therapy (CBT) exercises teach you how to recognize negative thinking patterns and replace them with healthier thoughts.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToolCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Image on the left
            Image.asset(
              imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image,
                    size: 64, color: Colors.grey);
              },
            ),
            const SizedBox(width: 16), // Space between image and text
            // Title and description on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            // Arrow icon for navigation
            GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  final String details;

  const DetailScreen({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          details,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
