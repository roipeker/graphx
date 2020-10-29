
import 'package:graphx/graphx.dart';

import '../utils/game_mixins.dart';
import 'ship.dart';

class Bullet with GameObject {
  Ship ship;

  Bullet(this.ship) {
    _intiShape();
    acc = GameUtils.rndRange(3, 6);
  }

  void _intiShape() {
    shape = Shape();
    shape.graphics.lineStyle(1, 0xffffff, .8);
    shape.graphics.moveTo(-7, 0);
    shape.graphics.lineTo(0, 0);
  }

  Shape shape;
  double vx, vy, acc = 2;

  calculateAngle() {
    var ang = shape.rotation + pi;
    vx = cos(ang) * acc;
    vy = sin(ang) * acc;
  }

  void update() {
    shape.x += vx;
    shape.y += vy;
    if (world.isOutBounds(shape)) {
      ship.removeBullet(this);
    } else {
      /// check collision with enemies.
      world.bulletHitEnemy(this);
    }
  }

  void dispose() {
    shape?.dispose();
    shape = null;
  }
}
