import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class PathChartScene extends GSprite {
  @override
  void addedToStage() {
    var colors = [
      // Colors.red,
      // Colors.green,
      Colors.purple,
    ];
    // var colors = [Colors.red];

    var container = GSprite();
    addChild(container);

    for (final c in colors) {
      var section = ChartSection(c);
      container.addChild(section);
      var label = section.label;
      var idx = colors.indexOf(c);
      if (idx == 0) {
        addChild(label);
        label.x = 30;
        label.y = 80 + 20.0 * idx;
      }
    }

    container.x = stage.stageWidth * .8;
    container.y = stage.stageHeight * .5;
    stage.onEnterFrame.add((event) {
      // if (container.width > container.x + 100) {
      //   tw = container.x + 100;
      //   container.width = tw;
      //   container.scaleY = container.scaleX;
      // }
      // container.width += (tw - container.width) / 20;
      // container.scaleY = container.scaleX;
      // scaleR += .01;
      // var s = (Math.sin(scaleR)/2) + .5 ;
      // trace(s);
      // container.scale = .2 + s * 1.5;
    });

    // var chartsPath = Path();

    // graphics.beginFill(Colors.black45);
    // graphics.drawPath(chartsPath);
    // graphics.endFill();
    //
    // graphics.lineStyle(2, Colors.red);
    // graphics.drawPath(chartsPath);
    // graphics.endFill();
  }

// @override
// void update(double delta) {
//   super.update(delta);
// }
}

class ChartSection extends GShape {
  Path myPath = Path();
  int numQuads = 0;

  Color color;
  double lastX = 0.0;

  ChartSection(this.color) {
    // List.generate(19, (index) => addSlot());
  }

  GText label;
  int frameCount = 0;
  double targetX = 0;
  Path maskPath = Path();
  Path outputPath = Path();

  @override
  void addedToStage() {
    maskPath.addRect(GRect(0, 0, 300, 300).toNative());

    label = GText.build(
        text: 'color', color: color, fontSize: 14, fontWeight: FontWeight.bold);
    stage.onEnterFrame.add((event) {
      if (++frameCount % 3 == 0) {
        addSlot();
        pivotX = width;
        // x = maxPos;
        // if (tempW > maxPos) {
        //   targetX =-tempW + maxPos;
        // }
      }
      // x += (targetX - x)/10 ;
      // scaleRatio += .001;
      // scale = 1 + Math.sin(scaleRatio);
    });
  }

  // @override
  // void update(double delta) {
  //   super.update(delta);
  //   addSlot();
  // }

  GRect lastRect = GRect();

  void addSlot() {
    ++numQuads;
    label.text = '$numQuads rects';

    graphics.clear();
    graphics.beginFill(color.withOpacity(.3));
    graphics.lineStyle(2, color);
    graphics.drawPath(outputPath);
    graphics.endFill();

    // graphics.drawPath(myPath);
    // graphics.endFill();
  }
}
