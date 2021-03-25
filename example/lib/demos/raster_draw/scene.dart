import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';

class DrawingScene extends GSprite {
  late GShape drawer;
  late GSprite container;
  late GBitmap captured;

  @override
  void addedToStage() {
    container = GSprite();

    /// we have to draw a rect (transparent), so the bounds are detected when
    /// capturing the snapshot.
    container.graphics
        .beginFill(Colors.red.withOpacity(0))
        .drawRect(0, 0, stage!.stageWidth, stage!.stageHeight)
        .endFill();
    drawer = GShape();
    captured = GBitmap();

    /// Increase the smoothing quality when painting the Image into the
    /// canvas.
    captured.nativePaint.filterQuality = FilterQuality.high;
    addChild(container);
    container.addChild(captured);
    container.addChild(drawer);

    /// keep the stage clipped to the Widget size.
    stage!.maskBounds = true;

    /// shows a border around the stage area (for debug).
    stage!.showBoundsRect = true;

    /// listen to mouse/touch events.
    stage!.onMouseDown.add(_onDown);
  }

  /// basic draw line command from the previous point.
  void _onMove(e) => drawer.graphics.lineTo(mouseX, mouseY);

  void _onRelease(e) async {
    /// get a Texture (Image) from the container GSprite,
    /// at 100% resolution (1x).
    /// This value should match the dpiScale of the screen.
    final texture = await container.createImageTexture(false, 1);

    /// potential bug in GraphX, we should reset the pivot point in the Texture.
    /// so it doesnt goes off-stage if we press/move away the screen area.
    texture.pivotX = texture.pivotY = 0;

    /// refresh the GBitmap with the new texture.
    captured.texture = texture;
    stage!.onMouseMove.remove(_onMove);

    /// after capturing the Texture, we clear the drawn line... to start fresh.
    /// and not overload the CPU.
    drawer.graphics.clear();
  }

  void _onDown(e) {
    ///lineWidth between (1-4),
    /// opacity between 40% - 100%
    drawer.graphics.lineStyle(
      Math.randomRange(1, 4),
      kColorBlack.withOpacity(Math.randomRange(.4, 1)),
    );
    drawer.graphics.moveTo(mouseX, mouseY);
    stage!.onMouseMove.add(_onMove);
    stage!.onMouseUp.addOnce(_onRelease);
  }
}
