import 'dart:ui';

import 'package:graphx/graphx.dart';

/// Utility wrapper for FragmentShader
/// It provides a utility to load a shader from resources, and allows setting
/// floats and images to be used in the shader.
//
/// Allows to set the shader properties and update the shader.
///
/// ```dart
/// class MyCustomShader extends DisplayShader {
///   static late FragmentProgram program;
///   static Future init() async {
///     program = await ResourceLoader.loadShader('shaders/myshader.frag');
///   }
///
///   double time = 0;
///   double width = 100;
///   double height = 100;
///
///   MyCustomShader() {
///     shader = program.fragmentShader();
///   }
///
///   @override
///   List<double> get floats => [time, width, height];
/// }
/// ```
///
/// Painting shader at the border of a shape:
/// ```dart
///
///     await MyCustomShader.init();
///     var customShader = MyCustomShader();
///     // alternative  assign the index for the FLOAT var directly (only write)
///     customShader[1] = 200;
///
///     stage!.onEnterFrame.add((delta) {
///       customShader.time += .01;
///       customShader();
///     });
///
///     graphics
///         .lineStyle(12)
///         .lineShaderStyle(customShader)
///         .beginFill(Colors.blue)
///         .drawRoundRect(0, 0, 100, 100, 12)
///         .endFill()
///         .beginFill(Colors.red)
///         .drawCircle(150, 50, 32)
///         .endFill();
///```
///
/// Shader code:
///
/// ```glsl
/// #include <flutter/runtime_effect.glsl>
//
// uniform float u_time;
// uniform vec2 u_res;
// out vec4 fragColor;
//
// void main() {
//     vec2 currentPos = FlutterFragCoord().xy;
//     vec2 st = currentPos / u_res;
//     float blue = abs(sin(u_time));
//     fragColor = vec4(st.x, st.y, blue, 1.0);
// }
// ```
abstract class DisplayShader implements FragmentShader {
  /// Loads the shader with the specified [id] from resources.
  /// Returns a [Future] that completes with a [FragmentProgram] when the shader is loaded.
  static Future<FragmentProgram> load(String id) async {
    return await ResourceLoader.loadShader(id, id);
  }

  // Returns `true` if the shader with the specified [id] is found in the cache.
  /// If found, sets the [shader] field to the shader.
  /// If not found, returns `false`
  bool fromCache(String id) {
    final program = ResourceLoader.getShader(id);
    if (program == null) {
      return false;
    }
    shader = program.fragmentShader();
    return true;
  }

  /// Utility to get the size of an image (width and height) as List<double>
  /// to populate the [floats] in the Shader.
  @protected
  List<double> imageSize(Image? img) =>
      img == null ? const [0.0, 0.0] : [img.width + .0, img.height + .0];

  static final _emptySamplers = List<Image>.empty();

  /// The fragment shader used to display the images.
  FragmentShader? shader;

  /// List of floats IN ORDER to be set into the shader.
  /// All vec2,vec3,vec4,float must be passed in order here.
  List<double> get floats;

  /// List of Images IN ORDER to be set into the shader as sampler2d.
  List<Image> get samplers => _emptySamplers;

  /// Creates a new [DisplayShader] with the specified [shader] and [id].
  /// If the [shader] is not provided, attempts to load the shader with the [id].
  DisplayShader({this.shader, String? id}) {
    if (shader == null && id != null) {
      if (!fromCache(id)) {
        trace('''Warning, shader "$id" not found in cache.
Did you call await DisplayShader.load("$id")?''');
      }
    }
  }

  /// Shortcut for callable instance. Instead of calling `shader.update()`
  /// When a property of a subclass is modified has to be called to commit
  /// those changes to the FragmentShader.
  void call() {
    update();
  }

  /// Updates the shader with the current values of the properties.
  void update() {
    if (shader == null) return;
    final f = floats;
    final s = samplers;
    if (f.isNotEmpty) {
      for (var i = 0; i < f.length; ++i) {
        shader!.setFloat(i, f[i]);
      }
    }
    if (s.isNotEmpty) {
      for (var i = 0; i < s.length; ++i) {
        shader!.setImageSampler(i, s[i]);
      }
    }
  }

  /// Sets the float index directly into the shader.
  void operator []=(int index, double value) {
    floats[index] = value;
    shader?.setFloat(index, value);
  }

  /// See [Shader.debugDisposed]
  @override
  bool get debugDisposed => shader?.debugDisposed ?? true;

  /// See [Shader.dispose]
  @override
  void dispose() {
    shader?.dispose();
  }

  /// See [Shader.setFloat]
  @override
  void setFloat(int index, double value) {
    shader?.setFloat(index, value);
  }

  /// See [Shader.setImageSampler]
  @override
  void setImageSampler(int index, Image image) {
    shader?.setImageSampler(index, image);
  }
}
