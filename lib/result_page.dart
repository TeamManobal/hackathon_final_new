// result_page.dart
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String testName;
  final Map<String, dynamic> initialMetrics; // includes stamina, strength, form
  final int initialScore;
  final List<List<Map<String, double>>> landmarksPerFrame;
  final String recordedVideoPath;

  const ResultPage({
    super.key,
    required this.testName,
    required this.initialMetrics,
    required this.initialScore,
    required this.landmarksPerFrame,
    required this.recordedVideoPath,
  });

  @override
  Widget build(BuildContext context) {
    // Use sample/default values if not provided
    double accuracy = initialMetrics['accuracy']?.toDouble() ?? 92.0;
    int repetitions = initialMetrics['repetitions'] ?? 15;
    double stamina = initialMetrics['stamina']?.toDouble() ?? 75.0;
    double strength = initialMetrics['strength']?.toDouble() ?? 80.0;
    double form = initialMetrics['form']?.toDouble() ?? 85.0;
    int targetReps = initialMetrics['targetReps'] ?? 20; // for reference

    Widget metricCard(String title, double value, Color color, {String? suffix}) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: (value / 100).clamp(0.0, 1.0),
                color: color,
                backgroundColor: Colors.grey[300],
                minHeight: 20,
              ),
              const SizedBox(height: 8),
              Text(suffix ?? "${value.toStringAsFixed(1)}%"),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Analysis"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Test Name
            Card(
              color: Colors.indigo[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  testName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Overall Score
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Overall Score",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      child: Text(
                        "$initialScore",
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Accuracy
            metricCard("Accuracy", accuracy, Colors.green),

            const SizedBox(height: 10),

            // Repetitions (show actual reps / target)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Repetitions",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (repetitions / targetReps).clamp(0.0, 1.0),
                      color: Colors.orange,
                      backgroundColor: Colors.grey[300],
                      minHeight: 20,
                    ),
                    const SizedBox(height: 8),
                    Text("$repetitions / $targetReps reps"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Stamina, Strength, Form
            metricCard("Stamina", stamina, Colors.blue),
            const SizedBox(height: 10),
            metricCard("Strength", strength, Colors.red),
            const SizedBox(height: 10),
            metricCard("Form", form, Colors.purple),

            const SizedBox(height: 20),

            // Detailed Frame Analysis
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Detailed Frame Analysis",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Text("Frames Recorded: ${landmarksPerFrame.length}"),
                    const SizedBox(height: 5),
                    Text(
                      "Video Path: $recordedVideoPath",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Back Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text(
                "Back to Tests",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
