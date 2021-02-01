import '../../graphx.dart';

class GMovieClip extends GBitmap {
  double timeDilation = 1;
  bool repeatable = true;
  bool reversed = false;

  double speed = 1000 / 30;
  double accumulatedTime = 0;
  int lastUpdatedFrameId = 0;
  int startIndex = -1;
  int endIndex = -1;
  bool playing = false;

  /// render into what
  int frameCount = 0;
  int currentFrame = -1;

  /// stops the playback when reaching this frame.
  int targetFrame = -1;
  GBitmap bitmap;

  Signal _onFramesComplete;

  Signal get onFramesComplete => _onFramesComplete ??= Signal();

//  Bitmap2 getBitmap() => this;
//  Bitmap2 resolveBitmap() => getBitmap();

  double get fps => 1 / speed;

  set fps(double value) => speed = 1 / value;

  GMovieClip({List<GTexture> frames, double fps = 30}) {
    setFrameTextures(frames);
    this.fps = fps;
  }

  List<GTexture> _frameTextures;

  List<GTexture> setFrameTextures(List<GTexture> list) {
    _frameTextures = list ?? [];
    frameCount = list?.length ?? 0;
    currentFrame = 0;
    texture = list.isNotEmpty ? list[0] : null;
    return list;
  }

  void gotoFrame(int frame) {
    if (_frameTextures == null) return;
    currentFrame = frame;
    currentFrame %= frameCount;
    texture = _frameTextures[currentFrame];
  }

  void gotoAndPlay(int frame, {int lastFrame = -1}) {
    gotoFrame(frame);
    if (lastFrame > frameCount) {
      lastFrame %= frameCount;
    } else if (lastFrame > -1 && lastFrame < frame) {
      /// TODO: add repeatable logic?
    }
    targetFrame = lastFrame;
    play();
  }

  void gotoAndStop(int frame) {
    gotoFrame(frame);
    stop();
  }

  void stop() {
    playing = false;
  }

  void play() {
    playing = true;
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (playing && frameCount > 1) {
      accumulatedTime += delta * timeDilation;
      if (accumulatedTime >= speed) {
        currentFrame +=
            reversed ? -(accumulatedTime ~/ speed) : accumulatedTime ~/ speed;
        if (reversed && currentFrame < 0) {
          if (repeatable) {
            currentFrame = (frameCount + currentFrame) % frameCount;
          } else {
            currentFrame = 0;
            playing = false;
          }
        } else if (!reversed && currentFrame >= frameCount) {
          if (repeatable) {
            currentFrame = currentFrame % frameCount;
          } else {
            currentFrame = frameCount - 1;
            playing = false;
            _onFramesComplete?.dispatch();
            return;
          }
        }
        if (targetFrame > -1 && currentFrame == targetFrame) {
          playing = false;
        }
        texture = _frameTextures[currentFrame];
      }
      accumulatedTime %= speed;
    }
  }

  @override
  void dispose() {
    super.dispose();
    playing = false;
    frameCount = 0;
    accumulatedTime = 0;
    _onFramesComplete?.removeAll();
    _frameTextures = null;
  }
}
