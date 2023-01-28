/// roipeker 2021
///
/// idea from: https://dribbble.com/shots/7116566-Sorting-Button
/// demo: https://graphx-dropdown-4.surge.sh/
///
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class SortingButtonScene extends GSprite {
  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  @override
  void dispose() {
    stage?.onMouseDown.removeAll();
    super.dispose();
  }

  @override
  void addedToStage() {
    stage!.color = const Color(0xffdedede);
    var btn = SortingButton(195, 50);

    /// as we need to detect global touches on the window, we listen the event
    /// from a "root" scene on top of MaterialApp.
    var lastPress = 0;
    stage!.onMouseDown.add((event) {
      lastPress = getTimer();
      if (!btn.bounds!.containsPoint(btn.mousePosition)) {
        if (btn.isOpen) btn.closeDropdown();
      }
    });
    mps.on('windowMouseDown', (pos) {
      /// if we get a difference bigger than 10ms, it means is NOT the same
      /// mouseDown event...
      if (getTimer() - lastPress > 10) {
        if (btn.isOpen) btn.closeDropdown();
      }
    });
    addChild(btn);
    btn.setPosition((sw - btn.w) / 2, (sh - btn.h) / 2);
  }
}

class SortingButton extends GSprite {
  final dataModel = [
    'Price: \$ Low to High',
    'Price: \$ High to Low',
    'Avg. Customer Reviews',
  ];

  double w, h;
  late GSprite options;
  GShape? bg, menuMask, clickArea;
  late GText label, sortBy;
  late GIcon arrow;

  double labelPaddingX = 18;
  late double labelMaxW;

  bool isOpen = false;
  double optionH = 40;
  double optionSep = 0;
  late double menuOpenH;
  final tweenMenuSize = 0.0.twn;
  int _selectedIndex = -1;
  final highlighColor = const Color(0xff99979D);
  List<GSprite> items = [];
  bool _sorting = false;

  SortingButton(this.w, this.h) {
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    onMouseDown.removeAll();
  }

  void drawBackground(Graphics g, double targetH, double radius,
      [Color color = Colors.black]) {
    g
        .clear()
        .beginFill(color)
        .drawRoundRect(0, 0, w, targetH, radius)
        .endFill();
  }

  void _init() {
    menuMask = GShape();
    bg = GShape();
    clickArea = GShape();
    addChild(bg!);
    addChild(menuMask!);
    addChild(clickArea!);
    tweenMenuSize.value = h;
    drawBackground(bg!.graphics, h, 5);
    drawBackground(menuMask!.graphics, h, 5);
    drawBackground(clickArea!.graphics, h, 0, Colors.red.withOpacity(.4));

    clickArea!.alpha = 0;

    arrow = GIcon(Icons.arrow_back_ios, Colors.white, 14);
    arrow.alignPivot(Alignment.centerLeft);
    arrow.pivotX = 4;
    arrow.rotation = deg2rad(-90);
    addChild(arrow);
    arrow.x = w - 15 - arrow.width / 2;
    arrow.y = h / 2;

    labelMaxW = arrow.x - arrow.width / 2 - 4.0;

    sortBy = createLabel(
      text: 'SORT BY',
      fontSize: 7,
      letterSpacing: .6,
      targetW: labelMaxW - labelPaddingX,
      containerH: h * .5,
      color: Colors.white54,
      doc: this,
    );
    label = createLabel(
      text: 'Low to High',
      fontSize: 12,
      targetW: labelMaxW - labelPaddingX,
      containerH: h + 4.0,
      doc: this,
    );
    sortBy.mouseEnabled = false;
    arrow.mouseEnabled =
        label.mouseEnabled = menuMask!.mouseEnabled = bg!.mouseEnabled = false;

    options = GSprite();
    addChild(options);
    options.y = h;
    options.mask = menuMask;
    _createOptions();
    clickArea!.onMouseDown.add(_onMousePress);
    _selectItem(0);
  }

