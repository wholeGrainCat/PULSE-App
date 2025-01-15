import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/self-help_tools/cbt_exercise/cbtexercise.dart';
import 'package:student/Admin/self-help_tools/cbt_exercise/cbtexercise_service.dart';
import 'package:student/components/app_colour.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentCbtexercisePage extends StatefulWidget {
  const StudentCbtexercisePage({super.key});

  @override
  State<StudentCbtexercisePage> createState() => _StudentCbtexercisePageState();
}

class _StudentCbtexercisePageState extends State<StudentCbtexercisePage> {
  final CbtexerciseService cbtexerciseService = CbtexerciseService();
  final CbtVideoService cbtVideoService = CbtVideoService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'CBT Exercise',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommended CBT Videos 🌵',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(color: Colors.black, thickness: 2),
            const SizedBox(height: 10),
            _videoSection(),
            const SizedBox(height: 20),
            const Text(
              'CBT Worksheets and Exercises 📖',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Divider(color: Colors.black, thickness: 2),
            const SizedBox(height: 10),
            _exerciseList(),
          ],
        ),
      ),
    );
  }

  Widget _exerciseList() {
    return StreamBuilder<QuerySnapshot<Cbtexercise>>(
      stream: cbtexerciseService.getCbtexercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("No CBT exercises found.",
                  style: TextStyle(fontSize: 16)));
        }

        final cbtexercises = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true, // Prevent ListView from occupying full height
          physics:
              const NeverScrollableScrollPhysics(), // Prevent scrolling within this section
          itemCount: cbtexercises.length,
          itemBuilder: (context, index) {
            final cbtexercise = cbtexercises[index].data() as Cbtexercise;
            // Alternate between three colors based on index
            Color cardColor;
            if (index % 3 == 0) {
              cardColor = AppColors.sec_cyan;
            } else if (index % 3 == 1) {
              cardColor = AppColors.sec_purple.withOpacity(0.8);
            } else {
              cardColor = AppColors.pri_greenYellow.withOpacity(0.8);
            }
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius:
                    BorderRadius.circular(16), // Adjust the radius as needed
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () async =>
                      await launchUrl(Uri.parse(cbtexercise.url)),
                  child: Text(
                    cbtexercise.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _videoSection() {
    return StreamBuilder<QuerySnapshot<CbtVideo>>(
      stream: cbtVideoService.getCbtVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
          return const Center(child: Text("No videos available."));

        final videos = snapshot.data!.docs;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index].data() as CbtVideo;
              return Padding(
                padding:
                    const EdgeInsets.only(right: 4.0), // Spacing between items
                child: SizedBox(width: 300, child: VideoCard(video: video)),
              );
            },
          ),
        );
      },
    );
  }
}

class VideoCard extends StatelessWidget {
  final CbtVideo video;
  const VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(video.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            _showErrorDialog(context, "Cannot open video URL.");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video.thumbnail,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        child: const Center(
                            child: Icon(Icons.broken_image, size: 50)),
                      ),
                    ),
                  ),
                  const Icon(Icons.play_circle_filled,
                      color: Colors.white, size: 50),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1, // Restrict to one line
                overflow:
                    TextOverflow.ellipsis, // Add ellipsis if the text overflows
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }
}
