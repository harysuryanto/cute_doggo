import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart' hide MenuItem;
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:interactive_desktop_widget/avatar_scene.dart';
import 'package:interactive_desktop_widget/cached_future_builder.dart';
import 'package:rive/rive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(effect: WindowEffect.transparent);
  runApp(const MyApp());
  doWhenWindowReady(() {
    appWindow.title = 'Interactive Desktop Widget';
    appWindow.alignment = Alignment.bottomRight;
    appWindow.size = const Size(300, 200);
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FluentApp(
      title: 'Interactive Desktop Widget',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onPanStart: (details) => appWindow.startDragging(),
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: CachedFutureBuilder<RiveFile>(
                  future: RiveFile.asset(
                    'assets/images/interactive-ui-doggo.riv',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final artboard = snapshot.data?.mainArtboard;
                      return AvatarScene(artboard);
                    }
                    return const ProgressRing();
                  },
                ),
              ),
            ),
            if (isHovered)
              Positioned(
                top: 0,
                right: 0,
                child: TextButton(
                  onPressed: () => appWindow.close(),
                  child: const Icon(Icons.close_rounded, size: 24),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
