import 'dart:ui';

import 'package:flutter/rendering.dart';
import '../../graphx.dart';

/// Custom Clipper that uses [Graphics] API instead of [Path].
/// For ClipPath() Widget.
abstract class GraphicsClipper extends CustomClipper<Path> {
  bool reClip = false;
  double x = 0,
      y = 0,
      rotation = 0,
      scaleX = 1,
      scaleY = 1,
      pivotX = 0,
      pivotY = 0,
      skewX = 0,
      skewY = 0;

  @override
  Path getClip(Size size) {
    final g = Graphics();
    g.beginFill(kColorBlack);
    draw(g, size);
    return applyTransform(g.getPaths());
  }

  /// As a DisplayObject, all transformation properties can be applied
  /// to the Clipping Path.
  Path applyTransform(Path p) {
    var hasTransform = x != 0 ||
        y != 0 ||
        scaleX != 1 ||
        scaleY != 1 ||
        skewX != 1 ||
        skewY != 1 ||
        pivotX != 1 ||
        pivotY != 1;
    if (!hasTransform) return p;
    final m = Pool.getMatrix();
    m.setTransform(
        x, y, pivotX, pivotY, scaleX, scaleY, skewX, skewY, rotation);
    final result = p.transform(m.toNative().storage);
    Pool.putMatrix(m);
    return result;
  }

  /// Subclasses must implement this method and use the Graphics draw
  /// commands to generate the output Path.
  void draw(Graphics g, Size size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => reClip;
}
