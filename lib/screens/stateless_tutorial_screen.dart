import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class StatelessTutorialScreen extends StatelessWidget {
  StatelessTutorialScreen({super.key});

  final GlobalKey _iconKey = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  void _showTutorial(BuildContext context) {
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: "IconTarget",
          keyTarget: _iconKey,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return const Text(
                  "Icono Informativo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        TargetFocus(
          identify: "ButtonTarget",
          keyTarget: _buttonKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return const Text(
                  "Botón Principal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: Colors.blueAccent,
      textSkip: "SALTAR",
      paddingFocus: 10,
      opacityShadow: 0.8,
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutorial Stateless"),
        actions: [
          IconButton(
            key: _iconKey,
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // También podríamos disparar un tutorial simple aquí
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "En un Stateless Widget,\nno tenemos 'initState'.\nPor eso, iniciamos el tutorial\nal presionar el botón.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              key: _buttonKey,
              onPressed: () => _showTutorial(context),
              child: const Text("Iniciar Tutorial"),
            ),
          ],
        ),
      ),
    );
  }
}
