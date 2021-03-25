import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'assets.dart';

class HeartScene extends GSprite {
  HeartScene({this.key});

  double get h => stage!.stageHeight;

  double get w => stage!.stageWidth;
  SvgData? svg;
  final GlobalKey? key;

  @override
  Future<void> addedToStage() async {
    await loadSvg();
    mps.on('like', _heartRain);
    super.addedToStage();
  }

  void _heartRain() {
    final _grect = ContextUtils.getRenderObjectBounds(key!.currentContext!)!;
    var isUp = _grect.y < h / 2;
    var maxDuration = 0.0;
    List.generate(
      30,
      (index) {
        GSvgShape svgShape;
        svgShape = GSvgShape(svg);
        svgShape.alignPivot(Alignment.bottomCenter);

        svgShape.y = _grect.y + _grect.height / 2;
        svgShape.x = _grect.x + _grect.width / 2;
        svgShape.rotation = Math.randomRange(-Math.PI / 7, Math.PI / 7);
        svgShape.scale = Math.randomRange(1, 2);
        svgShape.alpha = Math.randomRange(.6, 1.0);
        addChild(svgShape);
        var duration = Math.randomRange(2, 5);
        if (duration > maxDuration) {
          maxDuration = duration;
        }
        svgShape.colorize = Color.lerp(
          Colors.red,
          Colors.black,
          Math.randomRange(0, .3),
        );
        svgShape.tween(
          duration: duration,
          y: !isUp ? -50 : h + 50,
          scale: Math.randomRange(.1, .5),
          ease: GEase.easeInOut,
          // colorize: Color.lerp(Colors.red, Colors.blue, .8),
          onComplete: () {
            svgShape.removeFromParent(true);
          },
        );
        svgShape.tween(
          duration: duration * .5,
          x: Math.randomRange(0, w),
          overwrite: 0,
        );
      },
    );
    GTween.delayedCall(maxDuration, () {
      mps.emit('animfinish');
    });
  }

  Future<void> loadSvg() async {
    svg = await SvgUtils.svgDataFromString(SvgAssets.HEART);
  }
}
