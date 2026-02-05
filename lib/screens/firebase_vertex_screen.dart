import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FirebaseVertexScreen extends StatefulWidget {
  const FirebaseVertexScreen({super.key});

  @override
  State<FirebaseVertexScreen> createState() => _FirebaseVertexScreenState();
}

class _FirebaseVertexScreenState extends State<FirebaseVertexScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _response = '';
  bool _isLoading = false;
  late final GenerativeModel _model;
  bool _initError = false;

  @override
  void initState() {
    super.initState();
    try {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash', // Firebase uses this model name too
      );
    } catch (e) {
      debugPrint("Error loading Firebase Vertex AI: $e");
      _initError = true;
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _initError) return;

    final prompt = _controller.text;
    setState(() {
      _isLoading = true;
      _response = "Pensando (Firebase)...";
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
    if (_initError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Firebase Vertex AI')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Error al inicializar Firebase Vertex AI.\n\nAsegúrate de haber agregado el archivo google-services.json en android/app/ y habilitado Vertex AI en la consola.',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Vertex Chat'),
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: MarkdownBody(
                    data: _response.isEmpty
                        ? 'Hazme una pregunta...'
                        : _response,
                  ),
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
                        icon: const Icon(Icons.send, color: Colors.orange),
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
