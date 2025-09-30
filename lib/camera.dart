// camera_record_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'video_preview.dart';

class CameraRecordPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String testName;

  const CameraRecordPage({
    super.key,
    required this.cameras,
    required this.testName,
  });

  @override
  State<CameraRecordPage> createState() => _CameraRecordPageState();
}

class _CameraRecordPageState extends State<CameraRecordPage> {
  CameraController? _controller;
  bool _isRecording = false;
  int _currentCameraIndex = 0;

  String? _videoFilePath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (widget.cameras.isEmpty) return;

    _controller?.dispose();

    _controller = CameraController(
      widget.cameras[_currentCameraIndex % widget.cameras.length],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      print("Camera init error: $e");
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleCamera() {
    if (widget.cameras.length > 1) {
      _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;
      _initCamera();
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_isRecording) {
      setState(() => _isRecording = false);

      try {
        final XFile file = await _controller!.stopVideoRecording();
        _videoFilePath = file.path;
        if (_videoFilePath != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPreviewPage(
                testName: widget.testName,
                recordedVideoPath: _videoFilePath!,
              ),
            ),
          );
        }
      } catch (e) {
        print("❌ Error stopping video: $e");
      }
    } else {
      setState(() => _isRecording = true);
      try {
        await _controller!.prepareForVideoRecording();
        await _controller!.startVideoRecording();
      } catch (e) {
        print("❌ Error starting recording: $e");
        setState(() => _isRecording = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _toggleRecording,
                backgroundColor: _isRecording ? Colors.red : Colors.green,
                child: Icon(_isRecording ? Icons.stop : Icons.videocam),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 15,
            right: 15,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
              onPressed: _toggleCamera,
            ),
          ),
        ],
      ),
    );
  }
}
