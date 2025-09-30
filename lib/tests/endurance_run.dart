import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../camera.dart'; 

class EnduranceRunTestPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const EnduranceRunTestPage({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return CameraRecordPage(
      cameras: cameras,
      testName: "Endurance Run",
    );
  }
}