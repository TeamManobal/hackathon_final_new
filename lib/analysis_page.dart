import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnalysisPage extends StatefulWidget {
  final String videoUrl;

  const AnalysisPage({super.key, required this.videoUrl});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _results;
  String? _error;
  late String backendUrl;

  @override
  void initState() {
    super.initState();
    _setupBackendUrl();
    _sendVideoToBackend();
  }

  void _setupBackendUrl() {
    // ✅ Emulator uses 10.0.2.2, real device uses PC local IP
    if (kIsWeb) {
      backendUrl = "http://localhost:8000/analyze"; // Optional for web
    } else if (Platform.isAndroid) {
      backendUrl = "http://10.0.2.2:8000/analyze"; // Android emulator
    } else {
      backendUrl = "http://YOUR_PC_IP:8000/analyze"; // iOS emulator or real device (replace YOUR_PC_IP)
    }
  }

  Future<void> _sendVideoToBackend() async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"video_url": widget.videoUrl}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _results = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Server error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Request failed: $e";
        _isLoading = false;
      });
    }
  }

  Widget _buildResults() {
    if (_results == null) return const Text("No results found.");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "✅ Official Report",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        Text("Form Accuracy: ${_results!['accuracy']}%"),
        Text("Reps Counted: ${_results!['reps']}"),
        const SizedBox(height: 10),
        if (_results!['warnings'] != null &&
            (_results!['warnings'] as List).isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "⚠️ Warnings:",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              ...(_results!['warnings'] as List).map((w) => Text("- $w")),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analysis Results")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text("❌ Error: $_error",
                    style: const TextStyle(color: Colors.red))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildResults(),
                  ),
      ),
    );
  }
}
