import 'package:flutter/rendering.dart';

import '../../graphx.dart';

/// Custom Clipper that uses [Graphics] API instead of [Path].
/// For [ClipPath] Widget.
///
abstract class GraphicsClipper extends CustomClipper<Path> {
  /// If true, this clipper will be re-clipped on subsequent frames.
  bool reClip = false;

  /// The x position of the [GDisplayObject].
  double x = 0;

  /// The y position of the [GDisplayObject].
  double y = 0;

  /// The rotation of the [GDisplayObject] in radians.
  double rotation = 0;

  /// The horizontal scale factor of the [GDisplayObject].
  double scaleX = 1;

  /// The vertical scale factor of the [GDisplayObject].
  double scaleY = 1;

  /// The x pivot point of the [GDisplayObject].
  double pivotX = 0;

  /// The y pivot point of the [GDisplayObject].
  double pivotY = 0;

  /// The horizontal skew angle in radians.
  double skewX = 0;

  /// The vertical skew angle in radians.
  double skewY = 0;

  /// Applies the transform properties to the clipping path.
  Path applyTransform(Path path) {
    var hasTransform = x != 0 ||
        y != 0 ||
        scaleX != 1 ||
        scaleY != 1 ||
        skewX != 1 ||
        skewY != 1 ||
        pivotX != 1 ||
        pivotY != 1;
    if (!hasTransform) {
      return path;
    }
    final m = Pool.getMatrix();
    m.setTransform(
        x, y, pivotX, pivotY, scaleX, scaleY, skewX, skewY, rotation);
    final result = path.transform(m.toNative().storage);
    Pool.putMatrix(m);
    return result;
  }

  /// Subclasses must implement this method and use the [Graphics] draw
  /// commands to generate the output [Path].
  void draw(Graphics g, Size size);

  @override
  Path getClip(Size size) {
    final g = Graphics();
    g.beginFill(kColorBlack);
    draw(g, size);
    return applyTransform(g.getPaths());
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return reClip;
  }
}
