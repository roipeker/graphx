import 'package:graphx/graphx.dart';

class Ball extends GShape {
  double radius, vx, vy;
  Color? color;

  Ball({
    double? x,
    double? y,
    required this.radius,
    required this.vx,
    required this.vy,
    this.color,
  }) {
    this.x = x;
    this.y = y;
    graphics
        .beginFill(color!.withOpacity(.8))
        .lineStyle(6)
        .drawCircle(0, 0, radius)
        .endFill()
        .beginFill(kColorBlack.withOpacity(.9))
        .drawCircle(0, 0, 3)
        .endFill();
  }
}
