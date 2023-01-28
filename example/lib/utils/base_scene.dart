import 'package:graphx/graphx.dart';

class BaseScene extends GSprite {
  double get sw => stage?.stageWidth ?? 0;
  double get sh => stage?.stageHeight ?? 0;

  BaseScene([GSprite? doc]) {
    doc?.addChild(this);
  }
}
