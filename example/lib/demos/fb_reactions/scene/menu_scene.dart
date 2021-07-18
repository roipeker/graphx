import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'menu_item.dart';

class EmotionVo {
  final String asset, name;

  const EmotionVo(this.name, this.asset);
}

class MenuScene extends GSprite {
  static const emotions = [
    EmotionVo(
      'Like',
      'assets/fb_reactions/like.gif',
    ),
    EmotionVo(
      'Woow',
      'assets/fb_reactions/wow.gif',
    ),
    EmotionVo(
      'Yay!',
      'assets/fb_reactions/yay.gif',
    ),
    EmotionVo(
      'LOL',
      'assets/fb_reactions/haha.gif',
    ),
    EmotionVo(
      'Sad',
      'assets/fb_reactions/sad.gif',
    ),
    EmotionVo(
      'Grrr',
      'assets/fb_reactions/angry.gif',
    ),
  ];
  late List<MenuItem> _items;

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  /// calculated based on bigSize and menuW
  double? itemSize;
  double? bigSizeScale;

  double bigSize = 120.0;
  int numItems = emotions.length;

  late GShape bg;
  late GSprite menuContainer;
  double menuWidth = 400;
  double itemSep = 10;
  double bgPadding = 20;
  MenuItem? currentItem;

  @override
  Future<void> addedToStage() async {
    final availableMenuW =
        (menuWidth - bgPadding * 2 - (numItems - 1) * itemSep);
    itemSize = (availableMenuW - bigSize) / (numItems - 1);
    bigSizeScale = bigSize / itemSize!;

    final bgH = itemSize! + bgPadding * 2;
    menuContainer = GSprite();
    addChild(menuContainer);
    bg = GShape();
    bg.graphics
        .beginFill(Colors.blueAccent)
        .drawRoundRect(0, 0, menuWidth, bgH, bgH / 2)
        .endFill();
    menuContainer.addChild(bg);
    menuContainer.alignPivot();

    /// center the container in the Stage.
    // menuContainer.setPosition(sw / 2, sh / 2);
    visible = false;
    mps.on('showMenu', onShowMenu);
    await _createMenu();
  }

  void onShowMenu(GRect bounds) {
    visible = true;

    menuContainer.x = mouseX;
    menuContainer.y = mouseY;
    // menuContainer.x = bounds.x + bounds.width / 2 + menuWidth / 2;
    // menuContainer.y = bounds.y + bounds.height / 2;

    /// scale it to 70%, looks better.
    menuContainer.tween(
        duration: .8,
        y: '-10',
        scale: .7,
        alpha: 1,
        rotation: 0,
        ease: GEase.elasticOut);

    stage!.onMouseUp.addOnce((event) {
      menuContainer.tween(
          duration: .5,
          delay: .2,
          scale: .25,
          alpha: 0.25,
          ease: GEase.easeInExpo,
          y: -80,
          rotation: 1.3,
          onComplete: () {
            visible = false;
          });
    });
  }

  /// Special flag (only for this case) for hot-restart behaviour,
  /// (hot restart works ok), to avoid running the async call twice... seems
  /// like a Flutter bug. So this is only for testing.
  bool _loadingBug = false;

  Future<void> _createMenu() async {
    if (_loadingBug) return;
    _loadingBug = true;

    /// load gifs (if needed, or take from cache)
    for (final vo in emotions) {
      await ResourceLoader.loadGif(vo.asset, resolution: 1, cacheId: vo.asset);
    }
    _loadingBug = false;
    _items = [];
    for (final vo in emotions) {
      var itm = MenuItem(itemSize);
      menuContainer.addChild(itm);
      itm.setEmoji(vo.asset, vo.name);
      _items.add(itm);
    }
    positionItems();

    /// The menu UX requires to have always 1 items selected.
    /// So, select the first item.
    _selectItem(_items[0]);
  }

  void positionItems() {
    var prevX = bgPadding;
    for (var i = 0; i < _items.length; ++i) {
      var itm = _items[i];
      var size2 = itm.size! / 2;
      itm.y = bgPadding + size2;
      size2 *= itm.scale;
      itm.x = prevX + size2;
      prevX += size2 * 2 + itemSep;
      itm.onMouseOver.add((signal) => _selectItem(signal.target as MenuItem?));
    }
  }

  void _selectItem(MenuItem? item) {
    if (item == currentItem) return;
    if (currentItem != null) {
      currentItem!.showTooltip(false);
      GTween.killTweensOf(currentItem);
      currentItem!.tween(duration: .3, scale: 1);
    }
    currentItem = item;
    currentItem!.showTooltip(true);
    GTween.killTweensOf(currentItem);
    currentItem!.tween(
      duration: .3,
      scale: bigSizeScale,
      onUpdate: positionItems,
    );
  }
}
