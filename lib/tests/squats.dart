import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class SquatsTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const SquatsTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Squats",
    );
  }
}