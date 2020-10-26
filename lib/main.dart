import 'package:flutter/material.dart';
import 'package:graphx/demos/svg_demo/test_svg.dart';

import 'demos/base_demo_widget.dart';
//import 'demos/audio_visuals/audio_visuals_demo.dart';

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
//      home: ChartDemo(),
//      home: AudioVisualDemo(),
//      home: SimpleGameDemo(),
      home: Scaffold(
        body: DemoSceneTester(
          backScene: TestSVGMain(),
        ),
      ),
    );
  }
}
