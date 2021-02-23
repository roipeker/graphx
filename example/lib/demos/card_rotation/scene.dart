/// roipeker 2021

/// video demo:
/// https://media.giphy.com/media/18XFI8lY9Uj6cgoF66/source.mp4

/// web demo:
/// https://graphx-dropshadow-card.surge.sh/
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class CardRotation3dScene extends GSprite {
  @override
  void addedToStage() {
    stage.color = Color(0xffF8F6F4);
    initUi();
  }

  Future<void> initUi() async {
    var photoTexture =
        await ResourceLoader.loadTexture('assets/card_rotation/photo.png', 1);
    var logoTexture = await ResourceLoader.loadTexture(
        'assets/card_rotation/mcdonalds.png', 1);

    var cardItem = GSprite();
    addChild(cardItem);

    var bg = GShape();
    cardItem.addChild(bg);
    bg.graphics
        .beginFill(kColorWhite)
        .drawRoundRect(0, 0, 315, 144, 20)
        .endFill();
    bg.$useSaveLayerBounds = false;

    final shadowColor = Color(0xff975A6F).withOpacity(.2);
    var shadow = GDropShadowFilter(16, 16, deg2rad(90), 4, shadowColor);
    bg.filters = [shadow];

    var image = GSprite();
    cardItem.addChild(image);

    var roundMask = GShape();
    roundMask.graphics
        .beginFill(kColorBlack)
        .drawRoundRect(0, 0, 120, 120, 20)
        .endFill();
    var bmp = GBitmap(photoTexture);
    bmp.height = 120;
    bmp.scaleX = bmp.scaleY;
    image.addChild(bmp);
    image.addChild(roundMask);
    bmp.mask = roundMask;
    cardItem.setPosition(100, 100);
    image.x = -30;
    image.y = (144 - 120) / 2;

    var logo = GSprite();
    cardItem.addChild(logo);
    logo.graphics
        .beginFill(const Color(0xffD52B1E))
        .drawRoundRect(0, 0, 40, 40, 12)
        .endFill();
    logo.x = 315 - 20.0 - 40.0;
    logo.y = 20;
    var mcLogo = GBitmap(logoTexture);
    logo.addChild(mcLogo);
    mcLogo.alignPivot();
    mcLogo.scale = .5;
    mcLogo.nativePaint.filterQuality = FilterQuality.high;
    bmp.nativePaint.filterQuality = FilterQuality.high;
    mcLogo.setPosition(20, 20);

    var textContainer = GSprite();
    textContainer.x = 110;
    textContainer.y = 20;
    cardItem.addChild(textContainer);

    var tf1 = getText('Today - 31 Dec 2019', 0x634545, 12.0);
    var tf2 = getText('McDonald\'s', 0x634545, 16.0, FontWeight.bold);
    var tf3 = getText('''Samurai Pork Burger 
Buy 1 Get Free French Fries
Just 89.- THB''', 0x9E7878, 12.0, FontWeight.normal, 20 / 12);
    tf1.alpha = .5;
    textContainer.addChild(tf1);
    textContainer.addChild(tf2);
    textContainer.addChild(tf3);
    tf1.validate();
    tf2.validate();
    tf3.validate();

    LayoutUtils.col(
      [tf1, tf2, tf3],
      height: 144 - textContainer.y * 2,
      axisAlign: MainAxisAlignment.spaceBetween,
    );

    var cardItemParent = GSprite();
    cardItemParent.addChild(cardItem);
    cardItem.setPosition(0, 0);
    cardItem.alignPivot();
    addChild(cardItemParent);

    cardItemParent.mouseChildren = false;
    cardItemParent.useCursor = true;

    stage.onEnterFrame.add((event) {
      var dx = cardItemParent.mouseX;
      var dy = cardItemParent.mouseY;
      var angle = Math.atan2(dy, dx);
      var dist = Math.sqrt(dx * dx + dy * dy);
      cardItemParent.rotationX = Math.sin(angle) * (dist * .001);
      cardItemParent.rotationY = -Math.cos(angle) * (dist * .0005);

      var percent = dist / 300;
      percent = 1 - percent + .2;
      percent = percent.clamp(0.0, 1.0);
      percent = 0.15 + percent * .35;
      shadow.blurY = shadow.blurX = 4 + dist * .08;
      shadow.distance = dist / 9;
    });

    cardItemParent.onMouseDown.add((event) {
      cardItemParent.tween(
        duration: .8,
        scale: .8,
        ease: GEase.easeOutExpo,
      );

      stage.onMouseUp.addOnce((event) {
        cardItemParent.tween(
          duration: 1.2,
          scale: 1,
          ease: GEase.elasticOut,
        );
        shadow.tween(
          duration: 1.2,
          color: shadowColor.withOpacity(.2),
          distance: 4,
          blurX: 16,
          blurY: 16,
          ease: GEase.elasticOut,
        );
      });
    });

    cardItemParent.alignPivot();
    stage.onResized.add(() {
      cardItemParent.x = stage.stageWidth / 2;
      cardItemParent.y = stage.stageHeight / 2;
    });

    cardItemParent.x = stage.stageWidth / 2;
    cardItemParent.y = stage.stageHeight / 2;
    // cardItemParent.rotationX = .2;
  }

  GText getText(
    String txt,
    int color,
    double size, [
    FontWeight weight = FontWeight.normal,
    double lineHeight = 1.0,
  ]) {
    var tf = GText(
      text: txt,
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: Color(color).withOpacity(1),
        height: lineHeight,
      ),
    );
    return tf;
  }
}
