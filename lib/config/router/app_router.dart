import 'package:go_router/go_router.dart';
import '../../screens/home_screen.dart';
import '../../screens/tutorial_screen.dart';
import '../../screens/simple_tutorial_screen.dart';
import '../../screens/custom_tutorial_screen.dart';
import '../../screens/stateless_tutorial_screen.dart';
import '../../screens/gemini_screen.dart';
import '../../screens/firebase_vertex_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/tutorial',
      builder: (context, state) => const TutorialScreen(),
    ),
    GoRoute(
      path: '/simple-tutorial',
      builder: (context, state) => const SimpleTutorialScreen(),
    ),
    GoRoute(
      path: '/custom-tutorial',
      builder: (context, state) => const CustomTutorialScreen(),
    ),
    GoRoute(
      path: '/stateless-tutorial',
      builder: (context, state) => StatelessTutorialScreen(),
    ),
    GoRoute(path: '/gemini', builder: (context, state) => const GeminiScreen()),
    GoRoute(
      path: '/firebase-vertex',
      builder: (context, state) => const FirebaseVertexScreen(),
    ),
  ],
);
