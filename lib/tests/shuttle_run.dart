import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class ShuttleRunTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const ShuttleRunTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Shuttle Run",
    );
  }
}