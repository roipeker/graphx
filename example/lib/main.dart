import 'package:flutter/material.dart';

import 'demo_widgets/chart_demo.dart';
import 'demos/base_demo_widget.dart';
import 'demos/juggler_demos/juggler_demo_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraphX Samples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: MyChartPage(),
//      home: ChartDemo(),
//      home: AudioVisualDemo(),
//     home: SimpleGameDemo(),
      home: DemoEntry(),
    );
  }
}

class DemoEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphX demos'),
      ),
      body: DemoSceneTester(
        // //          backScene: TestSVGMain(),
        // //          backScene: DemoParticlesMain(),
        // //          backScene: DemoParticlesMain(),
        // //          backScene: DemoAltitudIndicatorMain(),
        backScene: JugglerDemoMain(),
      ),
    );
  }
}
