/// roipeker 2020
///
/// Snowflake effect
/// video: https://media.giphy.com/media/yTNXKR5BHbQKOKpfrS/source.mp4
///
import 'dart:async';

import 'package:graphx/graphx.dart';

class SnowScene extends GSprite {
  int numTextureVariants = 6;
  int numFlakes = 100;
  final List<GTexture?> _textures = [];
  List<Snowflake> flakes = <Snowflake>[];
  late Timer _snowDirectionTimer;

  @override
  Future<void> addedToStage() async {
    await _initTextures();
    _initSnow();
  }

  void _initSnow() {
    mouseEnabled = false;
    mouseChildren = false;
    flakes = List.generate(numFlakes, (index) {
      var texture = Math.randomList(_textures);
      var flake = Snowflake(texture);
      addChild(flake);
      flake.setPosition(
        Math.randomRange(0, stage!.stageWidth),
        Math.randomRange(0, stage!.stageHeight),
      );
      return flake;
    });
    _snowDirectionTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      _snowDirectionTimer = timer;
      _changeSnowDirection();
    });
  }

  @override
  void dispose() {
    _snowDirectionTimer.cancel();
    flakes.clear();
    super.dispose();
  }

  void _changeSnowDirection() {
    /// flip the x velocity direction of each snowflake every 2 seconds.
    for (var flake in flakes) {
      flake.velX *= -1;
    }
  }

  @override
  void update(double delta) {
    super.update(delta);
    for (var flake in flakes) {
      flake.x += flake.velX;
      flake.y += flake.velY;

      /// check the stage bounds (Scaffold::body)
      if (flake.y > stage!.stageHeight) {
        flake.y = -flake.height;
      }
      if (flake.x < -flake.width) {
        flake.x = stage!.stageWidth;
      } else if (flake.x > stage!.stageWidth) {
        flake.x = -flake.width;
      }
    }
  }

  Future<void> _initTextures() async {
    /// load the textures from the assets.
    for (var i = 1; i <= numTextureVariants; ++i) {
      final texture = await ResourceLoader.loadTexture(
        'assets/xmas/flake_$i.png',
        2,
        'flake_$i',
      );
      _textures.add(texture);
    }
  }
}

class Snowflake extends GBitmap {
  static const double minScale = 0.35,
      maxScale = 1.3,
      minVelY = .5,
      maxVelY = 2.5;

  double velY = 0.0, velX = 0.0;

  /// GBitmap requires the Texture in the constructor.
  Snowflake(super.texture) {
    _init();
  }

  void _init() {
    /// randomize the properties of the flake.
    alpha = Math.randomRange(.26, .6);
    velY = Math.randomRange(minVelY, maxVelY);
    velX = Math.randomRange(-.6, .8);
    scale = Math.randomRange(minScale, maxScale);
  }
}
