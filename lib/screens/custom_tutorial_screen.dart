import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CustomTutorialScreen extends StatefulWidget {
  const CustomTutorialScreen({super.key});

  @override
  State<CustomTutorialScreen> createState() => _CustomTutorialScreenState();
}

class _CustomTutorialScreenState extends State<CustomTutorialScreen> {
  late TutorialCoachMark tutorialCoachMark;

  // Keys for targets
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _iconKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.deepPurple, // Custom shadow color
      textSkip: "SALTAR DEMO",
      paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
      onFinish: () => debugPrint("Custom tutorial finished"),
      onClickTarget: (target) => debugPrint('onClickTarget: $target'),
      onSkip: () {
        debugPrint("Custom tutorial skipped");
        return true;
      },
    )..show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // Target 1: Circle Shape (Avatar)
    targets.add(
      TargetFocus(
        identify: "Avatar Target",
        keyTarget: _avatarKey,
        shape: ShapeLightFocus.Circle, // Explicitly Circle
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Forma Circular",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "El tutorial se adapta automáticamente a la forma, o puedes forzar 'ShapeLightFocus.Circle'.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );

    // Target 2: RRect Shape (Card)
    targets.add(
      TargetFocus(
        identify: "Card Target",
        keyTarget: _cardKey,
        shape: ShapeLightFocus.RRect, // Rounded Rectangle
        radius: 20, // Custom radius
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Contenido Personalizado",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Puedes poner cualquier Widget aquí dentro, no solo texto. ¡Incluso botones o imágenes!",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    // Target 3: Icon pulse
    targets.add(
      TargetFocus(
        identify: "Icon Target",
        keyTarget: _iconKey,
        pulseVariation: Tween(begin: 1.0, end: 0.9), // Custom pulse tween
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return const Text(
                "Animaciones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estilos Personalizados"),
        actions: [
          IconButton(
            key: _iconKey,
            icon: const Icon(Icons.favorite, color: Colors.pink),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              key: _avatarKey,
              radius: 40,
              backgroundColor: Colors.teal,
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 40),
            Card(
              key: _cardKey,
              elevation: 4,
              color: const Color.fromARGB(255, 93, 89, 79),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 150,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text("Tarjeta con bordes redondeados"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTutorial,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
