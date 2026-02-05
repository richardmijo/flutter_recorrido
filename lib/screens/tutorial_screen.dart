import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  // Keys for targets
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyFab = GlobalKey();

  @override
  void initState() {
    super.initState();
    _createTargets();
    // Show tutorial after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      textSkip: "OMITIR",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        debugPrint("Tutorial finished");
      },
      onClickTarget: (target) {
        debugPrint('onClickTarget: $target');
      },
      onSkip: () {
        debugPrint("Tutorial skipped");
        return true;
      },
      onClickOverlay: (target) {
        debugPrint('onClickOverlay: $target');
      },
    )..show(context: context);
  }

  void _createTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton1,
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
                    "Primer Botón",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Este es el primer elemento importante que debes notar.",
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

    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton2,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Segundo Botón",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Aquí hay otra funcionalidad interesante.",
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

    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyButton3,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Tercer Botón",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Este botón hace algo diferente.",
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

    targets.add(
      TargetFocus(
        identify: "Target FAB",
        keyTarget: keyFab,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Acción Principal",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Este botón flotante es la acción principal de la pantalla.",
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutorial Screen"),
        actions: [
          IconButton(
            key: keyButton3,
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              key: keyButton1,
              color: Colors.blue,
              height: 50,
              width: 150,
              child: const Center(
                child: Text(
                  "Elemento 1",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  key: keyButton2,
                  color: Colors.green,
                  height: 50,
                  width: 150,
                  child: const Center(
                    child: Text(
                      "Elemento 2",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: keyFab,
        onPressed: () {
          _showTutorial();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
