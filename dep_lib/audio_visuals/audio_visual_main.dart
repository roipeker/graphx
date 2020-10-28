import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphx/demos/audio_visuals/audio_player.dart';
import 'package:graphx/demos/audio_visuals/model.dart';
import 'package:graphx/graphx/display/shape.dart';
import 'package:graphx/graphx/display/sprite.dart';
import 'package:graphx/graphx/display/static_text.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/scene_painter.dart';
import 'package:graphx/graphx/utils/assets_loader.dart';

class AudioVisualMain extends RootScene {
  WaveformData model;

  Player player = Player();

  @override
  void init() {
    super.init();
    owner.core.config.useKeyboard = true;
    owner.core.config.useTicker = true;
    owner.needsRepaint = true;
    _loadData();
  }

  Future<void> _loadData() async {
//    var jsonData = await AssetLoader.loadJson('assets/sharona.json');
//    var jsonData = await AssetLoader.loadJson('assets/pumpit.json');
    var jsonData = await AssetLoader.loadJson('assets/pumpit-s.json');
    model = WaveformData.fromJson(jsonData);
    model.scaleData();
//    renderModel();
    await player.load();

    player.positionStream.listen((event) {
      double p = event.inMilliseconds / player.duration.inMilliseconds;
      renderPosition(p);
    });
//    print("Data is: $model");
  }

  void onEnterFrame() {
    displayerLeft.update();
    displayerRight.update();
//    graph1.scaleY += (targetP1 - graph1.scaleY) / 1.5;
//    graph2.scaleY += (targetP2 - graph2.scaleY) / 1.5;
  }

  double targetP1 = 0;
  double targetP2 = 0;

  void renderPosition(double t) {
    final index = model.getIndex(t);
    displayerLeft.minY = model.chan1_min[index];
    displayerLeft.maxY = model.chan1_max[index];

    displayerRight.minY = model.chan2_min[index];
    displayerRight.maxY = model.chan2_max[index];

//    var value1 = model.getPositionUp(t);
//    var value2 = model.getPositionDown(t);
//    targetP1 = value1;
//    targetP2 = value2;
//    graph1.scaleY = -value1;
//    graph2.scaleY = -value2;
//    stage.scene.requestRepaint();
  }

//  var graph1 = Shape();
//  var graph2 = Shape();

  var displayerLeft = Displayer();
  var displayerRight = Displayer();

  @override
  void ready() {
    super.ready();
    stage.keyboard.onDown.add((e) {
      if (stage.keyboard.isPressed(LogicalKeyboardKey.keyA)) {
        player.stop();
      }
    });

    displayerLeft.x = 100;
    displayerRight.x = stage.stageWidth - 100;
    displayerRight.y = displayerLeft.y = stage.stageHeight / 2;
    addChild(displayerLeft);
    addChild(displayerRight);

//    graph1.graphics.beginFill(0xff0000);
//    graph1.graphics.drawRect(0, 0, 100, 200);
//    graph1.graphics.endFill();
//    graph1.alignPivot(Alignment.bottomCenter);
//    graph1.x = stage.stageWidth / 2;
//    graph1.y = stage.stageHeight / 2;
//
//    graph2.graphics.beginFill(0x00ff00);
//    graph2.graphics.drawRect(0, 0, 100, 200);
//    graph2.graphics.endFill();
//    graph2.alignPivot(Alignment.bottomCenter);
//    graph2.x = stage.stageWidth / 2;
//    graph2.y = stage.stageHeight / 2;
//
//    addChild(graph1);
//    addChild(graph2);

//    stage.scene.core.resumeTicker();
    StaticText.defaultTextStyle = StaticText.getStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    );

    stage.scene.core.resumeTicker();
    stage.onEnterFrame.add(onEnterFrame);

    /// sample data.
//    stage.scene.core.isTicking
//    drawTimeline();
  }

  var secondPixels = 30.0;

  void drawTimeline() {
    var shape = Shape();
    addChild(shape);

    var maxSeconds = 40;
    final g = shape.graphics;
    g.lineStyle(0, 0x0, 1);
    var h = stage.stageHeight;
    for (var i = 0; i < maxSeconds; ++i) {
      double px = i * secondPixels;
      g.moveTo(px, h - 20);
      g.lineTo(px, h);

      g.moveTo(px, 0);
      g.lineTo(px, 20);
      var tf = addSecondLabel(i);
      tf.x = px;
      tf.y = h - 25;
      addChild(tf);
    }
  }

  StaticText addSecondLabel(int idx) {
    final textStr = '00:' + ('$idx').padLeft(2, '0');
    var tf = StaticText(text: textStr);
    tf.validate();
    tf.alignPivot(Alignment.bottomCenter);
    return tf;
  }

  void renderModel() {
    double second = 30.0;
    List<double> sub = model.getFrames(
      startFrame: 0,
      endFrame: (model.framesPerSecond * (second)).toInt(),
    );
    var dat = (sub.length / 2) / model.framesPerSecond;
    print("Seconds::$dat");
    print("Sub data: ${sub.length}"); // 240

    /// 2 seconds.
    var graph = Shape();
    addChild(graph);

    final g = graph.graphics;
    g.lineStyle(2, Colors.red.value, .75);
    var tx = second * secondPixels;
    g.moveTo(tx, 0);
    g.lineTo(tx, stage.stageHeight);

    var middle = stage.stageHeight / 2;
    var amp = stage.stageHeight / 2.5;
    g.lineStyle(1, Colors.lightBlue.value, 1);
    g.moveTo(0, middle);

    /// draw middle.
    var minPoints = <GxPoint>[];

    var j = 0;
    for (var i = 0; i < sub.length; i += 2) {
      double p1 = sub[i];
      double p2 = sub[i + 1];

      var rx = j / model.framesPerSecond;
      var px = rx * secondPixels;
//      secondPixels;
//      print(model.framesPerSecond);
//      print(rx);
      var py = middle + amp * p1;
      var py2 = middle + amp * p2;
      g.lineTo(px, py);
      minPoints.add(GxPoint(px, py2));
      ++j;
//      double px = i.toDouble();
//      if (i % 2 != 0) {
//        var py = middle - amp * percent;
//        g.lineTo(px, py);
//      } else {
//        var py = middle - amp * percent;
//
//        /// max points.
//        minPoints.add(GxPoint(px, py));
//      }
    }

//    g.lineTo(stage.stageWidth, middle);
    final rev = minPoints.reversed;
    for (var p in rev) {
      g.lineTo(p.x, p.y);
    }
  }
}

class Displayer extends Sprite {
  Shape _high;
  Shape _low;
  double w = 100;
  double h = 300;

  Displayer() {
    onAddedToStage.addOnce(init);
  }

  void init() {
    _high = createShape(0xff0000);
    _low = createShape(0x0000ff);
  }

  Shape createShape(int color) {
    var sh = Shape();
    addChild(sh);
    sh.graphics.beginFill(color).drawRect(0, 0, w, h).endFill();
    sh.alignPivot(Alignment.bottomCenter);
    return sh;
  }

  double maxY = 0;
  double minY = 0;

  void update() {
    _high.scaleY += (maxY - _high.scaleY) / 2;
    _low.scaleY += (minY - _low.scaleY) / 2;
  }
}
