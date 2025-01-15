import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/Student/student_breathing.dart';
import 'package:student/Student/student_cbtExercise.dart';
import 'package:student/Student/student_meditation.dart';
import 'package:student/components/app_colour.dart';

final List<Color> backgrounds = [
  AppColors.pri_greenYellow.withOpacity(0.5),
  AppColors.sec_cyan.withOpacity(0.5),
  AppColors.sec_purple.withOpacity(0.5),
];

class SelfHelpTools extends StatefulWidget {
  const SelfHelpTools({super.key});

  @override
  State<SelfHelpTools> createState() => _SelfHelpToolsState();
}

class _SelfHelpToolsState extends State<SelfHelpTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                'Let\'s explore tools designed to help you relax, focus and navigate challenging emotions! 😊',
              ),
              const SizedBox(height: 16),
              const AdvertisementSlider(),
              const SizedBox(height: 16),
              // Fetch tools dynamically
              categorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget categorySection() {
    return Column(
      children: [
        ToolCard(
          title: "Breathing",
          description:
              "Follow guided breathing exercises to calm your mind and reduce stress in just a few minutes.",
          imagePath:
              "https://thumbs.dreamstime.com/b/breath-exercise-good-relaxation-breathe-out-breath-exercise-good-relaxation-breathe-out-relax-deep-131435880.jpg",
          backgroundColor: backgrounds[0],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StudentBreathingPage()),
            );
          },
        ),
        ToolCard(
          title: "CBT Exercises",
          description:
              "Learn to identify and reframe negative thoughts with interactive Cognitive Behavioral Therapy techniques.",
          imagePath:
              "https://bayareacbtcenter.com/wp-content/uploads/2024/09/Untitled-design-367.png",
          backgroundColor: backgrounds[1],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StudentCbtexercisePage()),
            );
          },
        ),
        ToolCard(
          title: "Meditation",
          description:
              "Practice mindfulness with guided meditations to help you relax and focus on the present moment.",
          imagePath:
              "https://thumbs.dreamstime.com/b/meditation-exercise-22138340.jpg",
          backgroundColor: backgrounds[2],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const StudentMeditationPage()),
            );
          },
        ),
      ],
    );
  }
}

class ToolCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 340,
          height: 120,
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: backgroundColor,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Advertisement
class AdvertisementSlider extends StatefulWidget {
  const AdvertisementSlider({super.key});

  @override
  _AdvertisementSliderState createState() => _AdvertisementSliderState();
}

class _AdvertisementSliderState extends State<AdvertisementSlider> {
  List<String> advertisementUrls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdvertisements();
  }

  void fetchAdvertisements() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('advertisements')
          .orderBy('createdOn', descending: true)
          .get();

      setState(() {
        advertisementUrls = snapshot.docs
            .map((doc) => doc['advertisementURL'] as String)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching advertisements: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (advertisementUrls.isEmpty) {
      return const Center(child: Text('No advertisements available'));
    }

    return CarouselSlider(
      items: advertisementUrls.map((url) {
        return Image.network(url, fit: BoxFit.cover);
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
