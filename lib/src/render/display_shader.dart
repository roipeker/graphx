import 'dart:ui';

import '../../graphx.dart';

/// Utility wrapper for FragmentShader.
///
/// The fragment shader is responsible for rendering the pixel colors of the
/// canvas.
///
/// To create a [DisplayShader] you can either load it from a shader file using
/// the `await DisplayShader.load("shader_id")` method or create it directly by
/// subclassing this class and overriding the [floats] getter to return the list
/// of float values to be used as uniforms in the shader.
///
/// Allows to set the shader properties and call update().
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
///
/// uniform float u_time;
/// uniform vec2 u_res;
/// out vec4 fragColor;
///
/// void main() {
///     vec2 currentPos = FlutterFragCoord().xy;
///     vec2 st = currentPos / u_res;
///     float blue = abs(sin(u_time));
///     fragColor = vec4(st.x, st.y, blue, 1.0);
/// }
/// ```
abstract class DisplayShader implements FragmentShader {
  /// A list of empty samplers that will be used when the fragment shader does
  /// not require any texture inputs.
  static final _emptySamplers = List<Image>.empty();

  /// The fragment shader used to display the images.
  FragmentShader? shader;

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

  /// See [Shader.debugDisposed]
  @override
  bool get debugDisposed {
    return shader?.debugDisposed ?? true;
  }

  /// List of floats IN ORDER to be set into the shader.
  /// All vec2,vec3,vec4,float must be passed in order here.
  List<double> get floats;

  /// List of Images IN ORDER to be set into the shader as sampler2d.
  List<Image> get samplers => _emptySamplers;

  /// This method sets the float value at the specified [index] directly
  /// into the shader, bypassing the [floats] list. If the [shader] is `null`,
  /// this method does nothing.
  void operator []=(int index, double value) {
    floats[index] = value;
    shader?.setFloat(index, value);
  }

  /// Shortcut for callable instance. Instead of calling `shader.update()`
  /// When a property of a subclass is modified has to be called to commit
  /// those changes to the FragmentShader.
  void call() {
    update();
  }

  /// See [Shader.dispose]
  @override
  void dispose() {
    shader?.dispose();
  }

  /// Returns `true` if the shader with the specified [id] is found in the cache.
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
  List<double> imageSize(Image? img) {
    return img == null ? const [0.0, 0.0] : [img.width + .0, img.height + .0];
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

  /// Loads the shader with the specified [id] from resources. Returns a
  /// [Future] that completes with a [FragmentProgram] when the shader is
  /// loaded.
  static Future<FragmentProgram> load(String id) async {
    return await ResourceLoader.loadShader(id, id);
  }
}
