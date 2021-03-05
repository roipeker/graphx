import 'package:flutter/cupertino.dart';
import 'package:graphx/graphx.dart';

class CoffeeItemScene extends GSprite {
  String imageUrl = "assets/murat_coffee/espresso.png";

  @override
  void addedToStage() {
    var product = _ProductSerious();
    // product = _ProductPlayful();
    product.loadImage(imageUrl);
    product.setPosition(stage.stageWidth / 4, 0);
    addChild(product);
  }
}

class _ProductSerious extends _ProductPlayful {
  @override
  void update(double delta) {
    super.update(delta);
    if (numChildren == 0) return;
    moveCounter += .05;
    var ratio = Math.sin(moveCounter);
    image.y = imageY + ratio * 20;
    var ratio2 = (ratio / 2 + .5);
    shadow.scaleX = 0.8 + ratio2 * 0.2;
    shadow.scaleY = 0.2 - ratio2 * 0.05;
    shadow.alpha = 0.6 + ratio2 * 0.3;
  }
}

class _ProductPlayful extends GSprite {
  String url;
  GBitmap image;
  GShape shadow;

  double shadowY = 0.0;
  double imageY = 0.0;
  double moveCounter = 0.0;
  double rotationCounter = 0.0;

  void loadImage(String url) {
    this.url = url;
    initUi();
  }

  void initUi() async {
    var tx = await ResourceLoader.loadTexture(url, 2.0);
    image = GBitmap(tx);
    image.alignPivot(Alignment.bottomCenter);

    image.x = image.pivotX;
    imageY = image.y = image.pivotY;

    var itmW = image.width;
    shadow = GShape()
      ..graphics.beginFill(kColorBlack).drawCircle(0, 0, itmW / 2).endFill();
    shadow.filters = [GBlurFilter(8, 8)];
    shadow.scaleY = .2;
    shadowY = shadow.y = image.bounds.height + shadow.height;
    shadow.x = image.bounds.width / 2;

    addChild(image);
    addChild(shadow);
  }

  @override
  void update(double delta) {
    super.update(delta);
    if (numChildren == 0) return;
    moveCounter += .05;
    rotationCounter += .02;

    var ratioRot = Math.sin(rotationCounter);
    var ratio = Math.sin(moveCounter);
    image.y = imageY + ratio * 20;
    var ratio2 = (ratio / 2 + .5);
    image.scaleX = 0.9 + ratio2 * .1;
    image.scaleY = 0.88 + -ratio2 * .12;
    image.rotation = ratioRot * .1;
    shadow.scaleX = 0.8 + ratio2 * 0.2;
    shadow.scaleY = 0.2 - ratio2 * 0.05;
    shadow.alpha = 0.6 + ratio2 * 0.3;
    // shadow.y = shadowY + -ratio * 20;
  }
}
