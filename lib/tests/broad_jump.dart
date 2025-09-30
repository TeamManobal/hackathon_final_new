import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class BroadJumpTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const BroadJumpTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Broad Jump",
    );
  }
}