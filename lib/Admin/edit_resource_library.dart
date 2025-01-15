import 'package:student/Student/resources/articles.dart';
import 'package:student/Student/resources/videos.dart';
import 'package:student/components/admin_bottom_navigation.dart';
import 'package:student/components/app_colour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EditResourceLibraryPage extends StatefulWidget {
  const EditResourceLibraryPage({super.key});

  @override
  State<EditResourceLibraryPage> createState() =>
      _EditResourceLibraryPageState();
}

class ResourceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch resources by contentType
  Future<List<Map<String, dynamic>>> getResourcesByContentType(
      String type) async {
    QuerySnapshot snapshot = await _firestore
        .collection('resources')
        .where('contentType', isEqualTo: type)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id, // Add document ID
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Other methods remain unchanged...
}

class _EditResourceLibraryPageState extends State<EditResourceLibraryPage> {
  final ResourceService _resourceService = ResourceService();
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  bool isEditMode = false; // Flag to toggle edit mode

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    void navigateTo(String page) {
      // Replace with actual navigation logic
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Resources',
          style: TextStyle(
            color: Colors.black, 
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: AdminBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            // Navigate based on the tab index
            switch (index) {
              case 0:
                // Navigate to Resources page
                Navigator.pushNamed(context, '/adminresource');
                break;
              case 1:
                // Navigate to Appointment page
                Navigator.pushNamed(context, '/adminappointment');
                break;
              case 2:
                // Navigate to Chat page
                Navigator.pushNamed(
                    context, '/admindashboard'); // Use named route for chat
                break;
              case 3:
                // Navigate to Profile page
                Navigator.pushNamed(context, '/adminchat');
                break;
              case 4:
                // Navigate to Profile page
                Navigator.pushNamed(context, '/adminprofile');
                break;
              default:
                break;
            }
          }),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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
      // FloatingActionButton for edit mode
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditMode = !isEditMode; // Toggle edit mode
          });
        },
        backgroundColor: isEditMode
            ? const Color.fromRGBO(0, 203, 199, 1.0)
            : const Color.fromRGBO(97, 62, 234, 1.0),
        child: FaIcon(
          isEditMode
              ? FontAwesomeIcons.circleCheck
              : FontAwesomeIcons.penToSquare,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> resource) {
    final url = resource['url'];
    final isVideo = resource['contentType'] == 'Videos';

    return GestureDetector(
      onTap: isEditMode
          ? () => _editResourceDialog(resource['id'], resource)
          : () async {
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
              width: double.infinity,
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

  void _editResourceDialog(String resourceId, Map<String, dynamic> resource) {
    // Determine whether it's a video or article based on `contentType`
    final isVideo = resource['contentType'] == 'Videos';

    // Controllers for each field
    TextEditingController categoryController =
        TextEditingController(text: resource['category']);
    TextEditingController contentTypeController =
        TextEditingController(text: resource['contentType']);
    TextEditingController titleController =
        TextEditingController(text: resource['title']);
    TextEditingController descriptionController =
        TextEditingController(text: resource['description']);
    TextEditingController mediaController = TextEditingController(
        text: isVideo ? resource['thumbnail'] : resource['image']);
    TextEditingController urlController =
        TextEditingController(text: resource['url']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isVideo ? "Edit Video" : "Edit Article"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Common fields
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: "Category"),
                ),
                TextField(
                  controller: contentTypeController,
                  decoration: const InputDecoration(labelText: "Content Type"),
                  readOnly: true, // Content Type is fixed
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                // Media field
                TextField(
                  controller: mediaController,
                  decoration: InputDecoration(
                    labelText: isVideo ? "Thumbnail URL" : "Image URL",
                  ),
                ),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: "URL"),
                ),
              ],
            ),
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            // Save button
            TextButton(
              onPressed: () {
                // Prepare the updated data
                final updatedData = {
                  'category': categoryController.text,
                  'contentType': contentTypeController.text,
                  'title': titleController.text,
                  'description': descriptionController.text,
                  if (isVideo)
                    'thumbnail': mediaController.text
                  else
                    'image': mediaController.text,
                  'url': urlController.text,
                };

                // Update Firestore
                FirebaseFirestore.instance
                    .collection('resources')
                    .doc(resourceId)
                    .update(updatedData);

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            // Delete button
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('resources')
                    .doc(resourceId)
                    .delete();
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
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
}
