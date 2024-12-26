import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';
import 'package:student/pages/RL_sidePages/articles.dart';
import 'package:student/pages/RL_sidePages/videos.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Search resources by title (articles/videos)
  Future<List<Map<String, dynamic>>> searchResources(String searchTerm) async {
    QuerySnapshot snapshot = await _firestore
        .collection('resources')
        .where('title', isGreaterThanOrEqualTo: searchTerm)
        .where('title', isLessThanOrEqualTo: searchTerm + '\uf8ff')
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

class _ResourceLibraryPageState extends State<ResourceLibraryPage> {
  final ResourceService _resourceService = ResourceService();
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    void navigateTo(String page) {
      // Replace with actual navigation logic
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Resources'),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/resource');
              break;
            case 1:
              Navigator.pushNamed(context, '/moodtracker');
              break;
            case 2:
              Navigator.pushNamed(context, '/studentdashboard');
              break;
            case 3:
              navigateTo("Chat");
              break;
            case 4:
              navigateTo("Profile");
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
                  color: Colors.black, // Change the color of the divider
                  thickness: 2, // Set the thickness of the divider
                  indent: 70, // Add space before the divider starts
                  endIndent: 70, // Add space after the divider ends
                  height:
                      7, // Set the height of the divider (space around the divider)
                ),
                _buildResourceList('Articles'),
                // const SizedBox(height: 10),
                // Recommended Videos Section
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
        margin: EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120, // Set a fixed height for all images
              width: double
                  .infinity, // Ensures the image takes up the full width of the container
              child: ClipRRect(
                child:
                    resource['image'] != null || resource['thumbnail'] != null
                        ? Image.network(
                            resource['image'] ?? resource['thumbnail'],
                            fit: BoxFit.cover,
                          )
                        : Container(height: 120, color: Colors.grey[200]),
              ), // Fallback if no image
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
                    resource['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   resource['category'],
                  //   style: const TextStyle(
                  //       fontSize: 12, fontWeight: FontWeight.w500),
                  // ),
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
          onChanged: (value) {
            setState(() {
              searchTerm = value;
            });
          },
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
                  onPressed: () {},
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
                children:
                    resources.map((resource) => _buildCard(resource)).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
