import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class SprintTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const SprintTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Sprint Test",
    );
  }
}