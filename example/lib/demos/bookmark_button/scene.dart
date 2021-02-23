/// use latest graphx 0.9.7
/// idea from: https://dribbble.com/shots/13890969-Bookmark-Button
/// demo: https://graphx-bookmark-btn.surge.sh
/// bookmark gif asset:
/// https://graphx-bookmark-btn.surge.sh/assets/assets/samples/bookmark.gif
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class BookmarkButton extends GSprite {
  double get sw => stage.stageWidth;

  double get sh => stage.stageHeight;
  GShape bg;
  GText label;
  bool isOn = false;
  static List<GTexture> _gifFrames;
  GMovieClip bookmarkIco;
  GDropShadowFilter shadow;

  /// remove if not in debug? (hot reload).
  @override
  void dispose() {
    super.dispose();
    onMouseDown.removeAll();
    onMouseClick.removeAll();
  }

  @override
  void addedToStage() {
    stage.color = Color(0xffEDEFFB);
    bg = addChild(GShape()) as GShape;
    shadow = GDropShadowFilter(
      6,
      6,
      Math.PI1_2,
      3,
      Color(0xffA4AADB).withOpacity(.43),
    );
    bg.$useSaveLayerBounds = false;
    bg.filters = [shadow];
    label = GText.build(
      text: 'Bookmark',
      color: Colors.black.withOpacity(.7),
      fontSize: 20,
      letterSpacing: .1,
    );
    label.validate();
    addChild(label);
    label.setPosition(sw - label.textWidth - 32, (sh - label.textHeight) / 2);
    _loadTexture();
    onMouseDown.add((e) {
      shadow.tween(duration: .3, blurX: 2, blurY: 2, distance: 1);
      bg.tween(duration: .3, scale: .95);
      stage.onMouseUp.addOnce((e) {
        shadow.tween(duration: .5, blurX: 6, blurY: 6, distance: 6);
        bg.tween(duration: .5, scale: 1);
      });
    });
    onMouseClick.add((e) {
      isOn = !isOn;
      bookmarkIco.gotoAndPlay(isOn ? 1 : 45, lastFrame: isOn ? 44 : 78);
    });
    bg.graphics
        .beginFill(Colors.white)
        .drawRoundRect(-sw / 2, -sh / 2, sw, sh, 7)
        .endFill();
    bg.setPosition(sw / 2, sh / 2);
  }

  Future<void> _loadTexture() async {
    if (_gifFrames == null) {
      var atlas = await ResourceLoader.loadGif(
          'assets/bookmark_button/bookmark.gif',
          resolution: 2,
          cacheId: 'bookmark');
      _gifFrames = atlas.textureFrames;
    }
    bookmarkIco =
        addChild(GMovieClip(frames: _gifFrames, fps: 50)) as GMovieClip;
    bookmarkIco.repeatable = false;
    bookmarkIco.alignPivot();
    bookmarkIco.setPosition(label.x / 2 + 2, sh / 2);
    bookmarkIco.height = 26;
    bookmarkIco.scaleX = bookmarkIco.scaleY;
  }
}
