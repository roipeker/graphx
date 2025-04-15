import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../assets/svg_icons.dart';
import '../../utils/utils.dart';

class TestSvgScene extends GSprite {
  final groundHeight = 100.0;
  late GSprite trees, ground;

  @override
  void addedToStage() {
    stage!.color = Colors.lightBlueAccent.shade100;
    _init();
  }

  _init() async {
    await _loadData();
    _drawSun();

    trees = GSprite();
    ground = GSprite();
    addChild(trees);
    addChild(ground);

    trees.y = stage!.stageHeight - groundHeight;
    ground.y = stage!.stageHeight - groundHeight;

    _drawTrees();
    _drawGround();
    _drawLeaves();
  }

  void _drawSun() {
    // add the sun.
    var sun = getSvgIcon(SvgId.cloudy);
    sun.alignPivot();
    sun.width = stage!.stageWidth / 2;
    sun.scaleY = sun.scaleX;
    sun.setPosition(stage!.stageWidth / 2, sun.height / 2);
    addChild(sun);
  }

  void _drawTrees() {
    /// add some trees.
    var currentObjectX = 30.0;
    for (var i = 0; i < 15; ++i) {
      final treeId = i.isOdd ? SvgId.tree : SvgId.pine;
      var tree = getSvgIcon(treeId);
      tree.alignPivot(Alignment.bottomCenter);
      tree.x = currentObjectX;
      tree.scale = Math.randomRange(.4, 1.4);
      trees.addChild(tree);
      currentObjectX += Math.randomRange(20, 80);

      /// let's skew the tree so it seems the wind is moving it.
      _tweenTree(tree, 1);
    }
  }

  void _tweenTree(GDisplayObject tree, int dir) {
    var dur = Math.randomRange(.5, .7);
    var delay = Math.randomRange(.08, .1);
    tree.tween(
      duration: dur,
      delay: delay,
      skewX: .08 * dir,
      onComplete: () {
        _tweenTree(tree, dir * -1);
      },
    );
  }

  void _drawGround() {
    /// draw some ground background.
    ground.graphics
//        .beginFill(0xFFE477)
//        .beginFill(0xFCF2B6)
        .beginFill(Colors.green)
        .drawRect(0, 0, stage!.stageWidth, groundHeight)
        .endFill();

    /// add some ground objects.
    for (var i = 0; i < 8; ++i) {
      final objectId = i.isOdd ? SvgId.mushroom : SvgId.snail;
      var obj = getSvgIcon(objectId);
      obj.alignPivot(Alignment.bottomCenter);
      obj.y = Math.randomRange(20, groundHeight);
      obj.x = Math.randomRange(20, stage!.stageWidth - 20);
      obj.scale = Math.randomRange(.8, 1.5);
      if (objectId == SvgId.snail) {
        /// DisplayObjects has a userData property so u can save custom stuffs
        /// in it, lets save the scale so we can "tween"  a bouncing while the
        /// snail moves.
        obj.userData = obj.scale;
        _tweenSnail(obj);
      }
      ground.addChild(obj);
    }

    /// to avoid weird overlapping of the children... we know that
    /// the lower the "y", should appear on top of the rest.
    /// so we have to change the display list order according to their position.
    ground.sortChildren((object1, object2) => object1.y > object2.y ? 1 : -1);
  }

  void _tweenSnail(GDisplayObject snail) {
    final delay = Math.randomRange(.2, .6);

    /// if the snail is outside the stage area... move it to the
    /// other side of the screen.
    if (snail.x > stage!.stageWidth) {
      snail.x = -100;
    }

    snail.tween(
      duration: .5,
      x: '30',
      delay: delay,
      onComplete: () => _tweenSnail(snail),
    );

    double originalScale = snail.userData as double;

    /// scale down 80%
    snail.tween(
      duration: .3,
      scaleY: originalScale * .8,
      delay: delay / 2,
    );

    /// scale back to 100%
    snail.tween(
      duration: .6,
      scaleY: originalScale,
      delay: delay / 2 + .3,
    );
  }

  void _drawLeaves() {
    for (var i = 0; i < 100; ++i) {
      final leafId = i.isOdd ? SvgId.leaf : SvgId.leaf2;
      var leaf = getSvgIcon(leafId);

      addChild(leaf);

      var px = Math.randomRange(10, stage!.stageWidth - 10);
      leaf.setPosition(px, -10);
      final rndPivot =
          Math.randomBool() ? Alignment.bottomCenter : Alignment.topCenter;
      leaf.alignPivot(rndPivot);
      leaf.scale = Math.randomRange(.4, 1);

      /// delayCall acts like Future.delay(), but works with the GTween
      /// update cycle. it expects the delay in seconds, the callback, and
      /// optionally any parameters the callback have.
      /// Is very easy to pass custom functions parameters with GTween:
      /// in this case, named parameters are defined like a Map<Stymbol>
      GTween.delayedCall(
        i * .05,
        _tweenLeaf,
        params: {
          #dir: Math.randomBool() ? -1 : 1,
          #leaf: leaf,
        },
      );
    }
  }

  void _tweenLeaf({required int dir, required GDisplayObject leaf}) {
    final randomRotation = Math.randomRange(10, 45.0) * dir;
    final randomDuration = Math.randomRange(.75, 1);
    final randomSkew = Math.randomRange(.1, .3) * -dir;
    leaf.tween(
      duration: randomDuration,
      rotation: deg2rad(randomRotation),
      skewX: randomSkew,
      skewY: -randomSkew / 2,
      onComplete: () {
        if (leaf.y > stage!.stageHeight) {
          trace('Leaf outside of stage, remove and dispose it.');
          leaf.removeFromParent(true);
        } else {
          _tweenLeaf(dir: dir * -1, leaf: leaf);
        }
      },
      ease: GEase.decelerate,
    );
    final randomX = Math.randomRange(5, 40) * dir;
    final randomY = Math.randomRange(5, 30);
    leaf.tween(
        duration: randomDuration * .9,
        x: '$randomX',
        y: '$randomY',
        ease: GEase.linear);
  }

  /// utils for parsing SVG.
  Future<void> _loadData() async {
    await parseSvg(SvgImages.leaf, SvgId.leaf);
    await parseSvg(SvgImages.leaf2, SvgId.leaf2);
    await parseSvg(SvgImages.mushroom, SvgId.mushroom);
    await parseSvg(SvgImages.tree1, SvgId.tree);
    await parseSvg(SvgImages.pine, SvgId.pine);
    await parseSvg(SvgImages.cloudy, SvgId.cloudy);
    await parseSvg(SvgImages.sneal, SvgId.snail);
  }

  GSvgShape getSvgIcon(SvgId id) {
    return GSvgShape(_svgMap[id]);
  }

  /// we have to load and parse svg data.
  static final _svgMap = <SvgId, SvgData>{};

  static Future<void> parseSvg(String rawSvg, SvgId id) async {
    _svgMap[id] = await SvgUtils.svgDataFromString(rawSvg);
  }
}

enum SvgId { leaf, leaf2, tree, pine, mushroom, snail, cloudy }
