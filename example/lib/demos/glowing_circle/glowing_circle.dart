/// roipeker 2021
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'glowing_scene.dart';

class GlowingCircleMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('item 1').glowing(
                color: Colors.blue.withOpacity(.5),
                duration: .5,
                replayDelay: .25,
                circleInterval: .25,
                endScaleInterval: 0,
                endScale: 2,
                startScale: .2,
              ),
              Text('item 2').glowing(
                color: Colors.blue.withOpacity(.5),
                duration: 1,
                replayDelay: .5,
                circleInterval: .5,
                endScaleInterval: 0,
                endScale: 4,
                startScale: 0,

                /// custom drawing support. (defaults to `drawCircle()` )
                graphicBuilder: (g, size) {
                  var sh = size.height;
                  g.clear();
                  g.beginFill(Colors.orange.withOpacity(.8));
                  g.drawCircle(0, 0, sh / 2);
                  g.endFill();
                },
              ),
              Text('item 3').glowing(
                color: Colors.blue.withOpacity(.8),
                duration: .4,
                replayDelay: .25,
                circleInterval: .25,
                endScaleInterval: 0,
                endScale: .5,
                startScale: 3,
                graphicBuilder: (Graphics g, Size size) {
                  var sh = size.height;
                  g.clear();
                  g.beginFill(Colors.purple);
                  g.drawStar(0, 0, 6, sh / 2, sh, Math.randomRange(-2, 2));
                  g.endFill();
                },
              ),
              Text('item 4'),
            ],
          ),
        ),
      ),
    );
  }
}
