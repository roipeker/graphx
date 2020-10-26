import 'dart:ui';

import 'package:graphx/graphx/display/display_object.dart';
import 'package:graphx/graphx/geom/gxmatrix.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/textures/base_texture.dart';
import 'package:graphx/graphx/utils/matrix_utils.dart';

class Bitmap extends DisplayObject {
  static GxMatrix _sHelperMatrix = GxMatrix();
  static GxPoint _sHelperPoint = GxPoint();

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (Bitmap)$msg';
  }

  GxTexture _texture;

  GxTexture get texture => _texture;

  set texture(GxTexture value) {
    if (_texture == value) return;
    _texture = value;
    if (_texture != null) {
      pivotX = -_texture.anchorX;
      pivotY = -_texture.anchorY;
    }
    requiresRedraw();
  }

  Bitmap([GxTexture texture]) {
    this.texture = texture;
  }

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (texture != null) {
//      GxRect rect = texture.sourceRect;
      var r = texture.normalizedRect;
//      print(texture.sourceRect);
      out = MatrixUtils.getTransformedBoundsRect(
        matrix,
        r,
        out,
      );
    } else {
      matrix.transformCoords(0, 0, _sHelperPoint);
      out.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    }
    return out;
  }

  final _paint = Paint();
  Paint get nativePaint => _paint;

  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  @override
  void paint(Canvas canvas) {
    if (texture == null) return;
    super.paint(canvas);
  }

  @override
  void $applyPaint() {
    final useAtlas = texture.isSubTexture;
    if (useAtlas) {
      final dest = Rect.fromLTWH(
        x,
        y,
        texture.sourceRect.width / scale,
        texture.sourceRect.height / scale,
      );
      $canvas.drawImageRect(
        texture.source,
        texture.sourceRect.toNative(),
        dest,
        _paint,
      );
    } else {
      if (texture.scale != 1) {
        $canvas.save();
        $canvas.scale(1 / texture.scale);
        $canvas.drawImage(texture.source, Offset.zero, _paint);
        $canvas.restore();
      } else {
        $canvas.drawImage(texture.source, Offset.zero, _paint);
      }
    }
  }
}
