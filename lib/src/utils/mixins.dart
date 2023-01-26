import 'dart:ui';

import '../../graphx.dart';

mixin RenderUtilMixin {
  Picture createPicture([void Function(Canvas)? prePaintCallback]) {
    final r = PictureRecorder();
    final c = Canvas(r);
    prePaintCallback?.call(c);
    return r.endRecording();
  }

  void paint(Canvas canvas);

  GRect getBounds();

  GTexture createImageTextureSync([
    bool adjustOffset = true,
    double resolution = 1,
  ]) {
    return GTexture.fromImage(
      createImageSync(adjustOffset, resolution),
      resolution,
    );
  }

  Future<GTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    final img = await createImage(adjustOffset, resolution);
    return GTexture.fromImage(img, resolution);
  }

  Image createImageSync([
    bool adjustOffset = true,
    double resolution = 1,
  ]) {
    var rect = getBounds();
    if (resolution != 1) {
      rect *= resolution;
    }
    final needsAdjust =
        (rect.x != 0 || rect.y != 0) && adjustOffset || resolution != 1;
    final picture = createPicture(
      !needsAdjust
          ? null
          : (c) {
              if (adjustOffset) {
                c.translate(-rect.left, -rect.top);
              }
              if (resolution != 1) {
                c.scale(resolution);
              }
            },
    );
    final width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = picture.toImageSync(width, height);
    picture.dispose();
    return output;
  }

  Future<Image> createImage([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    var rect = getBounds();
    if (resolution != 1) {
      rect *= resolution;
//      rect = GxRect(
//        rect.x * resolution,
//        rect.y * resolution,
//        rect.width * resolution,
//        rect.height * resolution,
//      );
    }
    final needsAdjust =
        (rect.x != 0 || rect.y != 0) && adjustOffset || resolution != 1;
    final picture = createPicture(
      !needsAdjust
          ? null
          : (c) {
              if (adjustOffset) {
                c.translate(-rect.left, -rect.top);
              }
              if (resolution != 1) {
                c.scale(resolution);
              }
            },
    );

    final width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = await picture.toImage(width, height);
    picture.dispose();
    return output;
  }
}

mixin DisplayMasking {
  GRect? maskRect;
  double? maskRectCornerRadius;
  bool maskRectInverted = false;

  /// Direct scissor rect masking, more optimized than using
  /// `object.mask=DisplayObject`.
  /// You can assign the corners of the `GxRect`.
  /// Works on flutter web html target.
  ///
  /// For example:
  ///
  /// `myObject.maskRect = GxRect( 10, 10, 30, 30)..corners.allTo(4);`
  ///
  /// Will mask the object at the specified rectangle, and use a corner
  /// radius of 4 points on every corner.
  ///
  /// By default GxRect has no corners, so is only implemented to make use
  /// of `RRect` clipping.
  ///
  void $applyMaskRect(Canvas? c) {
    if (maskRect!.hasCorners) {
      c!.clipRRect(
        maskRect!.toRoundNative(),
        doAntiAlias: true,
      );
    } else {
      c!.clipRect(
        maskRect!.toNative(),
        clipOp: maskRectInverted ? ClipOp.difference : ClipOp.intersect,
        doAntiAlias: true,
      );
    }
  }
}
