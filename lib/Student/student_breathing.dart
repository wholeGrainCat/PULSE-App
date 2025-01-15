import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/self-help_tools/breathing/breathing.dart';
import 'package:student/Admin/self-help_tools/breathing/breathing_service.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBreathingPage extends StatelessWidget {
  const StudentBreathingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final breathingService = BreathingService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Breathing',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _breathingList(breathingService),
              const SizedBox(height: 20),
              const Text(
                'Recommended Breathing Videos 🥳',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              _videoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _breathingList(BreathingService breathingService) {
    return StreamBuilder<QuerySnapshot<Breathing>>(
      stream: breathingService.getBreaths(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No Breathing Exercises found.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        final breaths = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: breaths.length,
          itemBuilder: (context, index) {
            final breathing = breaths[index].data();
            return BreathingCard(breathing: breathing);
          },
        );
      },
    );
  }

  Widget _videoSection() {
    final breathingVideoService = BreathingVideoService();
    return StreamBuilder<QuerySnapshot<BreathingVideo>>(
      stream: breathingVideoService.getBreathingVideos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No videos available."),
          );
        }
        final videos = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index].data();
            return VideoCard(video: video);
          },
        );
      },
    );
  }
}

class BreathingCard extends StatelessWidget {
  final Breathing breathing;
  const BreathingCard({super.key, required this.breathing});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(breathing.title),
            const SizedBox(height: 10),
            Text(breathing.introduction, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            ..._buildGuideLines(breathing),
            const SizedBox(height: 10),
            if (breathing.conclusion.isNotEmpty)
              Text(
                breathing.conclusion,
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGuideLines(Breathing breathing) {
    final guideLines = [
      breathing.line1,
      breathing.line2,
      breathing.line3,
      breathing.line4,
      breathing.line5,
      breathing.line6,
      breathing.line7,
      breathing.line8,
      breathing.line9,
      breathing.line10,
    ];
    return guideLines
        .asMap()
        .entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .map((entry) {
      final step = entry.key + 1;
      return Text(
        "Step $step: ${entry.value}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      );
    }).toList();
  }
}

class VideoCard extends StatelessWidget {
  final BreathingVideo video;
  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(video.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            _showErrorDialog(context, "Cannot open video URL.");
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  child: Image.network(
                    video.thumbnail,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      ),
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
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
