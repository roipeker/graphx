import 'texture.dart';

/// Represents a Gif animation in the form of a texture atlas, which contains a
/// list of frames.
class GifAtlas extends GTexture {
  /// List of frames in the animation.
  final List<GifFrame> _frames = [];

  /// Total number of frames in the animation.
  int numFrames = 0;

  /// Current frame index.
  int _frame = 0;

  /// Returns a list of texture frames from the list of frames.
  List<GTexture> get textureFrames {
    return _frames.map((e) => e.texture).toList();
  }

  /// Adds a frame to the list of frames.
  void addFrame(GifFrame frame) {
    _frames.add(frame);
    if (_frames.length == 1) {
      _refresh();
    }
  }

  /// Switches to the next frame in the animation.
  bool nextFrame() {
    ++_frame;
    _frame %= numFrames;
    _refresh();
    return true;
  }

  /// Switches to the previous frame in the animation.
  bool prevFrame() {
    --_frame;
    if (_frame < 0) _frame = numFrames - 1;
    _refresh();
    return true;
  }

  /// Refreshes the texture with the current frame texture.
  void _refresh() {
    root = _frames[_frame].texture.root;
  }
}

/// Represents a single frame of a GIF animation.
class GifFrame {
  /// Duration of the frame.
  Duration duration;

  /// Texture to be displayed for this frame.
  GTexture texture;

  /// Creates a new instance of the [GifFrame] class with the specified
  /// [duration] and [texture].
  GifFrame(this.duration, this.texture);
}
