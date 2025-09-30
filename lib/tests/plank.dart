import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class PlankTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const PlankTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Plank Hold",
    );
  }
}