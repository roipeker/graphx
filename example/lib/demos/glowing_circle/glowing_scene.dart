import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';

extension MyGlowingExt on Widget {
  Widget glowing({
    Color color = Colors.blue,
    double duration = .5,
    double startScale = 0,
    double endScale = 1,
    double endScaleInterval = 0.8,
    double circleInterval = .2,
    double replayDelay = .2,
    Function(Graphics graphics, Size size)? graphicBuilder,
  }) {
    return SceneBuilderWidget(
        builder: () => SceneController(
              back: MyGlowingEffect(
                color: color,
                duration: duration,
                startScale: startScale,
                endScale: endScale,
                endScaleInterval: endScaleInterval,
                circleInterval: circleInterval,
                replayDelay: replayDelay,
                graphicBuilder: graphicBuilder,
              ),
            ),
        child: this);
  }
}

class MyGlowingEffect extends GSprite {
  final Color color;
  final double duration, circleInterval, replayDelay;
  final double startScale, endScale, endScaleInterval;
  final Function(Graphics graphics, Size size)? graphicBuilder;

  MyGlowingEffect({
    this.color = const Color(0x8842A5F5),
    this.duration = 1,
    this.circleInterval = .25,
    this.replayDelay = 0.5,
    this.startScale = 0,
    this.endScale = 1,
    this.endScaleInterval = .2,
    this.graphicBuilder,
  });

  static void drawCircle(Graphics g, Size size, Color color) {
    g.clear().beginFill(color).drawCircle(0, 0, size.height / 2).endFill();
  }

  @override
  void addedToStage() {
    final circles = List<GShape>.generate(4, (index) {
      var shape = GShape();
      addChild(shape);
      final size = Size(stage!.stageWidth, stage!.stageHeight);
      shape.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
      if (graphicBuilder == null) {
        drawCircle(shape.graphics, size, color);
      } else {
        graphicBuilder?.call(shape.graphics, size);
      }
      return shape;
      // return shape
    });
    void _tweenAll() {
      var nextDelay = 0.0;
      for (var i = 0; i < circles.length; ++i) {
        circles[i].setProps(scale: startScale, alpha: 1);
        circles[i].tween(
          duration: duration,
          delay: i * circleInterval,
          alpha: 0,
          scale: endScale + i * endScaleInterval,
        );
        nextDelay = duration + i * circleInterval;
      }
      GTween.delayedCall(nextDelay + replayDelay, _tweenAll);
    }

    _tweenAll();
  }
}
