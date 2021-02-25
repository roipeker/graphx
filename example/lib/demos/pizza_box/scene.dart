/// roipeker 2021
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class PizzaBoxScene extends GSprite {

  double get sw => stage.stageWidth;
  double get sh => stage.stageHeight;

  GBitmap pizza;
  GSprite container, pizzaContainer;
  double boxS = 80;
  bool isOpen = true;
  GShape sideTop, sideBottom;
  GTexture pizzaTexture;

  @override
  void addedToStage() async {
    stage.color = Colors.grey.shade50;
    pizzaTexture =
        await ResourceLoader.loadTexture('assets/pizza_box/pizza.png', 2);
    run();
  }

  Future<void> run() async {
    container = GSprite();
    container.x = sw / 2;
    container.y = sh / 2;

    sideTop = makeSide(Colors.grey.shade600);
    sideBottom = makeSide(Colors.grey.shade700);

    var pizzaRotation = .8;

    var sideBackShape = makeGShape();
    sideBackShape.graphics
        .beginFill(Colors.grey.shade800)
        .drawRect(-boxS / 2, -10, boxS, 10)
        .endFill();
    sideBackShape.rotationX = pizzaRotation;
    sideBackShape.z = 0;
    sideBackShape.y = 0;

    sideTop.y = -7;

    var sideRightShape = makeGShape();
    sideRightShape.graphics
        .beginFill(Colors.grey.shade800)
        .drawRect(0, -10, boxS, 10)
        .endFill();
    sideRightShape.rotationX = .4;
    sideRightShape.rotationY = Math.PI / 2 - .06;

    var sideRightContainer = GSprite();
    sideRightContainer.z = -80;
    container.addChild(sideRightContainer);
    sideRightContainer.x = boxS / 2;
    sideRightContainer.y = 5;
    sideRightContainer.addChild(sideRightShape);

    var sideLeftShape = makeGShape();
    sideLeftShape.graphics
        .beginFill(Colors.grey.shade800)
        .drawRect(0, -10, boxS, 10)
        .endFill();
    sideLeftShape.rotationX = .4;
    sideLeftShape.rotationY = Math.PI / 2 + .06;

    var sideLeftContainer = GSprite();
    sideLeftContainer.z = -80;
    container.addChild(sideLeftContainer);
    sideLeftContainer.x = -boxS / 2;
    sideLeftContainer.y = 5;
    sideLeftContainer.addChild(sideLeftShape);

    /// front
    var frontSide = makeGShape();
    frontSide.graphics
        .beginFill(Colors.grey.shade500)
        .drawRect(-boxS / 2, -14, boxS, 14)
        .endFill();
    frontSide.rotationX = pizzaRotation;
    frontSide.scaleX = 1.2;
    frontSide.z = -30;

    // p21.y = boxS * .9;
    frontSide.y = boxS * .64;

    sideBottom.rotationX = -pizzaRotation;
    container.addChild(sideBackShape);
    container.addChild(sideBottom);

    pizzaContainer = GSprite();
    pizza = GBitmap(pizzaTexture);
    pizzaContainer.addChild(pizza);
    pizza.alignPivot();
    pizza.y = 34;
    pizzaContainer.rotationX = -.7;
    pizza.scale = .4;

    container.addChild(pizzaContainer);
    container.addChild(sideTop);
    container.addChild(frontSide);
    addChild(container);

    pizza.scale = 1;
    addChild(pizzaContainer);

    alignPivot();
    scale = 2;
    GTween.delayedCall(1, showPizza);

    addChild(pizzaContainer);
    pizzaContainer.x = sw / 2;
    pizzaContainer.y = sh / 2 - 40;
    pizzaContainer.setProps(rotationX: 0.0001, scale: .8);
    sideTop.setProps(rotationX: -.8);

    container.setProps(
      scale: .25,
      alpha: 1,
      x: sw / 2 + 200,
      y: sh / 2 - 200,
      rotation: .34,
    );
    // showPizza();
    again();
  }

  void showPizza() {
    addChild(pizzaContainer);
    pizzaContainer.x = sw / 2;
    pizzaContainer.y = sh / 2 - 40;
    pizzaContainer.setProps(rotationX: 0.0001, scale: .8);
    sideTop.setProps(rotationX: -.8);

    container.setProps(
      scale: .25,
      alpha: 1,
      x: sw / 2 + 200,
      y: sh / 2 - 200,
      rotation: .34,
    );

    sideTop.tween(
      duration: .9,
      delay: .3,
      rotationX: -Math.PI,
      ease: GEase.easeOutBack,
    );

    container.tween(
      duration: 1,
      scale: 1,
      alpha: 1,
      rotation: 0,
      x: sw / 2,
      y: sh / 2,
    );

    pizza.tween(
        duration: 3,
        rotation: (Math.PI * 5).toString(),
        onComplete: () {
          container.addChildAt(pizzaContainer, container.numChildren - 3);
          sideTop.tween(
            duration: .9,
            delay: .2,
            rotationX: -.8,
            ease: GEase.easeInBack,
          );
          container.tween(
            duration: 1.5,
            x: '200',
            y: '-100',
            delay: 1.2,
            rotation: 0.5,
            // skewX: -.2,
            // skewY: -.8,
            ease: GEase.easeOutExpo,
          );
        });
    pizzaContainer.tween(
        duration: .8,
        overwrite: 0,
        delay: .4,
        scale: .27,
        y: '-20',
        rotationX: -.8,
        onComplete: () {
          container.addChildAt(pizzaContainer, container.numChildren - 1);
          pizzaContainer.setPosition(0, -60);
          pizzaContainer.tween(
            duration: .5,
            ease: GEase.bounceOut,
            y: 14,
          );
        });
  }

  void again() {
    var targetRotX = isOpen ? sideBottom.rotationX : -Math.PI;
    isOpen = !isOpen;
    sideTop.tween(
      duration: 1,
      rotationX: targetRotX,
      onComplete: again,
    );
  }

  GShape makeGShape() {
    var quad = GShape();
    container.addChild(quad);
    return quad;
  }

  GShape makeSide(Color color) {
    var quad = GShape();
    quad.graphics.beginFill(color).drawRect(-boxS / 2, 0, boxS, boxS).endFill();
    return quad;
  }
}
