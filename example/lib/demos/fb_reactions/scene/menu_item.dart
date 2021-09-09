import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

//// each face
class MenuItem extends GSprite {
  double? size, targetTooltipY;
  late GSprite pill;
  GShape? bg, msk;
  late GText label;
  late GMovieClip emoji;

  MenuItem([this.size = 60]) {
    _init();
  }

  void _init() {
    createTooltip();

    /// bg is the emoji face.
    bg = GShape();
    addChild(bg!);
    bg!.graphics
        .beginFill(Colors.black.withOpacity(.5))
        .drawCircle(0, 0, size! / 2)
        .endFill();

    msk = GShape();
    addChild(msk!);
    msk!.graphics.copyFrom(bg!.graphics);
    msk!.mouseEnabled = false;
    emoji = GMovieClip(frames: <GTexture>[]);
    addChild(emoji);
    mouseChildren = false;
  }

  void createTooltip() {
    pill = GSprite();
    addChild(pill);
    label = GText(
      text: 'label',
      textStyle: TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        letterSpacing: .2,
      ),
    );
    label.validate();
    drawBackground();
    mouseChildren = true;
    pill.mouseEnabled = false;
    pill.scale = .75;
    pill.addChild(label);
    targetTooltipY = -size! * .9;
  }

  void showTooltip(bool flag) {
    if (flag) {
      pill.tween(duration: .35, y: targetTooltipY, alpha: 1);
    } else {
      pill.tween(duration: .35, y: 0, alpha: 0);
    }
  }

  void setEmoji(String gifId, String tooltipString) {
    _setGifAtlas(gifId);
    label.text = tooltipString;
    label.validate();
    drawBackground();
    pill.scale = .75;
    pill.addChild(label);
    pill.alignPivot();
    targetTooltipY = -size! * .9;
  }

  void drawBackground() {
    final sepX = 5.0;
    label.x = sepX;
    var bgW = label.textWidth + sepX * 2;
    var bgH = label.textHeight + 2;
    pill.graphics
        .clear()
        .beginFill(Colors.black.withOpacity(.7))
        .lineStyle(0, Colors.white.withOpacity(.2))
        .drawRoundRect(0, 0, bgW, bgH, bgH / 2)
        .endFill();
    pill.alignPivot();
  }

  void _setGifAtlas(String gifId) {
    final myAtlas = ResourceLoader.getGif(gifId)!;
    emoji.setFrameTextures(myAtlas.textureFrames);
    emoji.width = size! + 2;
    emoji.mask = bg;
    emoji.scaleY = emoji.scaleX;
    emoji.mouseEnabled = false;
    emoji.alignPivot();
    emoji.play();
  }
}
