import 'package:flutter/material.dart';

import '../base_demo_widget.dart';
import 'altitude_indicator_main.dart';

class AltitudeIndicatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altitud indicator',
      themeMode: ThemeMode.dark,
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: MyChartPage(),
//      home: ChartDemo(),
//      home: AudioVisualDemo(),
//      home: SimpleGameDemo(),
      home: Scaffold(
        backgroundColor: Color(0xff1C1F23),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Artificial Horizon',
                style: TextStyle(fontSize: 24, color: Colors.white70),
              ),
              SizedBox(height: 4),
              Text(
                'HELICOPTER',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.4),
              ),
              SizedBox(height: 14),
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black45,
                ),
                clipBehavior: Clip.hardEdge,
                child: DemoSceneTester(
                  backScene: DemoAltitudIndicatorMain(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
