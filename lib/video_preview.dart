// video_preview.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'result_page.dart';

class VideoPreviewPage extends StatefulWidget {
  final String recordedVideoPath;
  final String testName;

  const VideoPreviewPage({
    super.key,
    required this.recordedVideoPath,
    required this.testName,
  });

  @override
  State<VideoPreviewPage> createState() => _VideoPreviewPageState();
}

class _VideoPreviewPageState extends State<VideoPreviewPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    if (File(widget.recordedVideoPath).existsSync()) {
      _controller = VideoPlayerController.file(File(widget.recordedVideoPath))
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          _controller.play();
        });
    }
  }

  @override
  void dispose() {
    if (_isInitialized) _controller.dispose();
    super.dispose();
  }

  void _simulateAnalysis() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Close loading
    Navigator.pop(context);

    // Navigate to ResultPage with dummy data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          testName: widget.testName,
          recordedVideoPath: widget.recordedVideoPath,
          initialMetrics: {'repetitions': 5, 'accuracy': 92.0},
          initialScore: 80,
          landmarksPerFrame: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Preview")),
      body: Column(
        children: [
          if (_isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            Container(
              height: 300,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Video not available",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _simulateAnalysis,
            icon: const Icon(Icons.cloud_upload),
            label: const Text("Upload & Analyze"),
          ),
        ],
      ),
    );
  }
}
