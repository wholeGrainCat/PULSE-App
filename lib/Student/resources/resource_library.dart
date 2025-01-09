import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/Student/resources/articles.dart';
import 'package:student/Student/resources/videos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResourceLibraryPage extends StatefulWidget {
  const ResourceLibraryPage({super.key});

  @override
  State<ResourceLibraryPage> createState() => _ResourceLibraryPageState();
}

class ResourceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch resources by category
  Future<List<Map<String, dynamic>>> getResourcesByCategory(
      String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('resources')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Fetch resources by contentType
  Future<List<Map<String, dynamic>>> getResourcesByContentType(
      String type) async {
    QuerySnapshot snapshot = await _firestore
        .collection('resources')
        .where('contentType', isEqualTo: type)
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

class _ResourceLibraryPageState extends State<ResourceLibraryPage> {
  final ResourceService _resourceService = ResourceService();
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  int _currentIndex = 0;

  void navigateTo(String page) {
    print("Navigating to $page");
    // Handle other navigation cases
    if (page == 'Resource') {
      Navigator.pushNamed(context, '/resource');
    } else if (page == 'Dashboard') {
      Navigator.pushNamed(context, '/studentdashboard');
    } else if (page == 'Chat') {
      Navigator.pushNamed(context, '/chat');
    } else if (page == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
  }

  Future<void> checkMoodStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      // Retrieve the last logged date and mood status
      String? lastLoggedDate = prefs.getString('lastLoggedDate_$userId');
      DateTime today = DateTime.now();
      String todayString = "${today.year}-${today.month}-${today.day}";

      // Check if the last logged date matches today's date
      bool hasLoggedMood = (lastLoggedDate == todayString);
      print("User ID: $userId");
      print("Last Logged Date: $lastLoggedDate");
      print("Has logged mood today: $hasLoggedMood");

      if (hasLoggedMood) {
        // Navigate to the mood done page (only once)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/mooddonecheckin');
        });
      } else {
        // Navigate to the mood tracker page if not logged
        Navigator.pushReplacementNamed(context, '/moodtracker');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Resources',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              navigateTo('Resource');
              break;
            case 1:
              checkMoodStatus();
              break;
            case 2:
              navigateTo('Dashboard');
              break;
            case 3:
              navigateTo('Chat');
              break;
            case 4:
              navigateTo('Profile');
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                _buildSearchBar(),
                const SizedBox(height: 20),
                // Categories Section
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildCategorySection(),
                const SizedBox(height: 20),
                // Recommended Articles Section
                const Center(
                  child: Text(
                    '-Recommended For You-',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  indent: 70,
                  endIndent: 70,
                  height: 7,
                ),
                _buildResourceList('Articles'),
                _buildResourceList('Videos'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String label, FluentData emojis, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 37.5,
            backgroundColor: const Color(0XFFFAFAFA),
            child: FluentUiEmojiIcon(
              fl: emojis,
              w: 58,
              h: 58,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> resource) {
    final url = resource['url'];
    final isVideo = resource['contentType'] == 'Videos';
    return GestureDetector(
      onTap: () async {
        if (url != null && Uri.tryParse(url) != null) {
          final uri = Uri.parse(url); // Convert String to Uri
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            debugPrint('Could not launch $url');
          }
        } else {
          debugPrint('Invalid or null URL: $url');
        }
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: double
                  .infinity, // Ensures the image takes up the full width of the container
              child: ClipRRect(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (resource['image'] != null ||
                        resource['thumbnail'] != null)
                      Image.network(
                        resource['image'] ?? resource['thumbnail'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                      )
                    else
                      Container(height: 120, color: Colors.grey[200]),
                    if (isVideo)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    resource['description'] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Center(
      child: SizedBox(
        width: 325,
        height: 44,
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search articles or videos',
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0XFFD9D9D9)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide:
                  const BorderSide(color: AppColors.pri_purple, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF613EEA), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          onChanged: (query) {
            setState(() {
              searchTerm = query;
            });
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryIcon('Stress', Fluents.flPerseveringFace, '/stress'),
        _buildCategoryIcon('Anxiety', Fluents.flWorriedFace, '/anxiety'),
        _buildCategoryIcon(
            'Depression', Fluents.flSadButRelievedFace, '/depression'),
        _buildCategoryIcon(
            'Self-Care', Fluents.flSmilingFaceWithHearts, '/selfcare'),
      ],
    );
  }

  Widget _buildResourceList(String type) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _resourceService.getResourcesByContentType(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No resources found.'));
        }

        final resources = snapshot.data!;

        // Filter resources based on the search query
        final filteredResources = resources.where((resource) {
          final title = resource['title'].toString().toLowerCase();
          final description =
              resource['description']?.toString().toLowerCase() ?? '';
          final category = resource['category']?.toString().toLowerCase() ?? '';
          final query = searchTerm.toLowerCase();

          // Check if any of the fields contain the search query
          return title.contains(query) ||
              description.contains(query) ||
              category.contains(query);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Articles or Videos page based on the type
                    if (type == "Articles") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Articles(),
                        ),
                      );
                    } else if (type == "Videos") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Videos(),
                        ),
                      );
                    } else {
                      // Handle other types or show an error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Page not available for $type')),
                      );
                    }
                  },
                  child: const Text(
                    'More >',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: filteredResources
                    .map((resource) => _buildCard(resource))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
