import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  Image.asset('assets/images/slider2.png', fit: BoxFit.cover),
                  Image.asset('assets/images/slider3.png', fit: BoxFit.cover),
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
              // Fetch tools dynamically
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('self_help_tools')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No tools available.'),
                    );
                  }

                  final tools = snapshot.data!.docs;

                  return Column(
                    children: tools.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ToolCard(
                        imagePath: data['image'] ?? '',
                        title: data['title'] ?? '',
                        description: data['description'] ?? '',
                        onTap: () {
                          final url = data['url'] ?? '';
                          if (url.isNotEmpty) {
                            launchUrl(Uri.parse(url));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No URL provided')),
                            );
                          }
                        },
                      );
                    }).toList(),
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
            Image.network(
              imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image,
                    size: 64, color: Colors.grey);
              },
            ),
            const SizedBox(width: 16),
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
