import '../../graphx.dart';
import '../events/events.dart';
import '../textures/textures.dart';

class MovieClip extends Bitmap {
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
  Bitmap bitmap;

  Signal _onFramesComplete;

  Signal get onFramesComplete => _onFramesComplete ??= Signal();

  Bitmap getBitmap() {
    return this;
  }

  double get fps => 1 / speed;

  set fps(double value) => speed = 1 / value;

  MovieClip({List<GxTexture> frames, double fps = 30}) {
    setFrameTextures(frames);
    this.fps = fps;
  }

  List<GxTexture> _frameTextures;

  List<GxTexture> setFrameTextures(List<GxTexture> list) {
    _frameTextures = list ?? [];
    frameCount = list?.length ?? 0;
    currentFrame = 0;
    if (list.isNotEmpty) {
      getBitmap()?.texture = list[0];
    } else {
      getBitmap().texture = null;
    }
    return list;
  }

  void gotoFrame(int frame) {
    if (_frameTextures == null) return;
    currentFrame = frame;
    currentFrame %= frameCount;
    getBitmap().texture = _frameTextures[currentFrame];
  }

  void gotoAndPlay(int frame) {
    gotoFrame(frame);
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
    if (playing && frameCount > 1) {
      accumulatedTime += delta * timeDilation;
      // print(accumulatedTime);
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
        if (bitmap == null) bitmap = resolveBitmap();
        if (bitmap != null) {
          bitmap.texture = _frameTextures[currentFrame];
        }
      }
      accumulatedTime %= speed;
    }
  }

  Bitmap resolveBitmap() {
    return getBitmap();
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
