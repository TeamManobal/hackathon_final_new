import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'camera.dart'; 
import 'package:camera/camera.dart';

class TestDescriptionPage extends StatefulWidget {
  final String testName;
  final List<CameraDescription> cameras;
  final String animationAsset;

  const TestDescriptionPage({
    super.key,
    required this.testName,
    required this.cameras,
    required this.animationAsset,
  });

  @override
  State<TestDescriptionPage> createState() => _TestDescriptionPageState();
}

class _TestDescriptionPageState extends State<TestDescriptionPage> {
  late VideoPlayerController _animationController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize the video controller immediately, but don't block the UI
    _animationController = VideoPlayerController.asset(widget.animationAsset);
    
    _animationController.initialize().then((_) {
      if (mounted) {
        // Start playing the demo video once it's ready
        _animationController.setVolume(0.0);
        _animationController.setLooping(true);
        _animationController.play();
        setState(() {
          _isInitialized = true;
        }); 
      }
    }).catchError((error) {
      if (mounted) {
        // Log the error but do NOT block the start of the test
        print('Error loading video: $error');
        setState(() => _isInitialized = false);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTest() {
    // START THE TEST IMMEDIATELY WITHOUT WAITING FOR _isInitialized
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraRecordPage(
          cameras: widget.cameras,
          testName: widget.testName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.testName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- INSTRUCTIONS HEADER ---
            Text(
              "Instructions for ${widget.testName}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "• Ensure your full body is visible on the camera.\n"
              "• Keep the phone steady for accurate analysis.\n"
              "• Perform the exercise smoothly to match the demonstration.\n"
              "• Press Start Test when you are ready to begin recording.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            // --- ANIMATION DISPLAY ---
            Expanded(
              child: Center(
                child: _isInitialized
                    ? AspectRatio(
                        aspectRatio: _animationController.value.aspectRatio,
                        child: VideoPlayer(_animationController),
                      )
                    : const CircularProgressIndicator(), // Show loading indicator until video is ready
              ),
            ),
            const SizedBox(height: 20),
            
            // --- START BUTTON (Always Clickable) ---
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  foregroundColor: Colors.white, 
                ),
                onPressed: _startTest, // Always active
                child: const Text("Start Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}