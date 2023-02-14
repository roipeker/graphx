/// roipeker 2020
///
/// custom painting sample.
/// Shows how to create your own DisplayObjects.
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class RunHeroCanvasMain extends StatelessWidget {
  const RunHeroCanvasMain({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SceneBuilderWidget(
          autoSize: true,
          builder: () => SceneController(
            back: RunHeroScene(),
            config: SceneConfig.games,
          ),
        ),
      ),
    );
  }
}

class RunHeroScene extends GSprite {
  late ui.FragmentShader shader;

  Future<void> _init() async {
    GTextureUtils.resolution = 2;
    await ResourceLoader.loadTexture('assets/run_hero/parallax/layer_01.png', 2, 'l1');
    await ResourceLoader.loadTexture('assets/run_hero/parallax/layer_02.png', 2, 'l2');
    await ResourceLoader.loadTexture('assets/run_hero/parallax/layer_03.png', 2, 'l3');
    await ResourceLoader.loadTexture('assets/run_hero/parallax/layer_04.png', 2, 'l4');
    await ResourceLoader.loadTexture('assets/run_hero/parallax/layer_05.png', 2, 'l5');
    await ResourceLoader.loadGif('assets/run_hero/run_outline.gif', cacheId: 'hero');
    await ResourceLoader.loadGif('assets/run_hero/midair_outline.gif', cacheId: 'hero_air');

    // var program = await ui.FragmentProgram.fromAsset('shaders/blur.glsl');
    // shader = program.fragmentShader();
  }

  @override
  Future<void> addedToStage() async {
    stage!.color = const ui.Color.fromARGB(255, 12, 161, 27);
    stage!.maskBounds = true;

    await _init();

    addChild(RunHeroParallaxView());

    stage!.keyboard!.onDown.add((e) {
      if (e.isKey(LogicalKeyboardKey.space)) {
        mps.emit('jump');
      }
    });
    stage!.onMouseDown.add((event) {
      mps.emit('jump');
    });
  }
}

class RunHeroParallaxView extends GDisplayObjectContainer {
  List<GTexture?> layers = [];
  List<Matrix4> matrices = <Matrix4>[];
  List<Paint> paintings = [];

  final jumpY = 0.0.twn;
  int heroFrame = 0;
  GifAtlas? hero;

  final gradientPaint = Paint();
  final heroPaint = Paint();

  RunHeroParallaxView() {
    List.generate(5, (i) {
      layers.add(ResourceLoader.getTexture('l${i + 1}'));
      matrices.add(Matrix4.identity());
      paintings.add(Paint());
    });
    mps.on('jump', _onHeroJump);
    heroState('hero');
  }

  void _onHeroJump() {
    heroState('hero_air');
    jumpY.tween(
      -100,
      duration: .8,
      ease: GEase.easeOut,
      onComplete: () {
        heroState('hero');
        jumpY.tween(
          0,
          duration: .6,
          ease: GEase.bounceOut,
        );
      },
    );
  }

  @override
  void addedToStage() {
    gradientPaint.blendMode = BlendMode.color;
    final gradCenter = Offset(
      stage!.stageWidth / 2,
      stage!.stageHeight / 2,
    );
    final gradMatrix = Matrix4.identity()..scale(0.9);
    gradientPaint.shader = ui.Gradient.radial(
      gradCenter,
      stage!.stageWidth,
      [
        Colors.red.withOpacity(.3),
        Colors.blue.withOpacity(1),
      ],
      [0.1, .9],
      TileMode.clamp,
      gradMatrix.storage,
    );
  }

  void heroState(String id) => hero = ResourceLoader.getGif(id);

  @override
  void $applyPaint(Canvas? canvas) {
    canvas!.save();

    canvas.scale(1 / layers[0]!.scale!);

    matrices[0].translate(-.5);
    matrices[1].translate(-.8);
    matrices[2].translate(-3.0);
    matrices[3].translate(-12.0);
    matrices[4].translate(-14.0);

    drawLayer(canvas, 0);
    drawLayer(canvas, 1);
    drawLayer(canvas, 2);
    drawLayer(canvas, 3);
    drawLayer(canvas, 4);

    drawGradient(canvas);

    canvas.restore();

    drawHero(canvas);
  }

  void drawLayer(Canvas canvas, int index) {
    paintings[index].shader = ImageShader(
      layers[index]!.root!,
      TileMode.repeated,
      TileMode.mirror,
      matrices[index].storage,
    );
    canvas.drawPaint(paintings[index]);
  }

  void drawHero(Canvas canvas) {
    if (++heroFrame % 4 == 0) {
      hero!.nextFrame();
    }
    var img = hero!.root!;
    // heroPaint.invertColors = true;
    // heroPaint.blendMode = BlendMode.colorDodge;
    var heroScale = 2.0;
    var floorY = 480.0 + jumpY.value;
    canvas.save();
    canvas.translate(300.0, floorY);
    canvas.scale(heroScale);
    canvas.translate(-hero!.width! / 2, -hero!.height!);
    canvas.drawImage(img, const Offset(0, 0), heroPaint);
    canvas.restore();
  }

  void drawGradient(Canvas canvas) {
    canvas.drawPaint(gradientPaint);
  }
}
