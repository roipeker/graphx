import 'package:flutter/material.dart';

import 'demo_widgets/chart_demo.dart';
import 'demos/base_demo_widget.dart';
import 'demos/juggler_demos/juggler_demo_main.dart';
import 'demos/simple_game/simple_game_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: MyChartPage(),
      // home: ChartDemo(),
//      home: AudioVisualDemo(),
     home: SimpleGameDemo(),
//       home: Scaffold(
//         body: DemoSceneTester(
// // //          backScene: TestSVGMain(),
// // //          backScene: DemoParticlesMain(),
// // //          backScene: DemoParticlesMain(),
// // //          backScene: DemoAltitudIndicatorMain(),
//           backScene: JugglerDemoMain(),
        // ),
      // ),
    );
  }
}
