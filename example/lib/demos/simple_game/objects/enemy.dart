
import 'package:graphx/graphx.dart';

import '../utils/game_mixins.dart';

class BasicEnemy extends Sprite with GameObject {
  Shape _shape;
  double size;
  double velRot;

  double angularDir;
  double angularVel;

  BasicEnemy() {
    initUI();
  }

  void initUI() {
    _shape = Shape();
    addChild(_shape);
    size = GameUtils.rndRange(20, 60);
    velRot = GameUtils.rndRange(.01, .08);
    draw();
  }

  void draw() {
    final g = _shape.graphics;
    g.lineStyle(0, 0xffffff, .8);
    g.drawCircle(0, 0, size / 2);
    g.endFill();
    g.lineStyle(0, 0xffffff, .45);
    g.moveTo(0, 0);
    g.lineTo(size / 2, 0);
    g.endFill();
  }

  void update() {
//    rotation += velRot;
    rotation += angularVel / 20;
    var px = cos(angularDir) * angularVel;
    var py = sin(angularDir) * angularVel;
    x += px;
    y += py;
    if (world.isOutBounds(this, size / 2)) {
      world.removeEnemy(this);
    }
  }

  void kill() {}
}
