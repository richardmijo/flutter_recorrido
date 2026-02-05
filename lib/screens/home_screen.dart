import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial Coach Mark Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/tutorial');
              },
              child: const Text('Iniciar Tutorial Completo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/simple-tutorial');
              },
              child: const Text('Iniciar Tutorial Simple (Una sola vez)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade100,
              ),
              onPressed: () {
                context.push('/custom-tutorial');
              },
              child: const Text('Ver Personalizaciones (Colores, Formas)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.push('/stateless-tutorial');
              },
              child: const Text('Versión Stateless Widget'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
              ),
              onPressed: () {
                context.push('/gemini');
              },
              child: const Text('Chat con Gemini AI'),
            ),
          ],
        ),
      ),
    );
  }
}
