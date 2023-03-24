import 'package:flutter/material.dart' show Colors, BlendMode;
import 'package:graphx/graphx.dart';

class ColorfulShadersScene extends GSprite {
  late List<ColorfulShader> shaders;

  // ColorfulShader shader;

  @override
  void dispose() {
    // shader.dispose();
    for (var shader in shaders) {
      shader.dispose();
    }
    super.dispose();
  }

  @override
  Future<void> addedToStage() async {
    stage!.color = Colors.black;
    stage!.maskBounds = true;

    if (kIsWeb) {
      trace("This particular GLSL shader is not supported (currently) on web.");
    }

    /// Load the shader program.
    final program = await ResourceLoader.loadShader('shaders/colorful.frag');

    // Option 1: use 1 shader for all.
    // var shader = ColorfulShader(shader: program.fragmentShader());

    // Option 2: create a few shaders.
    shaders = List.generate(
      4,
      (index) => ColorfulShader(shader: program.fragmentShader()),
    );

    var boxes = List.generate(10, (index) {
      var shader = Math.randomList(shaders);
      // final color = Colors.primaries[index % Colors.primaries.length];

      var box = addChild(GShape());
      box.graphics
          // .lineStyle(1, color)
          .lineStyle(4)
          .lineShaderStyle(shader)
          .blendMode(BlendMode.plus)
          .beginShader(shader)
          .blendMode(BlendMode.plus)
          .drawCircle(50, 50, 50)
          .endFill();

      box.scale = 1 + Math.random() * 4;
      box.x = Math.randomRange(0, 400);
      box.y = Math.randomRange(0, 400);
      box.userData = Math.random() * .15;
      // box.alignPivot();
      box.pivotY = Math.random() * 100;
      box.pivotX = Math.random() * 100;
      box.alpha = .25 + Math.random() * .5;
      return box;
    });

    stage!.onEnterFrame.add((delta) {
      // OPTION 1: use 1 shader for all, and update it
      // shader.time += .1;
      // shader();

      // OPTION 2: use many shader programs.
      for (var shader in shaders) {
        shader.inc();
      }

      for (var box in boxes) {
        final rnd = box.userData as double;
        box.scale += rnd * .5;
        final ease = rnd.abs() / 4;
        box.x += (mouseX - box.x) * ease;
        box.y += (mouseY - box.y) * (ease / 4);

        /// Flip the random direction when the scale is "out of bounds".
        if (box.scale > 10) {
          box.scale = 10;
          box.userData = rnd * -1;
        } else if (box.scale < .1) {
          box.scale = .1;
          box.userData = rnd * -1;
        }
      }
    });
  }
}

class ColorfulShader extends DisplayShader {
  // Change params.
  double time = 0;
  double width = 100;
  double height = 100;

  double _inc = 0.0;

  void inc() {
    time += _inc;
    update();
  }

  ColorfulShader({required super.shader}) {
    _inc = .025 + Math.random() * .1;
  }
  @override
  List<double> get floats => [width, height, time];
}
