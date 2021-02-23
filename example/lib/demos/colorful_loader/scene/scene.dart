/// made by roipeker 2020.

/// original video sample:
/// https://media.giphy.com/media/n7q53cJN2UuSu7EmN2/source.mp4

/// graphx demo version:
/// https://media.giphy.com/media/pKXa68pcv2H1dSjxYX/source.mp4
import 'package:graphx/graphx.dart';

import 'bubble_preloader.dart';

/// just a wrapper scene class.
class ColorLoaderScene extends GSprite {
  BubblePreloader loader;

  @override
  void addedToStage() {
    // we dont need touch interaction in this scene.
    mouseChildren = false;
    mouseEnabled = false;

    loader = BubblePreloader(w: 385, h: 14);
    addChild(loader);
    stage.onResized.add(_handleStageResize);
  }

  void _handleStageResize() {
    loader.x = (stage.stageWidth - loader.w) / 2;
    loader.y = (stage.stageHeight - loader.h) / 2;
  }
}
