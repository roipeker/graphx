import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as painting;

import '../../graphx.dart';

/// An abstract class that represents a display object in GraphX.
///
/// This class is the base for all visual objects in GraphX, and provides
/// functionality for positioning, scaling, rotating, and transforming
/// display objects. It also provides mouse and touch event handling,
/// masking, and filtering capabilities.
///
/// Use [GDisplayObject] to create a display object that can be added to a
/// [GDisplayObjectContainer] (like GSprite).
///
/// To move or scale the display object, you can use the properties
/// [x], [y], [scaleX], [scaleY], [pivotX], and [pivotY].
/// Rotation can be set using the [rotation] property,
/// and skew using [skewX] and [skewY].
///
/// Display objects can also be made draggable using the [startDrag] method.
/// This will attach an event listener to the stage to
/// detect mouse movement and update the object's position accordingly.
///
/// By default, a display object can receive mouse input events such as
/// [onMouseDown], [onMouseUp], and [onMouseClick].
/// Use the [mouseEnabled] property to disable mouse input events for a specific
/// display object.
///
/// Display objects can also be assigned a [mask] to create a clipping region.
/// The mask must be a [GShape] object.
/// By default, the mask is not inverted.
/// Set the [maskInverted] property to true to invert the [mask].
///
abstract class GDisplayObject
    with
        DisplayListSignalsMixin,
        RenderSignalMixin,
        MouseSignalsMixin,
        DisplayMasking {
  /// TODO: add caching to local bounds (Rect).
  //  Rect _nativeBounds;
  //  GxRect _cachedBounds;

  /// (Internal usage)
  /// The current display object that is being dragged.
  static GDisplayObject? $currentDrag;

  /// (Internal usage)
  /// The bounds for the current drag.
  static GRect? $currentDragBounds;

  static bool _isWarned3d = false;

  /// common parent.
  /// A list that contains the ancestors of this object, starting with the
  /// immediate parent and going up the display list hierarchy.
  static final List<GDisplayObject> _sAncestors = [];

  /// A helper point used for various calculations.
  static final GPoint _sHelperPoint = GPoint();

// DisplayObject get dropTarget {
//   if ($parent == null || !$hasVisibleArea || !inStage) return null;
//   if ($parent.children.length > 1) {
//     GxRect rect;
//     $parent.children.forEach((child) {
//       child.getBounds($parent, rect);
//     });
//   }
// }

  /// A helper rectangle used for various calculations.
  static final GRect _sHelperRect = GRect();

  /// A helper matrix used for various calculations.
  static final GMatrix _sHelperMatrix = GMatrix();

  /// An alternate helper matrix used for various calculations.
  static final GMatrix _sHelperMatrixAlt = GMatrix();

  /// Debug paint used to draw the bounds of a DisplayObject.
  static final ui.Paint _debugPaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..color = kColorMagenta
    ..strokeWidth = 1;

  /// (Internal usage)
  /// The offset for the center of the drag object.
  late GPoint _dragCenterOffset;

  /// (Internal usage)
  /// The [parent] display object container that this object is a child of.
  GDisplayObjectContainer? $parent;

  /// (Internal usage)
  /// Whether to show debug bounds for this object.
  bool $debugBounds = false;

  /// Whether to use the shape of the object for mouse event detection.
  bool mouseUseShape = false;

  /// (Internal usage)
  /// The filters applied to this object.
  List<GBaseFilter>? $filters;

  /// (Internal usage)
  /// The object that the mouse was last pressed on.
  GDisplayObject? $mouseDownObj;

  /// (Internal usage)
  /// The object that the mouse is currently over.
  GDisplayObject? $mouseOverObj;

  /// (Internal usage)
  /// The time of the last mouse click.
  double $lastClickTime = -1;

  /// Whether to use a custom cursor for this object.
  bool useCursor = false;

  /// (Internal usage)
  /// The color to apply to this object.
  ui.Color? $colorize = kColorTransparent;

  /// You can store any user defined data in this property for easy access.
  Object? userData;

  /// Name to reference this object.
  String? name;

  /// The x-coordinate of the object.
  double _x = 0;

  /// The y-coordinate of the object.
  double _y = 0;

  /// The x-scale factor of the object.
  double _scaleX = 1;

  /// The y-scale factor of the object.
  double _scaleY = 1;

  /// The rotation of the object in radians.
  double _rotation = 0;

  double _pivotX = 0, _pivotY = 0;

  double _skewX = 0, _skewY = 0;

  double _z = 0, _rotationX = 0, _rotationY = 0;

  /// (Internal usage)
  /// The alpha (transparency) value of this object,
  /// a value between 0.0 (fully transparent) and 1.0 (fully opaque).
  double $alpha = 1;

  /// (Internal usage)
  /// Indicates whether the matrix of this object needs to be recalculated.
  bool $matrixDirty = true;

  /// Indicates whether this object can receive mouse and touch input events.
  bool mouseEnabled = true;

  /// (Internal usage)
  /// The [maskee] of this object, used for masking.
  GDisplayObject? $maskee;

  /// (Internal usage)
  /// The mask of this object, used for masking.
  GShape? $mask;

  /// (Internal usage)
  /// Optimization flag indicating whether this object has a touchable area.
  bool $hasTouchableArea = true;

  /// (Internal usage)
  /// Optimization flag indicating whether this object has a [visible] area.
  bool $hasVisibleArea = true;

  /// Whether the object should apply an inverted mask.
  /// can be set on the Shape mask, or the maskee DisplayObject.
  bool maskInverted = false;

  /// Flag that indicates if the transformation matrix has changed.
  bool _transformationChanged = false;

  /// Flag that indicates if the object is in 3D space.
  bool _is3D = false;

  /// Toggles the visibility state of the object.
  /// Whether or not the display object is visible.
  /// Display objects that are not visible are disabled.
  /// For example, if visible=false it cannot be clicked and it will not be
  /// rendered.
  bool _visible = true;

  /// The transformation matrix of the object.
  GMatrix? _transformationMatrix;

  /// When enabled, the saveLayer() feature is used for better rendering
  /// performance. Disabling it may provide better performance for certain
  /// display objects.
  /// Childless DisplayObjects, like [GShape] and [GBitmap], have their own
  /// Paint() so no need to use an expensive saveLayer().
  bool allowSaveLayer = false;

  /// (Internal usage)
  /// Tracks the last layer bounds used for rendering this display object
  /// using getBounds($parent).
  GRect? $debugLastLayerBounds;

  /// The paint to use for filters that require a paint.
  ui.Paint filterPaint = ui.Paint();

  /// (Internal usage)
  /// When enabled, a rectangle is created to save the layer for better
  /// rendering performance.
  bool $useSaveLayerBounds = true;

  /// (Internal usage)
  /// Defines the debug paint used to show the bounds of this display object
  /// when debug mode is enabled. By default, it uses a magenta stroke with
  /// a width of 1. Override this property to use a custom debug paint.
  ui.Paint? $debugBoundsPaint = _debugPaint.clone();

  /// Initializes a new instance of the [GDisplayObject] class.
  GDisplayObject() {
    _x = _y = 0.0;
    _rotation = 0.0;
    alpha = 1.0;
    _pivotX = _pivotY = 0.0;
    _scaleX = _scaleY = 1.0;
    _skewX = _skewY = 0.0;
    _rotationX = _rotationY = 0.0;
    mouseEnabled = true;
  }

  /// (Internal usage)
  /// Whether this object has a color applied to it.
  bool get $hasColorize => $colorize != null && $colorize!.alpha > 0;

  /// Returns the alpha (transparency) value of this object.
  double get alpha => $alpha;

  /// Sets the alpha (transparency) value of this object.
  /// The [value] parameter must be a value between 0.0 and 1.0.
  /// If the new value is the same as the current one,
  /// the method returns immediately.
  /// The method also marks the object as requiring redraw.
  set alpha(double value) {
    if ($alpha != value) {
      // value ??= 1;
      $alpha = value.clamp(0.0, 1.0);
      requiresRedraw();
    }
  }

  /// Returns the base object, i.e. the topmost parent in the display hierarchy.
  GDisplayObject get base {
    var current = this;
    while (current.$parent != null) {
      current = current.$parent!;
    }
    return current;
  }

  /// TODO: should be cached.
  /// Returns the bounds of this object in its local coordinate space.
  ///
  /// This method should be overridden by subclasses to calculate the correct
  /// bounds.
  ///
  /// If [out] is non-null, the resulting bounds will be stored in that object
  /// and returned, otherwise a new [GRect] object will be created and returned.
  GRect? get bounds => getBounds(this);

  /// Gets the color applied to this object.
  ui.Color? get colorize => $colorize;

  /// Sets the color to apply to this object.
  set colorize(ui.Color? value) {
    if ($colorize == value) return;
    $colorize = value;
    requiresRedraw();
  }

  /// Gets the filters applied to this object.
  List<GBaseFilter>? get filters => $filters;

  /// Sets the filters applied to this object.
  set filters(List<GBaseFilter>? value) => $filters = value;

  /// Returns true if this object has any filters applied.
  bool get hasFilters => filters?.isNotEmpty ?? false;

  /// Indicates the height of the display object, in dp.
  /// The `height` is calculated based on the bounds of the content of the
  /// display object.
  /// When you set the `height` property, the `scaleX` property is adjusted
  /// accordingly, as shown in the following code:
  /// ```dart
  ///   var rect:Shape = new Shape();
  ///   rect.graphics.beginFill(0xFF0000);
  ///   rect.graphics.drawRect(0, 0, 100, 100);
  ///   trace(rect.scaleY) // 1;
  ///   rect.height = 200;
  ///   trace(rect.scaleY) // 2;
  /// ```
  /// A display object with no content (such as an empty sprite) has a height
  /// of 0, even if you try to set height to a different value.
  double get height => getBounds($parent, _sHelperRect)!.height;

  /// Sets the height of this display object to the specified value.
  ///
  /// If the given value is null or NaN, an exception is thrown. If the
  /// display object's scale on the Y-axis is zero or very close to zero,
  /// it is reset to 1.0 in order to properly calculate the actual height.
  /// The actual height is then calculated based on the current width and
  /// scale of the display object. Finally, the scale on the Y-axis is set
  /// so that the actual height matches the specified value.
  ///
  /// If you need to retrieve the height of the display object, use the
  /// [height] getter instead.
  ///
  /// Throws an exception if the given value is null or NaN.
  set height(double? value) {
    if (value?.isNaN ?? true) throw '[$this.height] can not be NaN nor null';
    double? actualH;
    var zeroScale = _scaleY < 1e-8 && _scaleY > -1e-8;
    if (zeroScale) {
      scaleY = 1.0;
      actualH = height;
    } else {
      actualH = (height / _scaleY).abs();
    }
    scaleY = value! / actualH;
  }

  /// Returns `true` if this object is on the stage.
  bool get inStage => base is Stage;

  /// Returns whether this object is currently being used as a [mask] for another
  /// object.
  bool get isMask => $maskee != null;

  /// Returns whether this object has any [rotation] or skew transformation.
  bool get isRotated => _rotation != 0 || _skewX != 0 || _skewY != 0;

  /// Returns the mask of this object.
  GShape? get mask => $mask;

  /// The [GShape] to be used as a mask for this object.
  set mask(GShape? value) {
    if ($mask != value) {
      if ($mask != null) $mask!.$maskee = null;
      value?.$maskee = this;
      value?.$hasVisibleArea = false;
      $mask = value;
      requiresRedraw();
    }
  }

  /// Returns the position of the mouse in the local coordinate system of this
  /// object.
  /// The mouse position is updated every frame, so this method returns the
  /// current mouse position relative to the top-left corner of this object.
  ///
  /// Throws an error if the object is not currently added to the Stage.
  GPoint get mousePosition {
    if (!inStage) {
      throw 'To get mousePosition, the object needs to be in the Stage.';
    }
    return globalToLocal(_sHelperPoint.setTo(
      stage!.pointer!.mouseX,
      stage!.pointer!.mouseY,
    ));
  }

  /// The x-coordinate of the mouse or touch position in the local coordinate
  /// system of this object.
  ///
  /// Throws an exception if this object is not a descendant of the Stage.
  double get mouseX {
    if (inStage) {
      return globalToLocal(
        _sHelperPoint.setTo(
          stage!.pointer!.mouseX,
          stage!.pointer!.mouseY,
        ),
        _sHelperPoint,
      ).x;
    } else {
      throw 'To get mouseX object needs to be a descendant of Stage.';
    }
  }

  /// The y-coordinate of the mouse or touch position in the local coordinate
  /// system of this object.
  ///
  /// Throws an exception if this object is not a descendant of the Stage.
  double get mouseY {
    if (inStage) {
      return globalToLocal(
        _sHelperPoint.setTo(
          stage!.pointer!.mouseX,
          stage!.pointer!.mouseY,
        ),
        _sHelperPoint,
      ).y;
    } else {
      throw 'To get mouseY object needs to be a descendant of Stage.';
    }
  }

  /// Returns the parent container.
  GDisplayObjectContainer? get parent => $parent;

  /// Returns the x coordinate of the pivot point,
  /// the center of scaling and rotation.
  double get pivotX => _pivotX;

  /// Sets the x-coordinate of the object's pivot point.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set pivotX(double value) {
    if (value.isNaN) throw '[$this.pivotX] can not be NaN nor null';
    if (_pivotX == value) return;
    _pivotX = value;
    $setTransformationChanged();
  }

  /// Returns the y coordinate of the pivot point,
  /// the center of scaling and rotation.
  double get pivotY => _pivotY;

  /// Sets the y-coordinate of the object's pivot point.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set pivotY(double value) {
    if (value.isNaN) throw '[$this.pivotY] can not be NaN nor null';
    if (_pivotY == value) return;
    _pivotY = value;
    $setTransformationChanged();
  }

  /// Returns the root `GDisplayObject` that is the ancestor of this object
  /// (either a `Stage` or a `null`).
  GDisplayObject? get root {
    var current = this;
    while (current.$parent != null) {
      if (current.$parent is Stage) return current;
      current = current.$parent!;
    }
    return null;
  }

  /// Returns the angle of rotation in radians.
  double get rotation => _rotation;

  /// Sets the rotation angle in radians.
  /// Throws an error if [value] is null or NaN.
  /// If the value has not changed, does nothing.
  set rotation(double? value) {
    if (value?.isNaN ?? true) throw '[$this.rotation] can not be NaN nor null';
    if (_rotation == value) return;
    _rotation = value!;
    $setTransformationChanged();
  }

  /// The rotation angle in radians about the x-axis for 3d transformation.
  double get rotationX => _rotationX;

  /// (Experimental)
  /// Sets the rotation angle in degrees about the x-axis for 3d transformation.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set rotationX(double value) {
    if (value.isNaN) throw '[$this.rotationX] can not be NaN';
    if (_rotationX == value) return;
    _rotationX = value;
    if (!_isWarned3d) _warn3d();
    $setTransformationChanged();
  }

  /// The rotation angle in radians about the y-axis for 3d transformation.
  double get rotationY => _rotationY;

  /// (Experimental)
  /// Sets the rotation angle in degrees about the x-axis for 3d transformation.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set rotationY(double value) {
    if (value.isNaN) throw '[$this.rotationY] can not be NaN';
    if (_rotationY == value) return;
    _rotationY = value;
    if (!_isWarned3d) _warn3d();
    $setTransformationChanged();
  }

  /// Shortcut for setting proportional X and Y scale values.
  double get scale => _scaleX;

  /// Sets the X and Y scale values proportionally to [value].
  ///
  /// Setting [value] to the same value as the current scale has no effect.
  set scale(double value) {
    if (value == _scaleX) return;
    _scaleY = _scaleX = value;
    $setTransformationChanged();
  }

  /// Returns the horizontal scale of the object.
  double get scaleX => _scaleX;

  /// Sets the x-axis scale factor of the object.
  /// Throws an error if [value] is null or NaN.
  /// If the value has not changed, does nothing.
  set scaleX(double? value) {
    if (value?.isNaN ?? true) throw '[$this.scaleX] can not be NaN nor null';
    if (_scaleX == value) return;
    _scaleX = value!;
    $setTransformationChanged();
  }

  /// Returns the vertical scale of the object.
  double get scaleY => _scaleY;

  /// Sets the y-axis scale factor of the object.
  /// Throws an error if [value] is null or NaN.
  /// If the value has not changed, does nothing.
  set scaleY(double? value) {
    if (value?.isNaN ?? true) throw '[$this.scaleY] can not be NaN nor null';
    if (_scaleY == value) return;
    _scaleY = value!;
    $setTransformationChanged();
  }

  /// Returns the angle of skew on the x-axis in radians.
  double get skewX => _skewX;

  /// Sets the skew factor along the x-axis.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set skewX(double value) {
    if (value.isNaN) throw '[$this.skewX] can not be NaN nor null';
    if (_skewX == value) return;
    _skewX = value;
    $setTransformationChanged();
  }

  /// Returns the angle of skew on the y-axis in radians.
  double get skewY => _skewY;

  /// Sets the skew factor along the y-axis.
  /// Throws an error if [value] is NaN.
  /// If the value has not changed, does nothing.
  set skewY(double value) {
    if (value.isNaN) throw '[$this.skewY] can not be NaN';
    if (_skewY == value) return;
    _skewY = value;
    $setTransformationChanged();
  }

  /// Returns the stage this object is on or `null` if it's not on a stage.
  Stage? get stage => base is Stage ? base as Stage? : null;

  /// Gets the transformation matrix that represents the object's position,
  /// scale, rotation and skew.
  ///
  /// If the transformation matrix has changed since the last time this method
  /// was called, a new matrix will be computed and cached until the next time
  /// this method is called.
  GMatrix get transformationMatrix {
    if (_transformationChanged || _transformationMatrix == null) {
      _transformationChanged = false;
      _transformationMatrix ??= GMatrix();
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
        _transformationMatrix!,
      );
    }
    return _transformationMatrix!;
  }

  /// Sets the transformation matrix that represents the object's position,
  /// scale, rotation and skew.
  ///
  /// The object's position, scale, rotation, and skew values are updated to
  /// match the new transformation matrix.
  set transformationMatrix(GMatrix matrix) {
    const piQuarter = Math.PI / 4.0;
    requiresRedraw();
    _transformationChanged = false;
    _transformationMatrix ??= GMatrix();
    _transformationMatrix!.copyFrom(matrix);
    _pivotX = _pivotY = 0;
    _x = matrix.tx;
    _y = matrix.ty;
    _skewX = Math.atan(-matrix.c / matrix.d);
    _skewY = Math.atan(matrix.b / matrix.a);
    _scaleY = (_skewX > -piQuarter && _skewX < piQuarter)
        ? matrix.d / Math.cos(_skewX)
        : -matrix.c / Math.sin(_skewX);
    _scaleX = (_skewY > -piQuarter && _skewY < piQuarter)
        ? matrix.a / Math.cos(_skewY)
        : -matrix.b / Math.sin(_skewY);
    if (MathUtils.isEquivalent(_skewX, _skewY)) {
      _rotation = _skewX;
      _skewX = _skewY = 0;
    } else {
      _rotation = 0;
    }
  }

  /// Returns whether the display object is visible or not.
  bool get visible => _visible;

  /// Sets whether the display object is visible or not.
  /// It helps to optimize performance skipping the rendering process.
  set visible(bool flag) {
    if (_visible != flag) {
      _visible = flag;
      requiresRedraw();
    }
  }

  /// Indicates the width of the display object, in dp.
  /// The `width` is calculated based on the bounds of the content of the
  /// display object.
  /// When you set the `width` property, the `scaleX` property is adjusted
  /// accordingly, as shown in the following code:
  /// ```dart
  ///   var rect:Shape = new Shape();
  ///   rect.graphics.beginFill(0xFF0000);
  ///   rect.graphics.drawRect(0, 0, 100, 100);
  ///   trace(rect.scaleX) // 1;
  ///   rect.width = 200;
  ///   trace(rect.scaleX) // 2;
  /// ```
  /// A display object with no content (such as an empty sprite) has a width
  /// of 0, even if you try to set width to a different value.
  double get width => getBounds($parent, _sHelperRect)!.width;

  /// Sets the width of the object to the given [value].
  /// If the given value is null or NaN, an error is thrown.
  ///
  /// If the object has a zero scale, it is first set to 1.0 before computing
  /// the new scale based on the new width value.
  /// Otherwise, the current scale is used to compute the current actual width
  /// of the object, which is then used to
  /// determine the new scale based on the new width value.
  /// The [value] parameter should be the desired new width value of the object.
  set width(double? value) {
    if (value?.isNaN ?? true) throw '[$this.width] can not be NaN nor null';
    double? actualW;
    var zeroScale = _scaleX < 1e-8 && _scaleX > -1e-8;
    if (zeroScale) {
      scaleX = 1.0;
      actualW = width;
    } else {
      actualW = (width / _scaleX).abs();
    }
    scaleX = value! / actualW;
  }

  /// Returns the alpha value of the object relative to its parent and all its
  /// ancestors.
  double get worldAlpha => alpha * ($parent?.worldAlpha ?? 1);

  /// Returns the horizontal scaling factor of the object relative to its
  /// parent and all its ancestors.
  double get worldScaleX => scaleX * ($parent?.worldScaleX ?? 1);

  /// Returns the vertical scaling factor of the object relative to its parent
  /// and all its ancestors.
  double get worldScaleY => scaleX * ($parent?.worldScaleY ?? 1);

  /// Returns the x coordinate of the object relative to the stage and all its
  /// ancestors.
  double get worldX => x - pivotX * scaleX + ($parent?.worldX ?? 0);

  /// Returns the y coordinate of the object relative to the stage and all its
  /// ancestors.
  double get worldY => y - pivotY * scaleY + ($parent?.worldY ?? 0);

  /// The [x] coordinate of the display object relative to its parent's
  /// coordinate system.
  double get x => _x;

  /// Sets the [x] coordinate of the display object relative to its parent's
  /// coordinate system.
  /// Throws an exception if the value is `null` or `NaN`.
  /// If the value has not changed, does nothing.
  set x(double? value) {
    if (value?.isNaN ?? true) throw '[$this.x] can not be NaN nor null';
    if (_x == value) return;
    _x = value!;
    $setTransformationChanged();
  }

  /// The [y] coordinate of the display object relative to its parent's
  /// coordinate system.
  double get y => _y;

  /// Sets the [y] coordinate of the object's position.
  /// Throws an error if [value] is null or NaN.
  /// If the value has not changed, does nothing.
  set y(double? value) {
    if (value?.isNaN ?? true) throw '[$this.y] can not be NaN nor null';
    if (_y == value) return;
    _y = value!;
    $setTransformationChanged();
  }

  /// (Experimental)
  /// The z-coordinate of this object in 3D space.
  double get z => _z;

  /// (Experimental)
  /// Sets the z-axis coordinate of this object in 3D space.
  ///
  /// Throws an error if the given value is NaN.
  /// If the new value is the same as the current one,
  /// the method returns immediately.
  set z(double value) {
    if (value.isNaN) throw '[$this.z] can not be NaN';
    if (_z == value) return;
    _z = value;
    if (!_isWarned3d) _warn3d();
    $setTransformationChanged();
  }

  /// (Internal usage)
  /// Override this method to implement custom drawing using Flutter's API.
  /// You can access the [canvas] object from here. Make sure to also implement
  /// [getBounds] and [hitTest] for this display object to work properly.
  void $applyPaint(ui.Canvas canvas) {}

  /// (Internal usage)
  /// Dispatches a mouse event to the appropriate callback functions.
  ///
  /// If [mouseEnabled] is false, no mouse events will be dispatched.
  /// The `type` argument specifies the type of mouse event.
  /// The `object` argument specifies the object that the event originated from.
  /// The `input` argument specifies the mouse input data for the event.
  ///
  /// The following types of mouse events are dispatched:
  ///
  /// - `MouseInputType.zoomPan`: dispatched when the user uses pinch zoom or
  /// pan gestures.
  /// - `MouseInputType.wheel`: dispatched when the user scrolls the mouse
  /// wheel.
  /// - `MouseInputType.down`: dispatched when the user presses the left mouse
  /// button.
  /// - `MouseInputType.move`: dispatched when the user moves the mouse cursor.
  /// - `MouseInputType.up`: dispatched when the user releases the left mouse
  /// button.
  /// - `MouseInputType.over`: dispatched when the mouse cursor enters the
  /// bounds of the object.
  /// - `MouseInputType.out`: dispatched when the mouse cursor leaves the bounds
  /// of the object.
  ///
  /// Depending on the type of mouse event, the appropriate callback function
  /// will be invoked.
  /// The `mouseInput` argument is a cloned copy of the `input` argument, with
  /// its `target` and `currentTarget` fields set to `this` and `object`,
  /// respectively.
  /// If the mouse event is a `down` event, the `mouseDownObj` field of this
  /// object will be set to `object`.
  /// If the mouse event is an `up` event, the `mouseDownObj` field will be set
  /// to `null`, and the appropriate `onMouseClick` or `onMouseDoubleClick`
  /// callback function will be invoked if necessary.
  ///
  /// If the mouse event is a `over` event, the `mouseOverObj` field of this
  /// object will be set to `object`. If the `useCursor` field of this object is
  /// `true` and the cursor is showing, the cursor will be set to the click
  /// cursor.
  ///
  /// If the mouse event is an `out` event, the `mouseOverObj` field will be set
  /// to `null`. If the `useCursor` field of this object is `true` and the
  /// cursor is showing, the cursor will be set to the basic cursor.
  ///
  /// The `parent` of this object will also receive the mouse event,
  /// recursively, until there are no more parents.
  void $dispatchMouseCallback(
    MouseInputType type,
    GDisplayObject object,
    MouseInputData input,
  ) {
    if (mouseEnabled) {
      var mouseInput = input.clone(this, object, type);
      switch (type) {
        case MouseInputType.zoomPan:
          $onZoomPan?.dispatch(mouseInput);
          break;
        case MouseInputType.wheel:
          $onMouseWheel?.dispatch(mouseInput);
          break;
        case MouseInputType.down:
          $mouseDownObj = object;
          $onMouseDown?.dispatch(mouseInput);
          break;
//        case MouseInputType.rightDown:
//          $rightMouseDownObj = object;
//          $onRightMouseDown?.dispatch(mouseInput);
//          break;
        case MouseInputType.move:
          $onMouseMove?.dispatch(mouseInput);
          break;
        case MouseInputType.up:
          if ($mouseDownObj == object &&
              ($onMouseClick != null || $onMouseDoubleClick != null)) {
            var mouseClickInput = input.clone(this, object, MouseInputType.up);
            $onMouseClick?.dispatch(mouseClickInput);

            if ($lastClickTime > 0 &&
                input.time - $lastClickTime < MouseInputData.doubleClickTime) {
              $onMouseDoubleClick?.dispatch(mouseClickInput);
              $lastClickTime = -1;
            } else {
              $lastClickTime = input.time;
            }
          }
          $mouseDownObj = null;
          $onMouseUp?.dispatch(mouseInput);
          break;
        case MouseInputType.over:
          $mouseOverObj = object;
          if (useCursor && GMouse.isShowing()) {
            GMouse.setClickCursor();
          }
          $onMouseOver?.dispatch(mouseInput);
          break;
        case MouseInputType.out:
          $mouseOverObj = null;

          /// TODO: check if other object on top receives the event
          /// todo. before this one, and Cursor loses the stage.
          if (useCursor && GMouse.isShowing()) {
            GMouse.basic();
          }
          $onMouseOut?.dispatch(mouseInput);
          break;
        default:
          break;
      }
    }
    $parent?.$dispatchMouseCallback(type, object, input);
  }

  /// (Internal usage)
  /// Sets the [GDisplayObjectContainer] that contains this [GDisplayObject].
  void $setParent(GDisplayObjectContainer? value) {
    var ancestor = value;
    while (ancestor != this && ancestor != null) {
      ancestor = ancestor.$parent;
    }
    if (ancestor == this) {
      throw ArgumentError(
          'An object cannot be added as a child to itself or one '
          'of its children (or children\'s children, etc.)');
    } else {
      $parent = value;
    }
  }

  /// (Internal usage)
  /// Sets the transformationChanged flag and updates the 3D flag based on
  /// whether the object has 3D properties set.
  void $setTransformationChanged() {
    _transformationChanged = true;
    _is3D = _rotationX != 0 || _rotationY != 0 || _z != 0;
    requiresRedraw();
  }

  /// (Internal usage)
  /// Updates the transformation matrices of a display object based on the given
  /// parameters.
  ///
  /// - x: The horizontal position of the display object.
  /// - y: The vertical position of the display object.
  /// - pivotX: The horizontal position of the display object's pivot point.
  /// - pivotY: The vertical position of the display object's pivot point.
  /// - scaleX: The horizontal scaling factor of the display object.
  /// - scaleY: The vertical scaling factor of the display object.
  /// - skewX: The horizontal skew angle of the display object in radians.
  /// - skewY: The vertical skew angle of the display object in radians.
  /// - rotation: The rotation of the display object in radians.
  /// - out: The output matrix where the updated transformation matrix will be
  /// stored.
  void $updateTransformationMatrices(
    double? x,
    double? y,
    double pivotX,
    double pivotY,
    double scaleX,
    double scaleY,
    double skewX,
    double skewY,
    double rotation,
    GMatrix out,
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
          x! - pivotX * scaleX,
          y! - pivotY * scaleY,
        );
      } else {
        final cos = Math.cos(rotation);
        final sin = Math.sin(rotation);
        final a = scaleX * cos;
        final b = scaleX * sin;
        final c = scaleY * -sin;
        final d = scaleY * cos;
        final tx = x! - pivotX * a - pivotY * c;
        final ty = y! - pivotX * b - pivotY * d;
        out.setTo(a, b, c, d, tx, ty);
      }
    } else {
      out.identity();
      out.scale(scaleX, scaleY);
      out.skew(skewX, skewY); // MatrixUtils.skew(out, skewX, skewY);
      out.rotate(rotation);
      out.translate(x!, y!);
      if (pivotX != 0 || pivotY != 0) {
        out.tx = x - out.a * pivotX - out.c * pivotY;
        out.ty = y - out.b * pivotX - out.d * pivotY;
      }
    }
  }

  /// Called when the object is added to the stage.
  /// Should be overridden by subclasses as entry point.
  void addedToStage() {}

  /// Adjusts the pivot point of this display object to a new location defined
  /// by the given [alignment] parameter, which defaults to [Alignment.center].
  /// This method calculates the bounds of the object and aligns the pivot point
  /// based on the provided alignment parameter.
  /// The alignment is represented by an [Alignment] object,
  /// where the x and y values range from -1.0 to 1.0.
  /// For example, an [Alignment] of (-1.0, -1.0) represents the top left
  /// corner, while an [Alignment] of (1.0, 1.0) represents the bottom right
  /// corner.
  /// The pivot point represents the center point for rotations and scaling,
  /// and by default it is set to (0,0), which means that the object is rotated
  /// and scaled around the top-left corner.
  /// This method is useful to adjust the pivot point to a more suitable
  /// location before performing rotations or scaling operations.
  /// If the bounds of the object are empty, no adjustment is made to the pivot
  /// point. The resulting pivot point is stored in the [pivotX] and [pivotY]
  /// properties of this display object.
  void alignPivot([painting.Alignment alignment = painting.Alignment.center]) {
    var bounds = getBounds(this, _sHelperRect)!;

    if (bounds.isEmpty) return;
    var ax = 0.5 + alignment.x / 2;
    var ay = 0.5 + alignment.y / 2;

    pivotX = bounds.x + bounds.width * ax;
    pivotY = bounds.y + bounds.height * ay;
  }

  /// Captures mouse input and dispatches corresponding mouse events to this
  /// display object if it has a touchable area and [mouseEnabled] is set to
  /// true.
  ///
  /// The method checks whether the input is captured or not and updates the
  /// [captured] property accordingly. If the input is newly captured, it also
  /// dispatches a [MouseInputType.over] event to this display object. If the
  /// input was already captured, it checks if the mouse is still over this
  /// display object and dispatches a [MouseInputType.out] event if it's not.
  ///
  /// The [input] parameter represents the mouse input data including the input
  /// type and position.
  ///
  /// Note: This method should not be called directly by user code.
  ///
  /// See also:
  ///
  ///  * [MouseInputData], which represents the mouse input data.
  ///  * [mouseEnabled], which indicates whether this display object can receive
  ///    mouse events.
  ///  * [hitTouch], which checks whether a point is within the touchable area
  ///    of this display object.
  ///  * [$dispatchMouseCallback], which dispatches mouse events to this display
  ///    object.
  void captureMouseInput(MouseInputData input) {
    if (!$hasTouchableArea) return;
    if (mouseEnabled) {
      if (input.captured && input.type == MouseInputType.up) {
        $mouseDownObj = null;
      }
      var prevCaptured = input.captured;
      globalToLocal(input.stagePosition, input.localPosition);
      input.captured = input.captured ||
          hitTouch(
            input.localPosition,
            mouseUseShape,
          );
      if (!prevCaptured && input.captured) {
        $dispatchMouseCallback(input.type, this, input);
        if ($mouseOverObj != this) {
          $dispatchMouseCallback(MouseInputType.over, this, input);
        }
      } else if ($mouseOverObj == this) {
        $dispatchMouseCallback(MouseInputType.out, this, input);
      }
    }
  }

  /// Creates an image representation of the current state of the
  /// [GDisplayObject].
  /// If [adjustOffset] is true, the resulting image will be offset so that its
  /// top-left corner corresponds to the top-left corner of the current
  /// [bounds].
  /// If [resolution] is provided and is different than 1, the image will be
  /// scaled by this factor before being returned.
  /// If [rect] is provided, it defines a rectangle that will be used as the
  /// bounds for the image instead of the [getFilterBounds] of the
  /// [GDisplayObject].
  /// Returns a Future that resolves to a [ui.Image] representing the current
  /// state of the [GDisplayObject] in the form of an image.
  Future<ui.Image> createImage([
    bool adjustOffset = true,
    double resolution = 1,
    GRect? rect,
  ]) async {
    rect ??= getFilterBounds(); //getBounds($parent);
    rect = rect!.clone();
    if (resolution != 1) {
      rect *= resolution;
    }
    final needsAdjust =
        (rect.left != 0 || rect.top != 0) && adjustOffset || resolution != 1;
    late ui.Picture picture;
    if (needsAdjust) {
      picture = createPicture((canvas) {
        if (adjustOffset) canvas.translate(-rect!.left, -rect.top);
        if (resolution != 1) canvas.scale(resolution);
      }, (canvas) {
        if (adjustOffset) canvas.restore();
        if (resolution != 1) canvas.restore();
      });
    } else {
      picture = createPicture();
    }
    final width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = await picture.toImage(width, height);
    picture.dispose();
    return output;
  }

  /// Creates a synchronous image from this display object.
  ///
  /// [adjustOffset] determines whether to adjust the offset of the generated
  /// image to the top-left corner of the display object's bounds.
  /// If `true`, the generated image will have its origin at `(0, 0)` and
  /// its size will be equal to the bounds of the display object.
  /// Defaults to `true`.
  ///
  /// [resolution] determines the resolution of the generated image.
  /// Defaults to `1`.
  ///
  /// [rect] determines the bounds of the image to generate.
  /// Defaults to `null`, which means that the method will use the filter
  /// bounds of the display object.
  ///
  /// Returns a [ui.Image] instance.
  ui.Image createImageSync([
    bool adjustOffset = true,
    double resolution = 1,
    GRect? rect,
  ]) {
    rect ??= getFilterBounds();
    rect = rect!.clone();
    if (resolution != 1) {
      rect *= resolution;
    }
    final needsAdjust =
        (rect.left != 0 || rect.top != 0) && adjustOffset || resolution != 1;
    late ui.Picture picture;
    if (needsAdjust) {
      picture = createPicture((canvas) {
        if (adjustOffset) canvas.translate(-rect!.left, -rect.top);
        if (resolution != 1) canvas.scale(resolution);
      }, (canvas) {
        if (adjustOffset) canvas.restore();
        if (resolution != 1) canvas.restore();
      });
    } else {
      picture = createPicture();
    }
    final width = adjustOffset ? rect.width.toInt() : rect.right.toInt();
    final height = adjustOffset ? rect.height.toInt() : rect.bottom.toInt();
    final output = picture.toImageSync(width, height);
    picture.dispose();
    return output;
  }

  /// Creates a new [GTexture] asynchronously from the display object's image.
  /// The image is retrieved using the [createImage] method, and a new texture
  /// is created from the image with the specified resolution.
  /// If a [rect] is specified, only the portion of the image within the bounds
  /// of the rectangle will be used to create the texture.
  /// If [adjustOffset] is true, the image will be adjusted to remove any
  /// offsets from the top left corner.
  Future<GTexture> createImageTexture([
    bool adjustOffset = true,
    double resolution = 1,
    GRect? rect,
  ]) async {
    final img = await createImage(adjustOffset, resolution, rect);
    var tx = GTexture.fromImage(img, resolution);
    tx.pivotX = bounds!.x;
    tx.pivotY = bounds!.y;
    return tx;
  }

  /// Creates a texture from the synchronous image generated from this display
  /// object.
  ///
  /// [adjustOffset] determines whether to adjust the offset of the generated
  /// image to the top-left corner of the display object's bounds.
  /// If `true`, the pivot point of the generated texture will be set to
  /// `(bounds.x, bounds.y)`. Defaults to `true`.
  /// [resolution] determines the resolution of the generated image. Defaults to
  /// `1`.
  /// [rect] determines the bounds of the image to generate. Defaults to `null`,
  /// which means that the method will use the filter bounds of the display
  /// object. Returns a [GTexture] instance.
  GTexture createImageTextureSync([
    bool adjustOffset = true,
    double resolution = 1,
    GRect? rect,
  ]) {
    final img = createImageSync(adjustOffset, resolution, rect);
    var tx = GTexture.fromImage(img, resolution);
    tx.pivotX = bounds!.x;
    tx.pivotY = bounds!.y;
    return tx;
  }

  /// Creates a picture of the current state of the DisplayObject.
  /// To ensure the "original" form, call before applying any transformations
  /// (x, y, scale, etc).
  ///
  /// Optionally accepts [prePaintCallback] and [postPaintCallback] functions
  /// that allow to customize the painting process.
  ui.Picture createPicture(
      [void Function(ui.Canvas)? prePaintCallback,
      void Function(ui.Canvas)? postPaintCallback]) {
    final r = ui.PictureRecorder();
    final c = ui.Canvas(r);
    prePaintCallback?.call(c);
    paint(c);
    postPaintCallback?.call(c);
    return r.endRecording();
  }

  /// Dispose of the [GDisplayObject] instance and its resources.
  ///
  /// Remove the current object from any container it belongs to and
  /// release any internal resources.
  @mustCallSuper
  void dispose() {
    if ($currentDrag == this) {
      $currentDrag = null;
    }
//    _stage = null;
    $parent = null;
    userData = null;
    name = null;
    $disposePointerSignals();
    $disposeDisplayListSignals();
    $disposeRenderSignals();
  }

  /// Returns the bounds of this object in the coordinate space of
  /// [targetSpace].
  ///
  /// If [out] is non-null, the resulting bounds will be stored in that object
  /// and returned, otherwise a new [GRect] object will be created and returned.
  /// This method has to be overriden by subclasses.
  GRect? getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    // This method is abstract and should be overridden by subclasses to
    // calculate the correct bounds.
    throw 'getBounds() is abstract in DisplayObject';
  }

  /// Returns the bounds of this object after applying all its filters.
  ///
  /// If [layerBounds] is not provided, the bounds of the parent are used.
  ///
  /// If [alphaPaint] is not null, it will be used as the paint for the filters
  /// that use alpha. This is useful when computing the bounds of filters that
  /// require a non-default paint.
  GRect? getFilterBounds([GRect? layerBounds, ui.Paint? alphaPaint]) {
    layerBounds ??= getBounds($parent);
    if ($filters == null || $filters!.isEmpty) {
      return layerBounds;
    }
    layerBounds = layerBounds!.clone();
    GRect? resultBounds;
    for (var filter in $filters!) {
      resultBounds ??= layerBounds.clone();
      if (alphaPaint != null) {
        filter.update();
      }
      filter.expandBounds(layerBounds, resultBounds);
      if (alphaPaint != null) {
        filter.currentObject = this;
        filter.resolvePaint(alphaPaint);
        filter.currentObject = null;
      }
    }
    return resultBounds;
  }

  /// Returns the transformation matrix that transforms coordinates from the
  /// local coordinate system to the coordinate system of the targetSpace.
  ///
  /// The resulting transformation is a concatenation of the transformation
  /// matrices of all the display objects along the parent chain from this
  /// object to the targetSpace. If targetSpace is null, the result will
  /// be in the coordinate system of the base object of this display object.
  ///
  /// The resulting transformation is stored in the provided [out] matrix
  /// object, or in a new instance of [GMatrix] if [out] is null. The resulting
  /// matrix is returned.
  ///
  /// If [targetSpace] is this display object, the result is the identity
  /// matrix.
  ///
  /// If [targetSpace] is the direct or indirect parent of this display object,
  /// the returned transformation matrix will contain only translation,
  /// rotation, and scale transformations.
  ///
  /// If [targetSpace] is null or the base object of this display object, the
  /// returned transformation matrix will contain the entire chain of
  /// transformations from this display object to the base object.
  ///
  /// If [targetSpace] is neither null, this display object, nor the parent or
  /// base object of this display object, the returned transformation matrix
  /// will contain the entire chain of transformations from this display object
  /// up to (but not including) the first common ancestor of this display object
  /// and the target space.
  GMatrix getTransformationMatrix(GDisplayObject? targetSpace, [GMatrix? out]) {
    GDisplayObject? commonParent, currentObj;
    out?.identity();
    out ??= GMatrix();
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
        out.concat(currentObj!.transformationMatrix);
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
    commonParent = GDisplayObject._findCommonParent(this, targetSpace);

    /// 2 - move up from this to common parent.````
    currentObj = this;
    while (currentObj != commonParent) {
      out.concat(currentObj!.transformationMatrix);
      currentObj = currentObj.$parent;
    }

    if (commonParent == targetSpace) return out;

    /// 3. move up from target until we reach common parent.
    _sHelperMatrix.identity();
    currentObj = targetSpace;
    while (currentObj != commonParent) {
      _sHelperMatrix.concat(currentObj!.transformationMatrix);
      currentObj = currentObj.$parent;
    }

    /// 4. combine the matrices.
    _sHelperMatrix.invert();
    out.concat(_sHelperMatrix);
    return out;
  }

  /// Converts the given point from global coordinates to local coordinates.
  ///
  /// If [out] is non-null, the resulting point will be stored in that object
  /// and returned, otherwise a new [GPoint] object will be created and
  /// returned.
  GPoint globalToLocal(GPoint globalPoint, [GPoint? out]) {
    // Get the transformation matrix from the base object to this object.
    getTransformationMatrix(base, _sHelperMatrixAlt);
    // Invert the matrix to go from global coordinates to local coordinates.
    _sHelperMatrixAlt.invert();
    // Transform the point using the inverted matrix to get the local
    // coordinates.
    return _sHelperMatrixAlt.transformPoint(globalPoint, out);
  }

  /// Determines if this object overlaps with the given [localPoint].
  ///
  /// If [useShape] is `true`, the object will be tested against its shape
  /// rather than its bounding box. Defaults to `false`.
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!$hasTouchableArea || !mouseEnabled) {
      return null;
    }
    if (($mask != null || maskRect != null) && !hitTestMask(localPoint)) {
      return null;
    }
    if (getBounds(this, _sHelperRect)!.containsPoint(localPoint)) {
      return this;
    }
    return null;
  }

  /// Determines whether the [localPoint] specified in the local coordinates
  /// of this object lies inside its mask.
  ///
  /// If the object has no mask or [maskRect], this method returns `true`.
  ///
  /// If the object has a [maskRect], this method determines whether the point
  /// is inside the rectangle.
  ///
  /// If the object has a [$mask], this method transforms the point into the
  /// local coordinate system of the mask using the [$mask]'s transformation
  /// matrix and then checks if the point is inside the mask's boundary. If
  /// [maskInverted] is `true`, the result is inverted.
  bool hitTestMask(GPoint localPoint) {
    if ($mask == null && maskRect == null) {
      return true;
    }
    if (maskRect != null) {
      final isHit = maskRect!.containsPoint(localPoint);
      return maskRectInverted ? !isHit : isHit;
    }
    if ($mask!.inStage) {
      getTransformationMatrix($mask, _sHelperMatrixAlt);
    } else {
      _sHelperMatrixAlt.copyFrom($mask!.transformationMatrix);
      _sHelperMatrixAlt.invert();
    }

    var helperPoint = localPoint == _sHelperPoint ? GPoint() : _sHelperPoint;
    _sHelperMatrixAlt.transformPoint(localPoint, helperPoint);

    final isHit = mask!.hitTest(helperPoint) != null;
    return maskInverted ? !isHit : isHit;
  }

  /// Determines whether the [localPoint] specified in the local coordinates of
  /// this object lies inside its bounds.
  ///
  /// If [useShape] is `false`, this method uses the axis-aligned bounding box
  /// of the display object to test for a hit. If [useShape] is `true`, this
  /// method uses the object's [shape] to test for a hit.
  ///
  /// This method returns `true` if the point is inside the object's bounds,
  /// and `false` otherwise.
  bool hitTouch(GPoint localPoint, [bool useShape = false]) {
    return hitTest(localPoint, useShape) != null;
  }

  /// Transforms the given [localPoint] from the local coordinate system to the
  /// global coordinate system.
  GPoint localToGlobal(GPoint localPoint, [GPoint? out]) {
    getTransformationMatrix(base, _sHelperMatrixAlt);
    return _sHelperMatrixAlt.transformPoint(localPoint, out);
  }

  /// Do not override this method as it applies the basic transformations.
  /// Override [$applyPaint] if you want to use [Canvas] directly.
  void paint(ui.Canvas canvas) {
    /// Check if the object has visible area and if it's visible
    if (!$hasVisibleArea || !visible) {
      return;
    }
    $onPreTransform?.dispatch(canvas);

    /// Check if the object has any transformations.
    final hasScale = _scaleX != 1 || _scaleY != 1;
    final hasTranslate = _x != 0 || _y != 0;
    final hasPivot = _pivotX != 0 || _pivotY != 0;
    final hasSkew = _skewX != 0 || _skewY != 0;
    final needSave = hasTranslate ||
        hasScale ||
        rotation != 0 ||
        hasPivot ||
        hasSkew ||
        _is3D;

    final $hasFilters = hasFilters;
    // final hasColorize = $colorize?.alpha > 0 ?? false;
    // var _saveLayer = this is DisplayObjectContainer &&
    //     (this as DisplayObjectContainer).hasChildren &&
    //     ($alpha != 1 || $hasColorize || $hasFilters);
    var saveLayer =
        allowSaveLayer && $alpha != 1 || $hasColorize || $hasFilters;
    // if (this is DisplayObjectContainer &&
    //     (this as DisplayObjectContainer).hasChildren) {
    // }

    final hasMask = mask != null || maskRect != null;
    final showDebugBounds =
        DisplayBoundsDebugger.debugBoundsMode == DebugBoundsMode.internal &&
            ($debugBounds || DisplayBoundsDebugger.debugAll);

    GRect? cacheLocalBoundsRect;
    if (showDebugBounds || saveLayer) {
      // _cacheLocalBoundsRect = bounds.toNative();
      cacheLocalBoundsRect = bounds;
    }

    List<GComposerFilter>? composerFilters;
    var filterHidesObject = false;
    if (saveLayer) {
//       TODO: static painter seems to have some issues, try local var later.
      /// using local Painter now to avoid problems.
      final alphaPaint = filterPaint;
      if (alpha < 1) {
        alphaPaint.color = kColorBlack.withOpacity(alpha);
      }

      /// check colorize if it needs a unique Paint instead.
      alphaPaint.colorFilter = null;
      alphaPaint.imageFilter = null;
      alphaPaint.maskFilter = null;
      if ($hasColorize) {
        alphaPaint.colorFilter = ui.ColorFilter.mode(
          $colorize!,
          ui.BlendMode.srcATop,
        );
      }
      ui.Rect? nativeLayerBounds;
      var layerBounds = getBounds($parent);
      if ($hasFilters) {
        /// TODO: Find a common implementation for filter bounds.
        // layerBounds = getFilterBounds(layerBounds, alphaPaint);
        layerBounds = layerBounds!.clone();
        GRect? resultBounds;
        for (var filter in $filters!) {
          resultBounds ??= layerBounds.clone();
          filter.update();
          filter.expandBounds(layerBounds, resultBounds);
          if (filter is GComposerFilter) {
            composerFilters ??= <GComposerFilter>[];
            composerFilters.add(filter);
          } else {
            filter.currentObject = this;
            filter.resolvePaint(alphaPaint);
            filter.currentObject = null;
          }
        }
        layerBounds = resultBounds;
      }
      $debugLastLayerBounds = layerBounds;
      // canvas.saveLayer(layerBounds.toNative(), alphaPaint);
      if ($useSaveLayerBounds) {
        nativeLayerBounds = layerBounds!.toNative();
      }
      canvas.saveLayer(nativeLayerBounds, alphaPaint);
    }
    if (needSave) {
      // onPreTransform.dispatch();
      canvas.save();
      var m = transformationMatrix.toNative();
      if (_is3D) {
        /// TODO: experimental, just transforms
        final m2 = GMatrix().toNative();
        m2.setEntry(3, 2, 0.004);
        m2.translate(_pivotX, _pivotY);
        if (z != 0) {
          m2.translate(.0, .0, z);
        }
        m2.rotateX(_rotationX);
        m2.rotateY(_rotationY);
        m2.translate(-_pivotX, -_pivotY);
        m.multiply(m2);
      }
      canvas.transform(m.storage);
    }

    if (hasMask) {
      canvas.save();
      if (maskRect != null) {
        $applyMaskRect(canvas);
      } else {
        mask!.$applyPaint(canvas);
      }
    }

    if (composerFilters != null) {
      for (var filter in composerFilters) {
        if (filter.hideObject ||
            (filter is GDropShadowFilter && filter.innerShadow)) {
          filterHidesObject = true;
        }
        filter.currentObject = this;
        filter.process(canvas, $applyPaint);
        filter.currentObject = null;
      }
    }
    $onPrePaint?.dispatch(canvas);
    if (!filterHidesObject) {
      $applyPaint(canvas);
    }
    $onPostPaint?.dispatch(canvas);

    if (hasMask) {
      canvas.restore();
    }
    if (showDebugBounds) {
      final paint = $debugBoundsPaint ?? _debugPaint;
      final linePaint = paint.clone();
      linePaint.color = linePaint.color.withOpacity(.3);
      final rect = cacheLocalBoundsRect!.toNative();
      canvas.drawLine(rect.topLeft, rect.bottomRight, linePaint);
      canvas.drawLine(rect.topRight, rect.bottomLeft, linePaint);
      canvas.drawRect(rect, paint);
    }
    if (needSave) {
      canvas.restore();
    }
    if (saveLayer) {
      canvas.restore();
    }
  }

  /// Called when the object is removed to the stage.
  void removedFromStage() {}

  /// Removes this [GDisplayObject] from its parent [GDisplayObjectContainer].
  ///
  /// By default, the [GDisplayObject] instance is not disposed of when it's
  /// removed. Set [dispose] to true to dispose of the instance.
  ///
  /// Throws a [StateError] if this [GDisplayObject] does not have a parent.
  void removeFromParent([bool dispose = false]) {
    $parent?.removeChild(this, dispose);
  }

  /// Notifies the parent that the current state of this `GDisplayObject`
  /// has changed and it requires a redraw.
  ///
  /// This method updates the [$hasTouchableArea] and [$hasVisibleArea] flags
  /// based on the object's current state of visibility, masking, and scaling.
  void requiresRedraw() {
    /// TODO: notify parent the current state of this DisplayObject.
    $hasTouchableArea =
        visible && $maskee == null && _scaleX != 0 && _scaleY != 0;

    $hasVisibleArea = $alpha != 0 &&
        visible &&
        $maskee == null &&
        _scaleX != 0 &&
        _scaleY != 0;
  }

  // Sets the [x] and [y] transformation of the DisplayObject and returns it.
  GDisplayObject setPosition(double x, double y) {
    _x = x;
    _y = y;
    $setTransformationChanged();
    return this;
  }

  // Sets the [scaleX] and [scaleY] transformation of the DisplayObject and
  // returns it.
  // If only one argument is provided, both [scaleX] and [scaleY] are set to the
  // same value.
  GDisplayObject setScale(double scaleX, [double? scaleY]) {
    _scaleX = scaleX;
    _scaleY = scaleY ?? scaleX;
    $setTransformationChanged();
    return this;
  }

  /// Makes this object draggable. When this object is dragged, its x and y
  /// properties will be updated to match the mouse position.
  /// The [lockCenter] parameter, if set to true, will cause the object to be
  /// dragged from its center point.
  /// The [bounds] parameter can be used to restrict the movement of the object
  /// to a certain area.
  /// Throws an error if the object is not visible or touchable.
  void startDrag([bool lockCenter = false, GRect? bounds]) {
    if (!inStage || !$hasTouchableArea) {
      throw 'to drag an object, it has to be visible and enabled in the stage.';
    }

    $currentDrag?.stopDrag();
    $currentDrag = this;
    $currentDragBounds = bounds;
    _dragCenterOffset = GPoint();
    if (lockCenter) {
      _dragCenterOffset.setTo(x - parent!.mouseX, y - parent!.mouseY);
    }
    stage!.onMouseMove.add(_handleDrag);
  }

  /// Stops the current drag operation, if this DisplayObject is currently being
  /// dragged. Removes the mouse move event listener and sets the current drag
  /// object to null. Does nothing if this DisplayObject is not currently being
  /// dragged.
  void stopDrag() {
    if (this == $currentDrag && inStage) {
      stage!.onMouseMove.remove(_handleDrag);
      $currentDrag = null;
    }
  }

  /// Returns a string representation of this object.
  @override
  String toString() {
    final msg = name != null ? ' (name: $name)' : '';
    final pos = '(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
    final size = '(${width.toStringAsFixed(2)} x ${height.toStringAsFixed(2)})';
    final rotationStr =
        rotation == 0 ? '' : ', rotation: ${rotation.toStringAsFixed(2)}';
    final scaleXStr =
        scaleX == 1 ? '' : ', scaleX: ${scaleX.toStringAsFixed(2)}';
    final scaleYStr =
        scaleY == 1 ? '' : ', scaleY: ${scaleY.toStringAsFixed(2)}';
    return '$runtimeType$msg at $pos, size: $size$rotationStr$scaleXStr$scaleYStr';
  }

  /// Called once per frame on each display object being rendered.
  ///
  /// The [delta] argument is the time elapsed since the last update.
  /// Subclasses must call `super.update(delta)` at the beginning of their
  /// implementation to ensure the object's correct functionality.
  @mustCallSuper
  void update(double delta) {}

  /// Handles the drag behavior of the draggable object. This method is called
  /// when a mouse input event is received. If this object is not the current
  /// drag object, removes the [onMouseMove] listener from the [stage]. If there
  /// is no current drag object, sets the current drag bounds to null and
  /// returns. Calculates the new position of the drag object based on the mouse
  /// input event and the drag center offset, and clamps the position within the
  /// drag bounds, if provided. Finally, sets the new position of the drag
  /// object using the [setPosition] method.
  void _handleDrag(MouseInputData input) {
    if (this != $currentDrag) {
      stage?.onMouseMove.remove(_handleDrag);
    }
    if ($currentDrag == null) {
      $currentDragBounds = null;
      return;
    }
    var tx = $currentDrag!.parent!.mouseX + _dragCenterOffset.x;
    var ty = $currentDrag!.parent!.mouseY + _dragCenterOffset.y;
    final rect = $currentDragBounds;
    if (rect != null) {
      tx = tx.clamp(rect.left, rect.right);
      ty = ty.clamp(rect.top, rect.bottom);
    }
    setPosition(tx, ty);
  }

  /// Warns that 3D transformations are not fully supported.
  void _warn3d() {
    if (kDebugMode) {
      print('Warning: 3d transformations still not properly supported');
    }
    _isWarned3d = true;
  }

  /// Finds the common parent object between two display objects.
  ///
  /// Starting from [obj1], this method climbs up the display object hierarchy
  /// by following the [$parent] reference of each object until it reaches the
  /// root. Then it starts from [obj2] and climbs up the hierarchy until it
  /// finds a common parent with [obj1].
  ///
  /// If no common parent is found, an exception is thrown.
  static GDisplayObject _findCommonParent(
    GDisplayObject obj1,
    GDisplayObject obj2,
  ) {
    GDisplayObject? current = obj1;

    /// TODO: use faster Hash access.
    while (current != null) {
      _sAncestors.add(current);
      current = current.$parent;
    }
    current = obj2;
    while (current != null && !_sAncestors.contains(current)) {
      current = current.$parent;
    }
    _sAncestors.length = 0;
    if (current != null) return current;
    throw 'Object not connected to target';
  }
}
