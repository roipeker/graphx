import 'dart:ui';

import '../../graphx.dart';



mixin RenderUtilMixin {
  Picture createPicture([void Function(Canvas) prepaintCallback]) {
    final r = PictureRecorder();
    final c = Canvas(r);
    prepaintCallback?.call(c);
    this.paint(c);
    return r.endRecording();
  }

  void paint(Canvas canvas);
  GxRect getBounds();

  Future<GxTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    final img = await createImage(adjustOffset, resolution);
    return GxTexture(img);
  }

  Future<Image> createImage([
    bool adjustOffset = true,
    double resolution = 1,
  ]) async {
    GxRect rect = getBounds();
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
          : (Canvas c) {
              if (adjustOffset) {
                c.translate(-rect.left, -rect.top);
              }
              if (resolution != 1) {
                c.scale(resolution);
              }
            },
    );

    final int width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final int height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = await picture.toImage(width, height);
    picture?.dispose();
    return output;
  }
}
