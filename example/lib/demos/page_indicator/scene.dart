import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../../utils/base_scene.dart';
import 'dot.dart';

/// Sample fot Ismail, need to integrate a controller to get the PageView
/// events.
///
class PageIndicatorPaged extends BaseScene {
  PageIndicatorPaged();

  late List<PageDot> _dots;
  static const double dotSize = 13;
  static const double dotPreW = 18;
  static const double dotSelectedW = 34;
  static const dotUnselectedColor = Color(0xffC4C4C4);
  static const dotSelectedColor = Colors.red;
  static const dotPreColor = Colors.blue;

  late GSprite container;
  late GSprite scrollContainer;

  int _currentIndex = 0;
  final int _visibleItems = 5;
  final int _numItems = 10;
  int _scroll = 0;
  double _allDotsWidth = 0;

  double dotSep = 3;

  /// Easing for euler integration.
  /// The bigger number, the slower transitions.
  double scrollEase = 10;
  double dotSizeEase = 10;
  double dotPositionEase = 3;

  @override
  void addedToStage() {
    super.addedToStage();
    // stage.color = Color(0xffD1D1D);

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
    _allDotsWidth =
        itemWS * (_visibleItems - 3) + (dotPreW + dotSep) * 2 + dotSelectedW;

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
    //   _allDotsWidth + maskOff * 2,
    //   dotSize + maskOff * 2,
    // );
    // container.maskRect.corners.allTo(dotSize);

    /// -- end masking.

    /// only for testing.
    stage!.keyboard.focusNode.requestFocus();
    stage!.keyboard.onDown.add((event) {
      if (event.arrowLeft) {
        moveDir(-1);
      } else if (event.arrowRight) {
        moveDir(1);
      }
    });

    stage!.onResized.add(() {
      var ratioScale = sw / _allDotsWidth;
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
    _layoutDots();
  }

  set currentIndex(int value) {
    if (value == _currentIndex) return;
    // reset all sizes.
    _currentIndex = value.clamp(0, _numItems - 1);

    /// offset scroll.
    /// -2 = take off mid size items.
    if (_currentIndex > _visibleItems - 2) {
      var offset = _visibleItems - 2 - _currentIndex;
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
    for (var dot in _dots) {
      var targetAlpha = 1.0;
      if (dot.id < firstIndex || dot.id > firstIndex + (_visibleItems - 1)) {
        targetAlpha = 0;
      }
      dot.tween(
        duration: .3,
        alpha: targetAlpha,

        /// for a zoom in effect
        // scale: targetAlpha == 1 ? 1 : .25,
        // y: targetAlpha == 1 ? 0.0 : dotSize / 2,
      );
      dot.targetColor = dotUnselectedColor;
      dot.targetSize = dotSize;
    }

    prevDot?.targetSize = dotPreW;
    nextDot?.targetSize = dotPreW;

    /// color is computed internally in the dot to avoid
    /// the expensize "colorize".
    nextDot?.targetColor = dotPreColor;
    prevDot?.targetColor = dotPreColor;
    currDot.targetSize = dotSelectedW;
    currDot.targetColor = dotSelectedColor;
  }

  void _layoutDots() {
    var lastX = 0.0;
    for (var i = 0; i < _dots.length; ++i) {
      var dot = _dots[i];
      var sizeDistance = dot.targetSize! - dot.size;
      if (sizeDistance.abs() < .1) {
        dot.size = dot.targetSize!;
      } else {
        dot.size += sizeDistance / dotSizeEase;
      }
      var posDistance = lastX - dot.x;
      if (posDistance.abs() < .1) {
        dot.x = lastX;
      } else {
        dot.x += posDistance / dotPositionEase;
      }
      lastX += dot.size + dotSep;
    }
  }

  PageDot get currDot {
    return _dots[_currentIndex];
  }

  PageDot? get prevDot {
    if (_currentIndex == 0) return null;
    return _dots[_currentIndex - 1];
  }

  PageDot? get nextDot {
    if (_currentIndex >= _numItems - 1) return null;
    return _dots[_currentIndex + 1];
  }

  void _updateScroll() {
    var distance = _targetScroll - scrollContainer.x;
    if (distance.abs() < .1) {
      scrollContainer.x = _targetScroll;
      return;
    }
    scrollContainer.x += distance / scrollEase;
  }
}
