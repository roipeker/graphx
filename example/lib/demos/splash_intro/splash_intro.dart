/// copyright roipeker 2020
///
/// web demo:
/// https://roi-graphx-splash.surge.sh
///
/// source code (gists):
/// https://gist.github.com/roipeker/37374272d15539aa60c2bdc39001a035
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene/splash_scene.dart';

class SplashIntroMain extends StatelessWidget {
  const SplashIntroMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      /// paint the scene in front of the child widget.
      builder: () => SceneController(
        front: SplashScene(),
        config: SceneConfig.autoRender,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "I'm a flutter widget.",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            const FlutterLogo(size: 120),
            const SizedBox(height: 24),
            MPSBuilder<bool>(
              topics: const [DemoEvents.run],
              mps: mps,
              builder: (ctx, event, _) => IgnorePointer(
                ignoring: event.data ?? false,
                // ignoring: false,
                child: TextButton(
                  child: const Text('Run animation'),
                  onPressed: () => mps.emit(DemoEvents.reset),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       'path animations',
    //       style: TextStyle(color: Colors.black26),
    //     ),
    //     backgroundColor: Colors.black12,
    //     elevation: 0,
    //   ),
    //   body: SceneBuilderWidget(
    //     /// paint the scene in front of the child widget.
    //     builder: () => SceneController(
    //       front: SplashScene(),
    //       config: SceneConfig.autoRender,
    //     ),
    //     child: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(
    //             "I'm a flutter widget.",
    //             style: Theme.of(context).textTheme.headlineMedium,
    //           ),
    //           const SizedBox(height: 24),
    //           const FlutterLogo(size: 120),
    //           const SizedBox(height: 24),
    //           MPSBuilder<bool>(
    //             topics: const [DemoEvents.run],
    //             mps: mps,
    //             builder: (ctx, event, _) => IgnorePointer(
    //               ignoring: event.data ?? false,
    //               // ignoring: false,
    //               child: TextButton(
    //                 child: const Text('Run animation'),
    //                 onPressed: () => mps.emit(DemoEvents.reset),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