  void _onMousePress(event) {
    GTween.killTweensOf(tweenMenuSize);
    if (_sorting) return;
    if (isOpen) {
      closeDropdown();
      return;
    }
    var offset = 14.0;

    bg!.tween(
      duration: .25,
      width: w + offset,
      height: h + offset,
      x: -offset / 2,
      y: -offset / 2,
      ease: GEase.easeOutQuart,
      overwrite: 0,
    );
    stage!.onMouseUp.addOnce(_onMouseUp);
  }

  void _onMouseUp(MouseInputData event) {
    GTween.killTweensOf(_delayedOpen);
    bg!.tween(
      duration: 1.3,
      width: w,
      height: h,
      x: 0,
      y: 0,
      ease: GEase.elasticOut,
    );
    if (event.dispatcher == clickArea) {
      GTween.delayedCall(.3, _delayedOpen);
    }
  }

  void _delayedOpen() {
    GTween.killTweensOf(bg);
    bg!.setProps(scale: 1, x: 0, y: 0);
    GTween.killTweensOf(tweenMenuSize);
    openDropdown();
  }

  void _selectItem(int idx) {
    if (_selectedIndex == idx) return;
    if (_selectedIndex > -1) {
      var o = items[_selectedIndex];
      var dot = o.getChildByName('dot')!;
      var label = o.getChildByName('label')!;
      dot.tween(duration: .2, x: labelPaddingX / 2, alpha: 0);
      label.tween(duration: .2, x: labelPaddingX);
    }
    _selectedIndex = idx;
    if (_selectedIndex > -1) {
      var o = items[_selectedIndex];
      var dot = o.getChildByName('dot')!;
      var label = o.getChildByName('label')!;
      dot.tween(duration: .4, x: labelPaddingX, alpha: 1);
      label.tween(duration: .4, x: labelPaddingX + 10);
    }
    if (!isOpen) {
      label.text = dataModel[_selectedIndex];
      return;
    }
    GTween.delayedCall(.5, () {
      closeDropdown();
      GTween.delayedCall(.5, _sortingMode);
    });
  }

  _sortingMode() {
    _sorting = true;
    _writeLabel('Sorting ...');
    sortBy.tween(duration: .3, alpha: 0);
    arrow.tween(duration: .3, alpha: 0, overwrite: 0);
    GTween.delayedCall(2.5, () {
      _sorting = false;
      arrow.tween(duration: .6, alpha: 1, overwrite: 0);
      sortBy.tween(duration: .8, alpha: 1);
      _writeLabel(dataModel[_selectedIndex]);
      bg!.tween(duration: .4, y: 0);
    });

    /// make background bounce a few times.
    void _bounceBg() {
      var ty = bg!.y > 0 ? -1.5 : 3;
      bg!.tween(
        duration: .16,
        y: ty,
        onComplete: _bounceBg,
        ease: GEase.easeInSine,
      );
    }

    _bounceBg();
  }

  void _writeLabel(String newText) {
    var oldText = label.text;
    var countTween = oldText.length.twn;
    countTween.tween(0, duration: .5, ease: GEase.easeInOut, onUpdate: () {
      var sub = oldText.substring(0, countTween.value);
      var multiplier = oldText.length - sub.length;
      label.text = sub + '-' * multiplier;
    });
    label.tween(duration: .3, alpha: .65);
    label.tween(duration: .6, alpha: 1, delay: .3, overwrite: 0);
    countTween.tween(newText.length,
        ease: GEase.fastLinearToSlowEaseIn,
        delay: .5,
        overwrite: 0,
        duration: .9, onUpdate: () {
      var sub = newText.substring(0, countTween.value);
      var multiplier = newText.length - sub.length;
      label.text = sub + '-' * multiplier;
    }, onComplete: () {
      label.text = newText;
    });
  }

