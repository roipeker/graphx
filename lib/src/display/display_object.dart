import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../graphx.dart';
import 'display_object_container.dart';
import 'stage.dart';

abstract class IAnimatable
    with DisplayListSignalsMixin, RenderSignalMixin, PointerSignalsMixin {
  Canvas $canvas;
  DisplayObjectContainer $parent;

  bool $debugBounds = false;

  /// capture context mouse inputs.
  void captureMouseInput(PointerEventData e) {
    if (!$hasVisibleArea || !touchable) return;
    if (e.captured && e.type == PointerEventType.up) {
      /// mouse down node = null
    }
//    print("Capturing mouse data! $runtimeType");
    bool prevCaptured = e.captured;

    /// loop down for hit test.
    final localCoord = globalToLocal(e.stagePosition);
    if (hitTouch(localCoord)) {
      $dispatchMouseCallback(e.type, this, e);
    }
  }

  static IAnimatable $mouseObjDown;
  static IAnimatable $mouseObjHover;

  void $dispatchMouseCallback(
    PointerEventType type,
    IAnimatable object,
    PointerEventData input,
  ) {
    if (touchable) {
      var mouseInput = input.clone(this, object, type);
      switch (type) {
        case PointerEventType.down:
          $mouseObjDown = object;
          $onDown?.dispatch(mouseInput);
          break;
        case PointerEventType.up:
          if ($mouseObjDown == object && $onClick != null) {
            var mouseClickInput =
                input.clone(this, object, PointerEventType.up);
            $onClick?.dispatch(mouseClickInput);

            /// todo: double click time.
          }
          $mouseObjDown = null;
          $onUp?.dispatch(mouseInput);
          break;

        /// todo: hover/out.
        case PointerEventType.hover:
          $mouseObjHover = object;
          $onHover?.dispatch(mouseInput);
          break;
        case PointerEventType.scroll:
          $onScroll?.dispatch(mouseInput);
          break;
        default:
          break;
      }
    }
    $parent?.$dispatchMouseCallback(type, object, input);
  }

  /// todo: add caching to local bounds (Rect).
//  Rect _nativeBounds;
//  GxRect _cachedBounds;

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

  /// You can store any user defined data in this property for easy access.
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

  double $alpha = 1;

  double get alpha => $alpha;

  set alpha(double value) {
    if ($alpha != value) {
      value ??= 1;
      $alpha = value.clamp(0.0, 1.0);
      requiresRedraw();
    }
  }

  bool get isRotated => _rotation != 0 || _skewX != 0 || _skewY != 0;

  bool $matrixDirty = true;
  bool touchable = true;

  IAnimatable $maskee;
  IAnimatable $mask;
  bool maskInverted = false;

  /// optimization.
  bool $hasVisibleArea = true;

  bool get isMask => $maskee != null;

  IAnimatable get mask => $mask;

  static final Paint _grayscaleDstInPaint = Paint()
    ..blendMode = BlendMode.dstIn
    ..colorFilter = const ColorFilter.matrix(<double>[
      0, 0, 0, 0, 0, //
      0, 0, 0, 0, 0,
      0, 0, 0, 0, 0,
      0.2126, 0.7152, 0.0722, 0, 0,
    ]);

  set mask(IAnimatable value) {
    if ($mask != value) {
      if ($mask != null) $mask.$maskee = null;
      value?.$maskee = this;
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
  static List<IAnimatable> _sAncestors = [];
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

  IAnimatable() {
    x = y = 0.0;
    rotation = 0.0;
    alpha = 1.0;
    pivotX = pivotY = 0.0;
    scaleX = scaleY = 1.0;
    skewX = skewX = 0.0;
    touchable = true;
  }

  void alignPivot([Alignment alignment = Alignment.center]) {
    var bounds = getBounds(this, _sHelperRect);
    if (bounds.isEmpty) return;
    var ax = 0.5 + alignment.x / 2;
    var ay = 0.5 + alignment.y / 2;
    pivotX = bounds.x + bounds.width * ax;
    pivotY = bounds.y + bounds.height * ay;
  }

  /// local bounds
  /// todo: should be cached.
  GxRect get bounds => getBounds(this);

  GxRect getBounds(IAnimatable targetSpace, [GxRect out]) {
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

  GxMatrix getTransformationMatrix(IAnimatable targetSpace, [GxMatrix out]) {
    IAnimatable commonParent, currentObj;
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
    commonParent = IAnimatable._findCommonParent(this, targetSpace);

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

  static IAnimatable _findCommonParent(IAnimatable obj1, IAnimatable obj2) {
    IAnimatable current = obj1;

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

  bool hitTouch(GxPoint localPoint, [bool useShape = false]) {
    return hitTest(localPoint, useShape) != null;
  }

  /// `useShape` is meant to be used by `Shape.graphics`.
  IAnimatable hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !touchable) return null;
    if ($mask != null && !hitTestMask(localPoint)) return null;
    if (getBounds(this, _sHelperRect).containsPoint(localPoint)) return this;
    return null;
  }

  DisplayObjectContainer get parent => $parent;

  IAnimatable get base {
    var current = this;
    while (current.$parent != null) current = current.$parent;
    return current;
  }

  bool get inStage => base is Stage;

  Stage get stage => base is Stage ? base : null;

  IAnimatable get root {
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
    $hasVisibleArea = $alpha != 0 &&
        visible &&
        $maskee == null &&
        _scaleX != 0 &&
        _scaleY != 0;
  }

  /// Do not override this method as it applies the basic transformations.
  /// override $applyPaint() if you wanna use `Canvas` directly.
  void paint(Canvas canvas) {
    $canvas = canvas;
    if (!$hasVisibleArea || !visible) return;
    final _hasScale = _scaleX != 1 || _scaleY != 1;
    final _hasTranslate = _x != 0 || _y != 0;
    final _hasPivot = _pivotX != 0 || _pivotX != 0;
    final _hasSkew = _skewX != 0 || _skewY != 0;
    final needSave =
        _hasTranslate || _hasScale || rotation != 0 || _hasPivot || _hasSkew;
    bool _saveLayer = this is DisplayObjectContainer &&
        (this as DisplayObjectContainer).hasChildren &&
        $alpha != 1;

    final hasMask = mask != null;
    final maskIsGraphics = hasMask ? mask is Shape : false;

    if (hasMask && !maskIsGraphics) {
      _saveLayer = true;
    }

    if (_saveLayer) {
      final alphaPaint = PainterUtils.getAlphaPaint($alpha);
      final rect = getBounds(this).toNative();
      canvas.saveLayer(null, alphaPaint);
    }
    if (needSave) {
      canvas.save();
      canvas.transform(transformationMatrix.toNative().storage);
    }

    if (hasMask && maskIsGraphics) {
//      final g = (mask as Shape).graphics;
//      if (g != null) {
//        g.paint($canvas);
//      }
//      (mask as Shape).graphics.getPaths();
      mask.$canvas = canvas;
      mask.$applyPaint();
    }

//    if (_graphics != null) {
//      _graphics?.alpha = worldAlpha;
//      _graphics?.paint(canvas);
//    }
//    canvas.drawColor(Color(0xfffffff).withOpacity(.8), BlendMode.softLight);

    $onPrePaint?.dispatch();
    $applyPaint();
    $onPostPaint?.dispatch();

    if (hasMask && !maskIsGraphics) {
      final maskPaint = Paint();
      maskPaint.blendMode = BlendMode.dstIn;
//      maskPaint.blendMode = BlendMode.srcOver;
      final rect = getBounds(this).toNative();
//      canvas.transform(transformationMatrix.invert().toNative().storage);
//      canvas.saveLayer(null, _grayscaleDstInPaint);
      canvas.saveLayer(null, maskPaint);
      mask.$canvas = canvas;
//      mask.paint(canvas);
      mask.$applyPaint();
      canvas.restore();
//      mask.$applyPaint();
    }

    if (needSave) {
      canvas.restore();
    }
    if ($debugBounds) {
      final rect = getBounds(this).toNative();
      canvas.drawLine(rect.topLeft, rect.bottomRight, _debugPaint);
      canvas.drawLine(rect.topRight, rect.bottomLeft, _debugPaint);
      canvas.drawRect(rect, _debugPaint);
    }

    if (_saveLayer) {
      canvas.restore();
    }
  }

  static Paint _debugPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Color(0xff00FFFF)
    ..strokeWidth = 0;

  /// override this method for custom drawing using Flutter's API.
  /// Access `$canvas` from here.
  void $applyPaint() {}

  @mustCallSuper
  void dispose() {
//    _stage = null;
    $parent = null;
    userData = null;
    name = null;
    $disposeDisplayListSignals();
    $disposeRenderSignals();
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

  /// shortcut to scale proportionally
  double get scale => _scaleX;

  set scale(double value) {
    if (value == _scaleX) return;
    _scaleY = _scaleX = value;
    $setTransformationChanged();
  }

  void setPosition(double x, double y) {
    _x = x;
    _y = y;
    $setTransformationChanged();
  }

  void setScale(double scaleX, [double scaleY]) {
    _scaleX = scaleX;
    _scaleY = scaleY ?? scaleX;
    $setTransformationChanged();
  }

  /// ---- capture texture feature ---
  /// When you create a picture it takes the current state of the DisplayObject.
  /// Beware to call this before applying any
  /// transformations (x, y, scale, etc) if you intend to use in it's "original"
  /// form.
  Picture createPicture([void Function(Canvas) prepaintCallback]) {
    final r = PictureRecorder();
    final c = Canvas(r);
    prepaintCallback?.call(c);
    this.paint(c);
    return r.endRecording();
  }

  Future<GxTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
    GxRect rect,
  ]) async {
    final img = await createImage(adjustOffset, resolution, rect);

    /// get transformation.
    var tx = GxTexture(img, null, false, resolution);
    tx.anchorX = bounds.x;
    tx.anchorY = bounds.y;
    return tx;
  }

  Future<Image> createImage([
    bool adjustOffset = true,
    double resolution = 1,
    GxRect rect,
  ]) async {
    rect ??= getBounds($parent);
    if (resolution != 1) {
      rect *= resolution;
    }
    final needsAdjust =
        (rect.left != 0 || rect.top != 0) && adjustOffset || resolution != 1;

    final picture = createPicture(
      !needsAdjust
          ? null
          : (Canvas c) {
              if (adjustOffset) {
                c.translate(-rect.left, -rect.top);
              }
              if (resolution != 1) {
                c.scale(resolution);
              }
            },
    );
    final int width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final int height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = await picture.toImage(width, height);
    picture?.dispose();
    return output;
  }
}
