import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:graphx/graphx/events/mixins.dart';
import 'package:graphx/graphx/geom/gxmatrix.dart';
import 'package:graphx/graphx/geom/gxpoint.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/utils/math_utils.dart';
import 'package:graphx/graphx/utils/painter_utils.dart';

import 'display_object_container.dart';
import 'stage.dart';

abstract class DisplayObject with DisplayListSignalsMixin {
  Canvas $canvas;
  DisplayObjectContainer $parent;

  Rect _nativeBounds;

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (DisplayObject)$msg';
  }

  double get mouseX {
    if (inStage) {
      return globalToLocal(_sHelperPoint.setTo(stage.pointer.mouseX, 0)).x;
    } else {
      throw "To get mouseX object needs to be a descendant of Stage.";
    }
  }

  double get mouseY {
    if (inStage) {
      return globalToLocal(_sHelperPoint.setTo(0, stage.pointer.mouseY)).y;
    } else {
      throw "To get mouseY object needs to be a descendant of Stage.";
    }
  }

  GxPoint get mousePosition {
    if (!inStage)
      throw "To get mousePosition, the object needs to be in the Stage.";
    return globalToLocal(_sHelperPoint.setTo(
      stage.pointer.mouseX,
      stage.pointer.mouseY,
    ));
  }

  Object userData;
  String name;

  double _x = 0, _y = 0, _scaleX = 1, _scaleY = 1, _rotation = 0;
  double _pivotX = 0, _pivotY = 0;
  double _skewX = 0, _skewY = 0;

  double get x => _x;

  double get y => _y;

  double get scaleX => _scaleX;

  double get scaleY => _scaleY;

  double get pivotX => _pivotX;

  double get pivotY => _pivotY;

  double get skewX => _skewX;

  double get skewY => _skewY;

  double get rotation => _rotation;

  double get width => getBounds($parent, _sHelperRect).width;

  double get height => getBounds($parent, _sHelperRect).height;

  set width(double value) {
    double actualW;
    bool zeroScale = _scaleX < 1e-8 && _scaleX > -1e-8;
    if (zeroScale) {
      scaleX = 1.0;
      actualW = width;
    } else {
      actualW = (width / _scaleX).abs();
    }
    if (actualW != null) scaleX = value / actualW;
  }

  set height(double value) {
    double actualH;
    bool zeroScale = _scaleY < 1e-8 && _scaleY > -1e-8;
    if (zeroScale) {
      scaleY = 1.0;
      actualH = height;
    } else {
      actualH = (height / _scaleY).abs();
    }
    if (actualH != null) scaleY = value / actualH;
  }

  set x(double value) {
    if (_x == value) return;
    _x = value;
    $setTransformationChanged();
  }

  set y(double value) {
    if (_y == value) return;
    _y = value;
    print("Redraw u::: $y");
    $setTransformationChanged();
  }

  set scaleX(double value) {
    if (_scaleX == value) return;
    _scaleX = value;
    $setTransformationChanged();
  }

  set scaleY(double value) {
    if (_scaleY == value) return;
    _scaleY = value;
    $setTransformationChanged();
  }

  set pivotX(double value) {
    if (_pivotX == value) return;
    _pivotX = value;
    $setTransformationChanged();
  }

  set pivotY(double value) {
    if (_pivotY == value) return;
    _pivotY = value;
    $setTransformationChanged();
  }

  set skewX(double value) {
    if (_skewX == value) return;
    _skewX = value;
    $setTransformationChanged();
  }

  set skewY(double value) {
    if (_skewY == value) return;
    _skewY = value;
    $setTransformationChanged();
  }

  set rotation(double value) {
    if (_rotation == value) return;
    _rotation = value;
    $setTransformationChanged();
  }

  double _alpha = 1;

  double get alpha => _alpha;

  set alpha(double value) {
    if (_alpha != value) {
      value ??= 1;
      _alpha = value.clamp(0.0, 1.0);
      requiresRedraw();
    }
  }

  bool get isRotated => _rotation != 0 || _skewX != 0 || _skewY != 0;

  bool $matrixDirty = true;
  bool touchable = true;

  DisplayObject _maskee;
  DisplayObject $mask;
  bool maskInverted = false;

  /// optimization.
  bool $hasVisibleArea = true;

  bool get isMask => _maskee != null;

  DisplayObject get mask => $mask;

  set mask(DisplayObject value) {
    if ($mask != value) {
      if ($mask != null) $mask._maskee = null;
      value?._maskee = this;
      value?.$hasVisibleArea = false;
      $mask = value;
      requiresRedraw();
    }
  }

  /// to detect matrix change.
  bool _transformationChanged = false;

  void $setTransformationChanged() {
    _transformationChanged = true;
    requiresRedraw();
  }

  /// common parent.
  static List<DisplayObject> _sAncestors = [];
  static GxPoint _sHelperPoint = GxPoint();
  static GxRect _sHelperRect = GxRect();
  static GxMatrix _sHelperMatrix = GxMatrix();
  static GxMatrix _sHelperMatrixAlt = GxMatrix();

  double get worldAlpha => alpha * ($parent?.worldAlpha ?? 1);

  double get worldScaleX => scaleX * ($parent?.worldScaleX ?? 1);

  double get worldScaleY => scaleX * ($parent?.worldScaleY ?? 1);

  double get worldX => x - pivotX * scaleX + ($parent?.worldX ?? 0);

  double get worldY => y - pivotY * scaleY + ($parent?.worldY ?? 0);
  bool visible = true;

  DisplayObject() {
    x = y = 0.0;
    rotation = 0.0;
    alpha = 1.0;
    pivotX = pivotY = 0.0;
    scaleX = scaleY = 1.0;
    skewX = skewX = 0.0;
    touchable = true;
  }

  GxRect _cachedBounds;

  void alignPivot([Alignment alignment = Alignment.center]) {
    var bounds = getBounds(this, _sHelperRect);
    print("Is empty?! ${bounds.isEmpty}");
    if (bounds.isEmpty) return;
    var ax = 0.5 + alignment.x / 2;
    var ay = 0.5 + alignment.y / 2;
    _pivotX = bounds.x + bounds.width * ax;
    _pivotY = bounds.y + bounds.height * ay;
  }

  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    throw "getBounds() is abstract in DisplayObject";
  }

  GxPoint globalToLocal(GxPoint globalPoint, [GxPoint out]) {
    getTransformationMatrix(base, _sHelperMatrixAlt);
    _sHelperMatrixAlt.invert();
    return _sHelperMatrixAlt.transformPoint(globalPoint, out);
  }

  GxPoint localToGlobal(GxPoint localPoint, [GxPoint out]) {
    getTransformationMatrix(base, _sHelperMatrixAlt);
    return _sHelperMatrixAlt.transformPoint(localPoint, out);
  }

  GxMatrix _transformationMatrix;

  GxMatrix get transformationMatrix {
    if (_transformationChanged || _transformationMatrix == null) {
      _transformationChanged = false;
      _transformationMatrix ??= GxMatrix();
//      _transformationMatrix.setTransform(
//        x,
//        y,
//        pivotX,
//        pivotY,
//        scaleX,
//        scaleY,
//        skewX,
//        skewY,
//        rotation,
//      );
      $updateTransformationMatrices(
        x,
        y,
        pivotX,
        pivotY,
        scaleX,
        scaleY,
        skewX,
        skewY,
        rotation,
        _transformationMatrix,
      );
    }
    return _transformationMatrix;
  }

  set transformationMatrix(GxMatrix matrix) {
    const pi_q = math.pi / 4.0;
    requiresRedraw();
    _transformationChanged = false;
    _transformationMatrix ??= GxMatrix();
    _transformationMatrix.copyFrom(matrix);
    _pivotX = _pivotY = 0;
    _x = matrix.tx;
    _y = matrix.ty;
    _skewX = math.atan(-matrix.c / matrix.d);
    _skewY = math.atan(matrix.b / matrix.a);
    _scaleY = (_skewX > -pi_q && _skewX < pi_q)
        ? matrix.d / math.cos(_skewX)
        : -matrix.c / math.sin(_skewX);
    _scaleX = (_skewY > -pi_q && _skewY < pi_q)
        ? matrix.a / math.cos(_skewY)
        : -matrix.b / math.sin(_skewY);
    if (MathUtils.isEquivalent(_skewX, _skewY)) {
      _rotation = _skewX;
      _skewX = _skewY = 0;
    } else {
      _rotation = 0;
    }
  }

  void $updateTransformationMatrices(
    double x,
    double y,
    double pivotX,
    double pivotY,
    double scaleX,
    double scaleY,
    double skewX,
    double skewY,
    double rotation,
    GxMatrix out,
  ) {
    out.identity();
    if (skewX == 0 && skewY == 0) {
      /// optimization, no skewing.
      if (rotation == 0) {
        out.setTo(
          scaleX,
          0,
          0,
          scaleY,
          x - pivotX * scaleX,
          y - pivotY * scaleY,
        );
      } else {
        double cos = math.cos(rotation);
        double sin = math.sin(rotation);
        double a = scaleX * cos;
        double b = scaleX * sin;
        double c = scaleY * -sin;
        double d = scaleY * cos;
        double tx = x - pivotX * a - pivotY * c;
        double ty = y - pivotX * b - pivotY * d;
        out.setTo(a, b, c, d, tx, ty);
      }
    } else {
      out.identity();
      out.scale(scaleX, scaleY);
      out.skew(skewX, skewY); // MatrixUtils.skew(out, skewX, skewY);
      out.rotate(rotation);
      out.translate(x, y);
      if (pivotX != 0 || pivotY != 0) {
        out.tx = x - out.a * pivotX - out.c * pivotY;
        out.ty = y - out.b * pivotX - out.d * pivotY;
      }
    }
  }

  GxMatrix getTransformationMatrix(DisplayObject targetSpace, [GxMatrix out]) {
    DisplayObject commonParent, currentObj;
    out?.identity();
    out ??= GxMatrix();
    if (targetSpace == this) {
      return out;
    }
    if (targetSpace == $parent || (targetSpace == null && $parent == null)) {
      out.copyFrom(transformationMatrix);
      return out;
    }
    if (targetSpace == null || targetSpace == base) {
      currentObj = this;
      while (currentObj != targetSpace) {
        out.concat(currentObj.transformationMatrix);
        currentObj = currentObj.$parent;
      }
      return out;
    }
    if (targetSpace.$parent == this) {
      // optimization.
      targetSpace.getTransformationMatrix(this, out);
      out.invert();
      return out;
    }

    /// 1 - find a common parent between this and targetSpace.
    commonParent = DisplayObject._findCommonParent(this, targetSpace);

    /// 2 - moveup from this to common parent.````
    currentObj = this;
    while (currentObj != commonParent) {
      out.concat(currentObj.transformationMatrix);
      currentObj = currentObj.$parent;
    }

    if (commonParent == targetSpace) return out;

    /// 3. move up from target until we reach common parent.
    _sHelperMatrix.identity();
    currentObj = targetSpace;
    while (currentObj != commonParent) {
      _sHelperMatrix.concat(currentObj.transformationMatrix);
      currentObj = currentObj.$parent;
    }

    /// 4. combine the matrices.
    _sHelperMatrix.invert();
    out.concat(_sHelperMatrix);
    return out;
  }

  static DisplayObject _findCommonParent(
      DisplayObject obj1, DisplayObject obj2) {
    DisplayObject current = obj1;

    /// TODO: use faster Hash access.
    while (current != null) {
      _sAncestors.add(current);
      current = current.$parent;
    }
    current = obj2;
    while (current != null && _sAncestors.indexOf(current) == -1) {
      current = current.$parent;
    }
    _sAncestors.length = 0;
    if (current != null) return current;
    throw "Object not connected to target";
  }

  bool hitTestMask(GxPoint localPoint) {
    if ($mask == null) return true;
    if ($mask.inStage) {
      getTransformationMatrix($mask, _sHelperMatrixAlt);
    } else {
      _sHelperMatrixAlt.copyFrom($mask.transformationMatrix);
      _sHelperMatrixAlt.invert();
    }
    var helperPoint = localPoint == _sHelperPoint ? GxPoint() : _sHelperPoint;
    _sHelperMatrixAlt.transformPoint(localPoint, helperPoint);
    final isHit = mask.hitTest(helperPoint) != null;
    return maskInverted ? !isHit : isHit;
  }

  DisplayObject hitTest(GxPoint localPoint) {
    if (!visible || !touchable) return null;
    if ($mask != null && !hitTestMask(localPoint)) return null;
    if (getBounds(this, _sHelperRect).containsPoint(localPoint)) return this;
    return null;
  }

  DisplayObjectContainer get parent => $parent;

  DisplayObject get base {
    var current = this;
    while (current.$parent != null) current = current.$parent;
    return current;
  }

  bool get inStage => base is Stage;

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
  void requiresRedraw() {
    /// TODO: notify parent the current state of this DisplayObject.
    $hasVisibleArea = _alpha != 0 &&
        visible &&
        _maskee == null &&
        _scaleX != 0 &&
        scaleY != 0;
  }

  void paint(Canvas canvas) {
    $canvas = canvas;
    if (!$hasVisibleArea) return;
    final _hasScale = _scaleX != 1 || _scaleY != 1;
    final _hasTranslate = _x != 0 || _y != 0;
    final _hasPivot = _pivotX != 0 || _pivotX != 0;
    final _hasSkew = _skewX != 0 || _skewY != 0;
    final needSave =
        _hasTranslate || _hasScale || rotation != 0 || _hasPivot || _hasSkew;
    final _saveLayer = this is DisplayObjectContainer &&
        (this as DisplayObjectContainer).hasChildren &&
        _alpha != 1;
    if (needSave) {
      canvas.save();

      /// use toggle for matrix transform.
      canvas.transform(transformationMatrix.toNative().storage);

//      if (_hasTranslate) {
//        canvas.translate(x, y);
//      }
//      if (rotation != 0) {
//        canvas.rotate(rotation);
//      }
//      if (_hasScale) {
//        canvas.scale(scaleX, scaleY);
//      }
//      if (_hasPivot) {
//        canvas.translate(-pivotX, -pivotY);
//      }
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
    if (_saveLayer) {
      final alphaPaint = PainterUtils.getAlphaPaint(_alpha);
      final rect = getBounds(this).toNative();
      canvas.saveLayer(rect, alphaPaint);
//      canvas.saveLayer(_nativeBounds, alphaPaint);
    }
//    if (worldAlpha != 1) {
//      final alphaPaint = GraphxUtils.getAlphaPaint(alpha);
//      canvas.saveLayer(getBounds(), alphaPaint);
//    }
    $applyPaint();
//    _onPostPaint?.dispatch();
    if (_saveLayer) {
      canvas.restore();
    }
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
    userData = null;
    name = null;
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

  void setPosition(double x, double y) {
    _x = x;
    _y = y;
    $setTransformationChanged();
  }

  void setScale(double scaleX, double scaleY) {
    _scaleX = scaleX;
    _scaleY = scaleY;
    $setTransformationChanged();
  }
}
