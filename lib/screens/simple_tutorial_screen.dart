import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SimpleTutorialScreen extends StatefulWidget {
  const SimpleTutorialScreen({super.key});

  @override
  State<SimpleTutorialScreen> createState() => _SimpleTutorialScreenState();
}

class _SimpleTutorialScreenState extends State<SimpleTutorialScreen> {
  final GlobalKey _buttonKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    // Check if tutorial should be shown after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    // Default is false (not shown yet)
    final bool isTutorialShown =
        prefs.getBool('simple_tutorial_shown') ?? false;

    if (!isTutorialShown) {
      if (mounted) {
        _showTutorial();
      }
    } else {
      debugPrint("Tutorial already shown, skipping.");
    }
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('simple_tutorial_shown', true);
    debugPrint("Tutorial marked as shown in SharedPreferences.");
  }

  Future<void> _resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('simple_tutorial_shown');
    debugPrint("Tutorial status reset.");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tutorial reseteado. Sal y vuelve a entrar para verlo.",
          ),
        ),
      );
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "OMITIR",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        debugPrint("Tutorial finished");
        _markTutorialAsShown();
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
        _markTutorialAsShown();
      },
      onSkip: () {
        debugPrint("Tutorial skipped");
        _markTutorialAsShown();
        return true;
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
    )..show(context: context);
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: _buttonKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Botón Importante",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Este es el único botón que necesitas conocer por ahora.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
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
        title: const Text("Tutorial Simple"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Resetear Tutorial',
            onPressed: _resetTutorial,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          key: _buttonKey,
          onPressed: () {
            // Action for the button
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("¡Botón presionado!")));
          },
          child: const Text("Botón de Acción"),
        ),
      ),
    );
  }
}
