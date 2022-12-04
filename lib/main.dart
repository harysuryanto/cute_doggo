import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:interactive_desktop_widget/avatar_scene.dart';
import 'package:interactive_desktop_widget/cached_future_builder.dart';
import 'package:rive/rive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  doWhenWindowReady(() {
    const windowSize = Size(300, 200);
    appWindow.size = windowSize;
    appWindow.minSize = windowSize;
    appWindow.maxSize = windowSize;
    appWindow.title = 'Cute Doggo';
    appWindow.alignment = Alignment.bottomRight;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cute Doggo',
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
  bool isDraggable = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onPanStart: isDraggable ? (_) => appWindow.startDragging() : null,
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
                    return const CircularProgressIndicator.adaptive();
                  },
                ),
              ),
            ),
            if (isHovered)
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.transparent,
                  child: PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        onTap: () => setState(() {
                          isDraggable = !isDraggable;
                        }),
                        child: isDraggable
                            ? const Text('Disable dragging')
                            : const Text('Enable dragging'),
                      ),
                      PopupMenuItem(
                        onTap: () => appWindow.close(),
                        child: const Text('Close (´•̥ᴥ•̥`U)'),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
