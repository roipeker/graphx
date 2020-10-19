import 'dart:ui';

import 'package:graphx/graphx/events/mixins.dart';
import 'package:graphx/graphx/geom/gxrect.dart';

import 'display_object_container.dart';
import 'stage.dart';

abstract class DisplayObject with DisplayListSignalsMixin {
  Canvas $canvas;

//  Stage get stage => _stage;
//  set $stage(Stage value) {
//    if (stage == value) return;
//    _stage = value;
//    if (_stage != null) {
//      $onAddedToStage?.dispatch();
//    } else {
//      $onRemovedFromStage?.dispatch();
//    }
//  }

  Object userData;
  String name;

  double x, y, scaleX, scaleY, rotation;
  double pivotX, pivotY;
  double alpha;

  double get worldAlpha => alpha * ($parent?.worldAlpha ?? 1);

  double get worldScaleX => scaleX * ($parent?.worldScaleX ?? 1);

  double get worldScaleY => scaleX * ($parent?.worldScaleY ?? 1);

  double get worldX => x - pivotX * scaleX + ($parent?.worldX ?? 0);

  double get worldY => y - pivotY * scaleY + ($parent?.worldY ?? 0);
  bool visible = true;

  DisplayObject() {
    x = y = 0;
    rotation = 0;
    alpha = 1;
    pivotX = pivotY = 0;
    scaleX = scaleY = 1;
  }

  GxRect _cachedBounds;

  GxRect getBounds([double w = 0, double h = 0]) {
    _cachedBounds ??= GxRect();
    _cachedBounds.setTo(x, y, w, h);
    return _cachedBounds;
  }

  DisplayObjectContainer $parent;

  DisplayObjectContainer get parent => $parent;

  DisplayObject get base {
    var current = this;
    while (current.$parent != null) current = current.$parent;
    return current;
  }

  Stage get stage => base is Stage ? base : null;

  DisplayObject get root {
    var current = this;
    while (current.$parent != null) {
      if (current.$parent is Stage) return current;
      current = current.$parent;
    }
    return null;
  }

  /// rendering.
  void requiresRedraw() {}

  void paint(Canvas canvas) {
    $canvas = canvas;
    if (!visible) return;
    final _hasScale = scaleX != 1 || scaleY != 1;
    final _hasTranslate = x != 0 || y != 0;
    final _hasPivot = pivotX != 0 || pivotY != 0;
    final needSave = _hasTranslate || _hasScale || rotation != 0 || _hasPivot;
    if (needSave) {
      canvas.save();
      if (_hasTranslate) {
        canvas.translate(x, y);
      }
      if (rotation != 0) {
        canvas.rotate(rotation);
      }
      if (_hasScale) {
        canvas.scale(scaleX, scaleY);
      }
      if (_hasPivot) {
        canvas.translate(-pivotX, -pivotY);
      }
//      if (_hasSkew) {
//        canvas.skew(skewX, skewY);
//      }
    }

//    if (mask != null) {
//      canvas.clipPath(path)
//    }
//    if (_graphics != null) {
//      _graphics?.alpha = worldAlpha;
//      _graphics?.paint(canvas);
//    }
//    canvas.drawColor(Color(0xfffffff).withOpacity(.8), BlendMode.softLight);
//    if (worldAlpha != 1) {
//      final alphaPaint = GraphxUtils.getAlphaPaint(alpha);
//      canvas.saveLayer(getBounds(), alphaPaint);
//    }
    $applyPaint();
//    _onPostPaint?.dispatch();
//    if (worldAlpha != 1) {
//      canvas.restore();
//    }
//    if (alpha != 1) {
//      canvas.drawPaint(Paint()..color = Color(0xfffffff).withOpacity(alpha));
//    }
//    _paintChildren();
    if (needSave) {
      canvas.restore();
    }
  }

  void $applyPaint() {}

  void dispose() {
//    _stage = null;
    $parent = null;
    $disposeDisplayListSignals();
  }

  void removeFromParent([bool dispose = false]) {
    $parent?.removeChild(this, dispose);
  }

  /// internal
  void $setParent(DisplayObjectContainer value) {
    var ancestor = value;
    while (ancestor != this && ancestor != null) ancestor = ancestor.$parent;
    if (ancestor == this) {
      throw ArgumentError(
          "An object cannot be added as a child to itself or one "
          "of its children (or children's children, etc.)");
    } else {
      $parent = value;
    }
  }

//  /** @private */
//  starling_internal function setParent(value:DisplayObjectContainer):void
//  {
//  // check for a recursion
//  var ancestor:DisplayObject = value;
//  while (ancestor != this && ancestor != null)
//  ancestor = ancestor._parent;
//
//  if (ancestor == this)
//  throw new ArgumentError("An object cannot be added as a child to itself or one " +
//  "of its children (or children's children, etc.)");
//  else
//  _parent = value;
//}

}
