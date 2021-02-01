import 'texture.dart';

class GifFrame {
  Duration duration;
  GTexture texture;
  GifFrame(this.duration, this.texture);
}

class GifAtlas extends GTexture {
  final List<GifFrame> _frames = [];

  List<GTexture> get textureFrames {
    return _frames.map((e) => e.texture).toList();
  }

  void addFrame(GifFrame frame) {
    _frames.add(frame);
    if (_frames.length == 1) {
      _refresh();
    }
  }

  int numFrames = 0;
  GifAtlas();
  int _frame = 0;

  void _refresh() {
    root = _frames[_frame].texture.root;
  }

  bool prevFrame() {
    --_frame;
    if (_frame < 0) _frame = numFrames - 1;
    _refresh();
    return true;
  }

  bool nextFrame() {
    ++_frame;
    _frame %= numFrames;
    _refresh();
    return true;
  }
}
