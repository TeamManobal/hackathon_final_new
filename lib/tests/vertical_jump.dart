import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class VerticalJumpTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const VerticalJumpTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Vertical Jump",
    );
  }
}