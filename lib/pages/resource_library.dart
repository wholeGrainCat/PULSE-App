import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:student/components/app_colour.dart';
import 'package:student/components/bottom_navigation.dart';

class ResourceLibraryPage extends StatefulWidget {
  const ResourceLibraryPage({super.key});

  @override
  State<ResourceLibraryPage> createState() => _ResourceLibraryPageState();
}

class _ResourceLibraryPageState extends State<ResourceLibraryPage> {
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
                Center(
                  child: SizedBox(
                    width: 325,
                    height: 44,
                    child: TextField(
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
                          borderSide: const BorderSide(
                              color: AppColors.pri_purple, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF613EEA),
                            width: 1,
                          ), // Border color when not focused
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Categories Section
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryIcon(
                        'Stress', Fluents.flPerseveringFace, '/stress'),
                    _buildCategoryIcon(
                        'Anxiety', Fluents.flWorriedFace, '/anxiety'),
                    _buildCategoryIcon('Depression',
                        Fluents.flSadButRelievedFace, '/depression'),
                    _buildCategoryIcon('Self-Care',
                        Fluents.flSmilingFaceWithHearts, '/selfcare'),
                  ],
                ),
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

                _buildHorizontalList(context, 'Articles'),

                const SizedBox(height: 20),

                // Recommended Videos Section
                _buildHorizontalList(context, 'Videos'),
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
            backgroundColor: const Color(0XFFF0F0F0),
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

  Widget _buildHorizontalList(BuildContext context, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
                onPressed: () {},
                child: const Text(
                  'More >',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCard(type, 'Sample Title 1'),
              _buildCard(type, 'Sample Title 2'),
              _buildCard(type, 'Sample Title 3'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String type, String title) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 200,
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Color(0XFFF0F0F0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
