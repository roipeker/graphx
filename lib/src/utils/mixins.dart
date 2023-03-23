import 'dart:ui';

import '../../graphx.dart';

/// A mixin that provides masking functionality for rendering.
///
mixin DisplayMasking {
  /// The rectangular area of the mask.
  GRect? maskRect;

  /// The corner radius of the mask.
  double? maskRectCornerRadius;

  /// Whether the mask is inverted or not.
  bool maskRectInverted = false;

  /// Applies the current mask to the provided [Canvas].
  ///
  /// Direct scissor rect masking, more optimized than using
  /// `object.mask = DisplayObject`.
  ///
  /// You can assign the corners of the `GRect`. Works on flutter web html
  /// target.
  ///
  /// For example:
  ///
  /// `myObject.maskRect = GRect(10, 10, 30, 30)..corners.allTo(4);`
  ///
  /// Will mask the object at the specified rectangle, and use a corner radius
  /// of 4 points on every corner. By default [GRect] has no corners, so is only
  /// implemented to make use of [RRect] clipping.
  ///
  void $applyMaskRect(Canvas? canvas) {
    if (maskRect!.hasCorners) {
      canvas!.clipRRect(
        maskRect!.toRoundNative(),
      );
    } else {
      canvas!.clipRect(
        maskRect!.toNative(),
        clipOp: maskRectInverted ? ClipOp.difference : ClipOp.intersect,
      );
    }
  }
}

/// A mixin that provides utility methods for rendering.
///
mixin RenderUtilMixin {
  /// Creates an [Image] object from the rendered image of the object
  /// asynchronously. You can optionally provide a [resolution] value, which
  /// defaults to 1.
  Future<Image> createImage([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    var rect = getBounds();
    if (resolution != 1) {
      rect *= resolution;
    }
    final needsAdjust =
        (rect.x != 0 || rect.y != 0) && adjustOffset || resolution != 1;
    final picture = createPicture(
      !needsAdjust
          ? null
          : (canvas) {
              if (adjustOffset) {
                canvas.translate(-rect.left, -rect.top);
              }
              if (resolution != 1) {
                canvas.scale(resolution);
              }
            },
    );
    final width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = await picture.toImage(width, height);
    picture.dispose();
    return output;
  }

  /// Creates an [Image] object from the rendered image of the object
  /// synchronously. You can optionally provide a [resolution] value, which
  /// defaults to 1.
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

  /// Creates a [GTexture] object from the rendered image of the object
  /// asynchronously. You can optionally provide a [resolution] value, which
  /// defaults to 1.
  Future<GTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    final img = await createImage(adjustOffset, resolution);
    return GTexture.fromImage(img, resolution);
  }

  /// Creates a [GTexture] object from the rendered image of the object
  /// synchronously. You can optionally provide a [resolution] value, which
  /// defaults to 1.
  GTexture createImageTextureSync([
    bool adjustOffset = true,
    double resolution = 1,
  ]) {
    return GTexture.fromImage(
      createImageSync(adjustOffset, resolution),
      resolution,
    );
  }

  /// Creates a [Picture] object and returns it. You can optionally provide a
  /// [prePaintCallback] function that is called before the picture is painted.
  Picture createPicture([void Function(Canvas)? prePaintCallback]) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    prePaintCallback?.call(canvas);
    return recorder.endRecording();
  }

  /// Returns the bounds of the object as a [GRect].
  GRect getBounds();

  /// Renders the object on the provided [Canvas].
  void paint(Canvas canvas);
}
