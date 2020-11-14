import 'dart:ui';

import '../../graphx.dart';

mixin RenderUtilMixin {
  Picture createPicture([void Function(Canvas) prePaintCallback]) {
    final r = PictureRecorder();
    final c = Canvas(r);
    prePaintCallback?.call(c);
    return r.endRecording();
  }

  void paint(Canvas canvas);
  GxRect getBounds();

  Future<GTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    final img = await createImage(adjustOffset, resolution);
    return GTexture.fromImage(img, resolution);
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
    picture?.dispose();
    return output;
  }
}
