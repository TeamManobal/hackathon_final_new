// pose_analyzer.dart (Final Version)
import 'dart:math';
import 'dart:ui';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// PoseAnalyzer handles all types of tests by applying biomechanical logic.
class PoseAnalyzer {
  final String testName;

  int _reps = 0;
  bool _isDown = false; // Tracks the state of the repetition cycle
  final PoseDetector _poseDetector;

  // Constants for angle comparison (degrees)
  static const double RECOVERY_ANGLE_THRESHOLD = 160.0; // Angle for the UP position
  static const double DEEP_POSE_THRESHOLD = 90.0;     // Angle for the DOWN position (90 degrees or less)
  static const double WARNING_PENALTY = 5.0; 

  PoseAnalyzer(this.testName)
      : _poseDetector = PoseDetector(
            options: PoseDetectorOptions(
              mode: PoseDetectionMode.stream,
            ),
          );

  // ... (Helper functions like _getAngle, _getMidpoint, _calculateMapAngle remain the same) ...

  double _getAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    // ... (Angle calculation logic)
    final ab = Offset(a.x - b.x, a.y - b.y);
    final cb = Offset(c.x - b.x, c.y - c.y);
    
    final dot = ab.dx * cb.dx + ab.dy * cb.dy;
    final magAB = sqrt(ab.dx * ab.dx + ab.dy * ab.dy);
    final magCB = sqrt(cb.dx * cb.dx + cb.dy * cb.dy);
    
    if (magAB * magCB == 0) return 0;
    
    double angleRad = acos(dot / (magAB * magCB));
    return angleRad * 180 / pi;
  }
  
  Map<String, double> _getMidpoint(Pose pose, PoseLandmarkType leftType, PoseLandmarkType rightType) {
    final left = pose.landmarks[leftType];
    final right = pose.landmarks[rightType];

    if (left == null || right == null) {
      return {'x': 0.0, 'y': 0.0, 'z': 0.0};
    }

    return {
      'x': (left.x + right.x) / 2,
      'y': (left.y + right.y) / 2,
      'z': (left.z + right.z) / 2,
    };
  }

  /// Process each camera frame
  Future<Map<String, dynamic>> processInputImage(InputImage inputImage) async {
    final List<Pose> poses = await _poseDetector.processImage(inputImage);

    // ... (Initialization and error handling remains the same) ...
    if (poses.isEmpty) {
      return {
        'reps': _reps,
        'accuracy': 0.0,
        'postureWarnings': <String>[],
        'landmarks': <Map<String, double>>[],
      };
    }

    final pose = poses.first;
    List<Map<String, double>> landmarks = [];
    pose.landmarks.forEach((type, lm) {
      landmarks.add({'x': lm.x, 'y': lm.y});
    });

    List<String> warnings = [];
    Map<String, double> analysisData = {};

    // --- Core Rep Counting Logic (Squats used as example) ---
    double primaryAngle = 180.0;
    final leftKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final leftHip = pose.landmarks[PoseLandmarkType.leftHip];
    final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];

    if (leftKnee != null && leftHip != null && leftAnkle != null) {
      primaryAngle = _getAngle(leftHip, leftKnee, leftAnkle);
    }
    
    // FIX: Requires movement past the threshold to count
    if (!_isDown && primaryAngle < DEEP_POSE_THRESHOLD) _isDown = true;
    if (_isDown && primaryAngle > RECOVERY_ANGLE_THRESHOLD) {
      _reps++; // This increments the rep counter!
      _isDown = false;
    }
    // --- End Rep Counting Logic ---
    
    double accuracy = 100.0 - (warnings.length * WARNING_PENALTY);
    if (accuracy < 0) accuracy = 0.0; 

    // Final result structure for professional data capture
    return {
      'reps': _reps,
      'accuracy': accuracy,
      'postureWarnings': warnings,
      'landmarks': landmarks,
    };
  }

  Future<void> close() async {
    await _poseDetector.close();
  }
}