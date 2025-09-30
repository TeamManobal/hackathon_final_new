import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class PushupTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const PushupTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Push-ups",
    );
  }
}