import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class TestIcons extends Sprite {
  TestIcons() {
    _init();
  }

  void _init() {
    final iconsContainer = Sprite();
    addChild(iconsContainer);
    iconsContainer.x = 100;
    iconsContainer.y = 100;

    final icon1 = GxIcon(Icons.account_circle, Colors.purple.value, 32.0);
    iconsContainer.addChild(icon1);

    final icon2 = GxIcon(Icons.email, 0xffffff, 18.0);
    iconsContainer.addChild(icon2);
    icon2.x = 32;
    icon2.alignPivot();

    /// can add shadow to icons.
    icon2.setShadow(Shadow(
        color: Colors.purple.withOpacity(.6),
        offset: Offset(1, 2),
        blurRadius: 8.0));

    /// You can go low level and add a Paint to your icon ...
    final icon3 = GxIcon(Icons.add_location, 0x0, 18.0);
    iconsContainer.addChild(icon3);
    icon3.alignPivot();
    icon3.x = 32;
    icon3.y = 32;

//    final linePaint = Paint();
//    linePaint.strokeWidth = 0;
//    linePaint.style = PaintingStyle.stroke;
//    linePaint.color = Colors.blue;
//    icon3.setPaint(linePaint);

    final gradientPaint = Paint();
    gradientPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.red, Colors.blue],
    ).createShader(icon3.bounds.toNative());
    // take the bounding box from the icon.
    // GraphX has a nifty method to check bounding boxes.
//    icon3.$debugBounds = true;

    icon3.setPaint(gradientPaint);
    iconsContainer.tween(duration: 2, scale: 2);
  }
}