  void _createOptions() {
    items.clear();
    for (var i = 0; i < dataModel.length; ++i) {
      var itm = GSprite();
      var subBg = GShape();
      itm.addChild(subBg);
      drawBackground(subBg.graphics, optionH, 0, highlighColor);
      subBg.alpha = 0;
      var lbl = createLabel(
        text: dataModel[i],
        fontSize: 11,
        targetW: labelMaxW - labelPaddingX,
        containerH: optionH,
        doc: itm,
      );
      lbl.name = 'label';
      var dot = GShape();
      itm.addChild(dot);
      dot.alpha = 0;
      dot.graphics.beginFill(Colors.white).drawCircle(0, 0, 3).endFill();
      dot.x = labelPaddingX / 2;
      dot.y = optionH / 2;
      dot.name = 'dot';
      itm.y = (i * (optionH + optionSep));
      itm.mouseChildren = false;
      itm.onMouseOver.add((event) {
        subBg.tween(duration: .2, alpha: .25);
        if (_selectedIndex != i) {
          dot.alpha = .25;
        }
      });
      itm.onMouseOut.add((event) {
        subBg.tween(duration: .4, alpha: 0);
        if (_selectedIndex != i) {
          dot.alpha = 0;
        }
      });
      itm.onMouseDown.add((event) {
        subBg.tween(duration: .3, alpha: .5);
        stage!.onMouseUp.addOnce((event) {
          if (event.dispatcher == itm) {
            subBg.tween(duration: .3, alpha: .25);
            _selectItem(i);
          } else {
            subBg.tween(duration: .3, alpha: 0);
          }
        });
      });
      options.addChild(itm);
      items.add(itm);
    }
    menuOpenH = options.y + options.height;
  }

  void _positionField(GText lbl, double targetH) {
    lbl.validate();
    lbl.x = labelPaddingX;
    lbl.y = (targetH - lbl.textHeight) / 2;
  }

  void closeDropdown() {
    if (!isOpen) return;
    isOpen = false;
    GTween.killTweensOf(tweenMenuSize);
    arrow.tween(duration: .4, rotation: deg2rad(isOpen ? 90 : 360.0 - 90));
    options.mouseChildren = false;

    /// using a tween instead of a tweening the maskHeight... cause we have to
    /// redraw the mask with rounded cornders, not stretch it.
    tweenMenuSize.tween(
      h,
      duration: .7,
      ease: GEase.fastLinearToSlowEaseIn,
      onUpdate: () {
        drawBackground(bg!.graphics, tweenMenuSize.value, 5);
        drawBackground(menuMask!.graphics, tweenMenuSize.value, 5);
      },
    );
    final len = items.length;
    for (var i = 0; i < len; ++i) {
      items[i].tween(
        duration: .5,
        alpha: 0,
        // delay: (len - i - 1) * .02,
        delay: i * .02,
        y: -optionH / 1.4,
        ease: GEase.easeOutCirc,
      );
    }
  }

  void openDropdown() {
    if (isOpen) return;
    isOpen = true;
    bg!.setProps(scale: 1, x: 0, y: 0);
    arrow.tween(
      duration: .4,
      rotation: deg2rad(isOpen ? 90 : 360.0 - 90),
    );
    options.mouseChildren = true;
    GTween.killTweensOf(tweenMenuSize);
    tweenMenuSize.tween(
      menuOpenH,
      duration: 2,
      ease: GEase.fastLinearToSlowEaseIn,
      onUpdate: () {
        drawBackground(bg!.graphics, tweenMenuSize.value, 5);
        drawBackground(menuMask!.graphics, tweenMenuSize.value, 5);
      },
    );

    for (var i = 0; i < items.length; ++i) {
      var ty = i * (optionH + optionSep);
      items[i].tween(
        duration: 1.2,
        delay: i * .01,
        y: ty,
        ease: GEase.fastLinearToSlowEaseIn,
        alpha: 1,
      );
    }
  }

  GText createLabel({
    String? text,
    required double targetW,
    double? containerH,
    double letterSpacing = 0.2,
    double? fontSize,
    Color color = Colors.white,
    FontWeight weight = FontWeight.w600,
    GSprite? doc,
  }) {
    var tf = GText(
      text: text,
      width: targetW,
      textStyle: TextStyle(
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: weight,
      ),
      paragraphStyle: ParagraphStyle(
        textAlign: TextAlign.left,
        maxLines: 1,
      ),
    );
    if (containerH != null) {
      _positionField(tf, containerH);
    }
    doc?.addChild(tf);
    return tf;
  }
}
