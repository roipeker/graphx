import '../../graphx.dart';

/// A [GMovieClip] is a graphical element that allows you to play a sequence of
/// textures (frames) in a loop. You can control the speed of playback and set
/// the starting and ending frames. The movie clip can be set to loop or stop
/// after a certain number of frames have been played.
class GMovieClip extends GBitmap {
  /// The speed factor for playback. This value is multiplied with the
  /// elapsed time between frames to determine how quickly frames are
  /// advanced.
  double timeDilation = 1;

  /// Determines whether the movie clip repeats when it reaches the
  /// end of the animation.
  bool repeatable = true;

  /// Determines whether the movie clip plays in reverse.
  bool reversed = false;

  /// The time interval (in milliseconds) between frames.
  double speed = 1000 / 30;

  /// The total amount of time that has accumulated since the last frame update.
  double accumulatedTime = 0;

  /// The ID of the last frame that was updated.
  int lastUpdatedFrameId = 0;

  /// The index of the first frame to play.
  int startIndex = -1;

  /// The index of the last frame to play.
  int endIndex = -1;

  /// Determines whether the movie clip is currently playing.
  bool playing = false;

  /// The total number of frames in the movie clip.
  int frameCount = 0;

  /// The index of the current frame in the movie clip.
  int currentFrame = -1;

  /// The frame at which to stop playback.
  int targetFrame = -1;

  /// Dispatched when playback completes, i.e. when the last frame is reached.
  Signal? _onFramesComplete;

  /// A list of textures that represent each frame in the movie clip.
  ///
  /// The textures are displayed in sequence to produce the animation. The order
  /// of the textures in the list determines the order in which they are
  /// displayed.
  ///
  /// The list is set when the [setFrameTextures] method is called.
  List<GTexture>? _frameTextures;

  /// Creates a new movie clip object with the specified frames and frames per
  /// second.
  ///
  /// [frames] is a list of textures to use for the frames of the movie clip.
  /// [fps] is the desired frames per second for the movie clip. The default is
  /// 30.
  GMovieClip({required List<GTexture> frames, double fps = 30}) {
    setFrameTextures(frames);
    this.fps = fps;
  }

  /// The frames per second of the movie clip.
  double get fps {
    return 1 / speed;
  }

  /// Sets the frames per second of the movie clip.
  set fps(double value) {
    speed = 1 / value;
  }

  /// Returns the signal object that is dispatched when playback completes.
  Signal get onFramesComplete {
    return _onFramesComplete ??= Signal();
  }

  /// Frees up resources and cancels any pending operations, preparing this
  /// instance for removal from memory.
  ///
  /// Call this method when the object is no longer needed to ensure that any
  /// resources are released as soon as possible. Once this method is called,
  /// the behavior of accessing the object is undefined and should be avoided.
  ///
  /// This method also stops any ongoing animations and removes all listeners
  /// from the [onFramesComplete] signal. It resets the frame count and
  /// accumulated time to zero and sets the [_frameTextures] list to null.
  @override
  void dispose() {
    super.dispose();
    playing = false;
    frameCount = 0;
    accumulatedTime = 0;
    _onFramesComplete?.removeAll();
    _frameTextures = null;
  }

  /// Advances the movie clip to the specified frame and begins playing.
  ///
  /// [frame] is the index of the frame to advance to.
  ///
  /// [lastFrame] is the index of the frame at which to stop playback. If not
  /// specified, the movie clip will play until the last frame.
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

  /// Sets the current frame index to the specified value and stops the movie
  /// clip.
  void gotoAndStop(int frame) {
    gotoFrame(frame);
    stop();
  }

  /// Advances the movie clip to the specified frame.
  ///
  /// [frame] is the index of the frame to advance to.
  void gotoFrame(int frame) {
    if (_frameTextures == null) {
      return;
    }
    currentFrame = frame;
    currentFrame %= frameCount;
    texture = _frameTextures![currentFrame];
  }

  /// Starts playing the movie clip.
  void play() {
    playing = true;
  }

  /// Sets the textures to be used for the frames of the movie clip.
  ///
  /// [list] is a list of textures to use for the frames of the movie clip.
  ///
  /// Returns the list of textures that were set.
  List<GTexture> setFrameTextures(List<GTexture> list) {
    _frameTextures = list;
    frameCount = list.length;
    currentFrame = 0;
    texture = list.isNotEmpty ? list[0] : null;
    return list;
  }

  /// Stops playing the movie clip.
  void stop() {
    playing = false;
  }

  /// Called on every frame to update the [GMovieClip]'s state.
  ///
  /// The [delta] parameter is the time elapsed since the last frame, measured
  /// in seconds.
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
        texture = _frameTextures![currentFrame];
      }
      accumulatedTime %= speed;
    }
  }
}
