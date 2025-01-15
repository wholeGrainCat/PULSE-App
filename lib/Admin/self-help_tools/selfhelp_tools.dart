import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student/Admin/self-help_tools/advertisement/advertisement.dart';
import 'package:student/Admin/self-help_tools/advertisement/advertisement_page.dart';
import 'package:student/Admin/self-help_tools/breathing/breathing_page.dart';
import 'package:student/Admin/self-help_tools/cbt_exercise/cbtexercise_page.dart';
import 'package:student/Admin/self-help_tools/advertisement/advertisement_service.dart';
import 'package:student/Admin/self-help_tools/meditation/meditation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<Color> backgrounds = [
  const Color.fromARGB(128, 164, 227, 232), // A4E3E8 with 50% opacity
  const Color.fromARGB(128, 217, 246, 92), // D9F65C with 50% opacity
  const Color.fromARGB(128, 175, 150, 245), // AF96F5 with 50% opacity
];

class SelfhelpToolsPage extends StatefulWidget {
  const SelfhelpToolsPage({super.key});

  @override
  State<SelfhelpToolsPage> createState() => _SelfhelpToolsPageState();
}

class _SelfhelpToolsPageState extends State<SelfhelpToolsPage> {
  final AdvertisementService _advertisementService = AdvertisementService();
  final PageController _pageController = PageController(viewportFraction: 0.9);

  List<Advertisement> _cachedAdvertisements = [];
  late StreamSubscription<QuerySnapshot<Advertisement>>
      _advertisementSubscription;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _advertisementSubscription =
        _advertisementService.getAdvertisements().listen((snapshot) {
      final ads = snapshot.docs.map((doc) => doc.data()).toList();
      setState(() {
        if (_cachedAdvertisements.isEmpty) {
          _cachedAdvertisements = ads;
        }
      });
    });
  }

  @override
  void dispose() {
    _advertisementSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: buildUI(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  Widget buildFloatingActionButton() {
    return Positioned(
      bottom: 200,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdvertisementPage()),
          );
        },
        backgroundColor: const Color(0XFFD9F65C),
        shape: const CircleBorder(),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Self-Help Tools',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Back.svg',
            height: 20,
            width: 20,
          ),
        ),
      ),
    );
  }

  Widget buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Tips: Let's explore tools designed to help you relax, focus, and navigate challenging emotions! 😊",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            advertisementSection(),
            const SizedBox(height: 20),
            categorySection(),
          ],
        ),
      ),
    );
  }

  Widget advertisementSection() {
    if (_cachedAdvertisements.isEmpty) {
      return const Center(
        child: Text("No advertisements found. Add some to get started!"),
      );
    }

    return SizedBox(
      height: 200,
      width: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _cachedAdvertisements.length,
            itemBuilder: (context, index) {
              final advertisement = _cachedAdvertisements[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      advertisement.advertisementURL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          // Left Arrow
          Positioned(
            left: 0,
            height: 220,
            child: GestureDetector(
              onTap: () {
                if (_pageController.hasClients) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                alignment: Alignment.center,
                width: 37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  'assets/icons/Left.svg',
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          // Right Arrow
          Positioned(
            right: 0,
            height: 220,
            child: GestureDetector(
              onTap: () {
                if (_pageController.hasClients) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  'assets/icons/Right.svg',
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categorySection() {
    return Column(
      children: [
        buildCategoryCard(
          "Breathing",
          "Follow guided breathing exercises to calm your mind and reduce stress in just a few minutes.",
          "https://thumbs.dreamstime.com/b/breath-exercise-good-relaxation-breathe-out-breath-exercise-good-relaxation-breathe-out-relax-deep-131435880.jpg",
          backgrounds[0],
        ),
        buildCategoryCard(
          "CBT Exercises",
          "Learn to identify and reframe negative thoughts with interactive Cognitive Behavioral Therapy techniques.",
          "https://bayareacbtcenter.com/wp-content/uploads/2024/09/Untitled-design-367.png",
          backgrounds[1],
        ),
        buildCategoryCard(
          "Meditation",
          "Practice mindfulness with guided meditations to help you relax and focus on the present moment.",
          "https://thumbs.dreamstime.com/b/meditation-exercise-22138340.jpg",
          backgrounds[2],
        ),
      ],
    );
  }

  Widget buildCategoryCard(String title, String description, String imageUrl,
      Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        if (title == "Meditation") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationPage()),
          );
        }
        if (title == "Breathing") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BreathingPage()),
          );
        }
        if (title == "CBT Exercises") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CbtexercisePage()),
          );
        }
      },
      child: Card(
        color: backgroundColor,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        width: 100,
                        height: 110,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 24);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: 37,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ArrowRight.svg',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
