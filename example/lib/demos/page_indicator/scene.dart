import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/base_scene.dart';
import 'dot.dart';

/// Sample fot Ismail, need to integrate a controller to get the PageView
/// events.
///
class PageIndicatorPaged extends BaseScene {
  PageIndicatorPaged();

  List<PageDot> _dots;
  static const double dotSize = 27 / 2;
  static const double dotPreW = 37 / 2;
  static const double dotSelectedW = 69 / 2;
  static const dotUnselectedColor = Color(0xffC4C4C4);
  static const dotSelectedColor = Colors.red;
  static const dotPreColor = Colors.blue;

  GSprite container;
  GSprite scrollContainer;

  int _currentIndex = 0;
  final int _visibleItems = 5;
  final int _numItems = 10;
  int _scroll = 0;
  double dotSep = 3;

  double allDotsWidth = 0;

  @override
  void addedToStage() {
    super.addedToStage();
    stage.color = Color(0xffD1D1D);

    container = GSprite();
    scrollContainer = GSprite();
    addChild(container);
    container.addChild(scrollContainer);

    _dots = List.generate(_numItems, (index) {
      var dot = PageDot(index, dotSize, dotUnselectedColor);
      dot.x = index * (dotSize * 2);
      scrollContainer.addChild(dot);
      return dot;
    });

    var itemWS = dotSize + dotSep;
    allDotsWidth =
        itemWS * (_visibleItems - 2) + (dotPreW + dotSep) * 2 + dotSelectedW;

    /// debug size.
    // container.graphics
    //     // .lineStyle(1, Colors.black)
    //     .beginFill(Colors.black.withAlpha(120))
    //     .drawRect(-10, -10, allDotsWidth+20, dotSize+20)
    //     .endFill();

    /// -- masking.

    // var maskOff = 3.0;
    // container.maskRect = GRect(
    //   -maskOff,
    //   -maskOff,
    //   allDotsWidth + maskOff * 2,
    //   dotSize + maskOff * 2,
    // );
    // container.maskRect.corners.allTo(dotSize);
    /// -- end masking.

    /// only for testing.
    stage.keyboard.focusNode.requestFocus();
    stage.keyboard.onDown.add((event) {
      if (event.arrowLeft) {
        moveDir(-1);
      } else if (event.arrowRight) {
        moveDir(1);
      }
    });

    stage.onResized.add(() {
      var ratioScale = sw / allDotsWidth;
      scale = ratioScale;

      /// center it (not using alignPivot())
      y = (sh - (dotSize * ratioScale)) / 2;
    });

    // force first rebuild.
    _currentIndex = -1;
    currentIndex = 0;
  }

  void moveDir(int dir) {
    currentIndex += dir;
  }

  int get currentIndex => _currentIndex;

  double _targetScroll = 0.0;

  @override
  void update(double delta) {
    super.update(delta);
    _updateScroll();
    _resizeItems();
    _positionItems();
  }

  set currentIndex(int value) {
    if (value == _currentIndex) return;
    // reset all sizes.
    _currentIndex = value.clamp(0, _numItems - 1);

    /// offset scroll.
    if (_currentIndex > _visibleItems - 1) {
      var offset = _visibleItems - 1 - _currentIndex;
      _scroll = offset;
      if (_currentIndex == _numItems - 1) {
        _scroll += 1;
      }
      _targetScroll = _scroll * (dotSize + dotSep);
    } else {
      _scroll = 0;
      _targetScroll = 0;
    }
    var firstIndex = -_scroll;
    for (final dot in _dots) {
      var targetAlpha = 1.0;
      if (dot.id < firstIndex || dot.id > firstIndex + _visibleItems) {
        targetAlpha = 0.3;
      }
      dot.tween(
        duration: .3,
        colorize: dotUnselectedColor,
        alpha: targetAlpha,
      );
      dot.targetSize = dotSize;
    }

    prevDot?.targetSize = dotPreW;
    nextDot?.targetSize = dotPreW;

    nextDot?.tween(duration: .3, colorize: dotPreColor, overwrite: 0);
    prevDot?.tween(duration: .3, colorize: dotPreColor, overwrite: 0);
    // nextDot?.color = dotPreColor;
    // prevDot?.color = dotPreColor;

    currDot?.targetSize = dotSelectedW;
    currDot?.tween(duration: .3, colorize: dotSelectedColor, overwrite: 0);
    // _positionItems();
  }

  void _positionItems() {
    var lastX = 0.0;
    for (var i = 0; i < _dots.length; ++i) {
      var dot = _dots[i];
      // dot.x = lastX;
      dot.x += (lastX - dot.x) / 4;
      lastX += dot.size + dotSep;
    }
  }

  void _resizeItems() {
    for (var i = 0; i < _dots.length; ++i) {
      var dot = _dots[i];
      dot.size += (dot.targetSize - dot.size) / 10;
    }
  }

  PageDot get currDot {
    return _dots[_currentIndex];
  }

  PageDot get prevDot {
    if (_currentIndex == 0) return null;
    return _dots[_currentIndex - 1];
  }

  PageDot get nextDot {
    if (_currentIndex >= _numItems - 1) return null;
    return _dots[_currentIndex + 1];
  }

  void _updateScroll() {
    var distance = _targetScroll - scrollContainer.x;
    if (distance.abs() < .5) {
      scrollContainer.x = _targetScroll;
      return;
    }
    scrollContainer.x += distance / 12;
  }
}
