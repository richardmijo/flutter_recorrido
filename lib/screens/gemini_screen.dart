import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _response = '';
  bool _isLoading = false;
  late final GenerativeModel _model;
  bool _apiKeyError = false;
  List<String> _availableModels = [];

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey == null || apiKey == 'YOUR_API_KEY_HERE') {
      _apiKeyError = true;
    } else {
      _model = GenerativeModel(model: 'gemini-flash-latest', apiKey: apiKey);
      _listAvailableModels();
    }
  }

  Future<void> _listAvailableModels() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) return;

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint("--- AVAILABLE GEMINI MODELS ---");
        // ignore: avoid_dynamic_calls
        for (var m in data['models']) {
          // ignore: avoid_dynamic_calls
          debugPrint(
            "${m['name']} - Supported: ${m['supportedGenerationMethods']}",
          );
        }
        debugPrint("-------------------------------");
      } else {
        debugPrint(
          "Failed to list models: ${response.statusCode} ${response.body}",
        );
        if (mounted) {
          setState(() {
            _availableModels = ["Error listing models: ${response.statusCode}"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error checking models: $e");
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _apiKeyError) return;

    final prompt = _controller.text;
    setState(() {
      _isLoading = true;
      _response = "Pensando...";
    });

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (mounted) {
        setState(() {
          _response = response.text ?? 'No se recibió respuesta.';
          _isLoading = false;
          _controller.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _response = 'Error: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_apiKeyError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Gemini AI')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Error: Configura tu GEMINI_API_KEY en el archivo .env',
              style: TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _response.isEmpty ? 'Hazme una pregunta...' : _response,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (_availableModels.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Debug: Modelos Disponibles:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey.shade200,
                        height: 150,
                        child: ListView.builder(
                          itemCount: _availableModels.length,
                          itemBuilder: (context, index) => Text(
                            _availableModels[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                _isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        icon: const Icon(Icons.send, color: Colors.deepPurple),
                        iconSize: 30,
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
