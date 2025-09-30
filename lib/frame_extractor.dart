import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart'; 
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart'; 
import 'package:video_thumbnail/video_thumbnail.dart';

/// Extract a video frame at [timeMs] and convert it to InputImage.
/// This is used for post-analysis review on the ResultPage.
Future<InputImage?> videoFrameToInputImage(String videoPath, int timeMs) async {
  try {
    // Generate the raw JPEG bytes directly from the video file
    final Uint8List? bytes = await VideoThumbnail.thumbnailData(
      video: videoPath,
      timeMs: timeMs,
      imageFormat: ImageFormat.JPEG, 
      quality: 90,
      maxWidth: 640, // Keeping the resolution small for fast ML processing
    );

    if (bytes == null || bytes.isEmpty) return null;

    const Size placeholderSize = Size(640, 480);

    // CRITICAL FIX: We use a generic pixel format (BGRA8888) with bytesPerRow: 0.
    // This tells the native ML Kit library to decode the raw, compressed JPEG buffer.
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: placeholderSize, 
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888, 
        bytesPerRow: 0, 
      ),
    );
  } catch (e) {
    // NOTE: In a professional app, logging should be used instead of print.
    print("Frame extraction failed at $timeMs ms: $e"); 
    return null;
  }
}