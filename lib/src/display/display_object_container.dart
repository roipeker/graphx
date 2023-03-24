import 'dart:ui' as ui;

import '../../graphx.dart';

/// A function used to sort the children of this container.
///
/// The function should take two [GDisplayObject]s as parameters and return
/// an integer. If the first object should come before the second, return
/// a negative number. If they should be in the same order, return 0. If the
/// second should come before the first, return a positive number.
typedef SortChildrenCallback = int Function(
  GDisplayObject object1,
  GDisplayObject object2,
);

/// The base class for a display object that can contain child
/// [GDisplayObject]s. A display object container is a display object that can
/// contain other display objects as children. It renders its children in the
/// order in which they are added.
abstract class GDisplayObjectContainer extends GDisplayObject {
  /// Internal utility:
  /// The transformation matrix used to hit test the container's children.
  static final _sHitTestMatrix = GMatrix();

  /// Internal utility:
  /// The local point used to hit test the container's children.
  static final _sHitTestPoint = GPoint();

  /// (Internal usage):
  /// The bounds matrix for calculating the bounds of the container.
  static GMatrix $sBoundsMatrix = GMatrix();

  /// (Internal usage):
  /// The bounds point for calculating the bounds of the container.
  static GPoint $sBoundsPoint = GPoint();

  /// The list of children that this container holds.
  final children = <GDisplayObject>[];

  /// Whether this container will capture mouse input events for its children.
  bool mouseChildren = true;

  /// Creates a new [GDisplayObjectContainer].
  GDisplayObjectContainer() {
    allowSaveLayer = true;
  }

  /// Whether this container has any children.
  bool get hasChildren {
    return children.isNotEmpty;
  }

  /// The number of children of this container.
  int get numChildren {
    return children.length;
  }

  /// (Internal usage)
  /// Applies the container's paint to the specified [canvas].
  ///
  /// This method is called by the parent container to paint this container
  /// on the screen. It will apply the paint of each visible child object to
  /// the [canvas] in the order they appear in the [children] list.
  ///
  /// This method should not be called directly.
  @override
  void $applyPaint(ui.Canvas canvas) {
    if (!$hasVisibleArea) {
      return;
    }
    for (var child in children) {
      if (child.$hasVisibleArea) {
        // var mask = child.$mask;
        // if (mask != null) {
        //   _drawMask(mask, child);
        // }
        //TODO: add filters.
        child.paint(canvas);
        // if (mask != null) {
        //   _eraseMask(mask, child);
        // }
      }
    }
  }

  /// Adds a child to the end of the list of children of this container.
  ///
  /// The type parameter [T] specifies the type of the child to add.
  T addChild<T extends GDisplayObject>(T child) {
    return addChildAt(child, children.length);
  }

  /// Adds a child to the list of children of this container at a specific
  /// index.
  ///
  /// The type parameter [T] specifies the type of the child to add.
  T addChildAt<T extends GDisplayObject>(T child, int index) {
    if (index < 0 || index > children.length) {
      throw RangeError('Invalid child index');
    }
    requiresRedraw();
    if (child.$parent == this) {
      setChildIndex(child, index);
    } else {
      children.insert(index, child);
      child.removeFromParent();
      child.$setParent(this);
      child.$onAdded?.dispatch();
      if (stage != null) {
        child.$onAddedToStage?.dispatch();
        if (child is GDisplayObjectContainer) {
          _broadcastChildrenAddedToStage(child);
        }
        child.addedToStage();
      }
    }
    return child;
//    child?.parent?.removeChild(child);
//    child.parent = this;
//    children.insert(index, child);
//    child.$stage = stage;
//    if (child is DisplayObjectContainer) {}
  }

  /// Captures the given [input] for this container and its children.
  ///
  /// If [mouseChildren] is true, the input will be captured by all children as
  /// well.
  @override
  void captureMouseInput(MouseInputData input) {
    if (!$hasTouchableArea) {
      return;
    }
    if (mouseChildren) {
      /// from last child to the bottom to capture the input.
      for (var i = children.length - 1; i >= 0; --i) {
        children[i].captureMouseInput(input);
      }
    }
    super.captureMouseInput(input);
  }

  /// Returns true if a given [child] is a descendant of this container, or
  /// false otherwise.
  bool contains(GDisplayObject? child, [bool recursive = true]) {
    if (!recursive) {
      return children.contains(child);
    }
    while (child != null) {
      if (child == this) {
        return true;
      }
      child = child.$parent;
    }
    return false;
  }

  /// Disposes of this container and all of its children.
  ///
  /// This method should be called when this container is no longer needed, to
  /// release any resources it holds.
  ///
  /// After calling this method, this container and all of its children will
  /// be unusable.
  @override
  @mustCallSuper
  void dispose() {
    for (final child in children) {
      child.dispose();
    }
    children.clear();
    super.dispose();
  }

  /// Returns the bounds of this container in the given [targetSpace].
  ///
  /// If [out] is provided, the results will be stored there. Otherwise, a new
  /// [GRect] will be created and returned.
  @override
  GRect? getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    out ??= GRect();
    final len = children.length;
    if (len == 0) {
      getTransformationMatrix(targetSpace, $sBoundsMatrix);
      $sBoundsMatrix.transformCoords(0, 0, $sBoundsPoint);
      out.setTo($sBoundsPoint.x, $sBoundsPoint.y, 0, 0);
      return out;
    } else if (len == 1) {
      return children[0].getBounds(targetSpace, out);
    } else {
      var minX = 10000000.0;
      var maxX = -10000000.0;
      var minY = 10000000.0;
      var maxY = -10000000.0;
      final len = numChildren;
      for (var i = 0; i < len; ++i) {
        children[i].getBounds(targetSpace, out);
        if (out.isEmpty) continue;
        if (minX > out.x) minX = out.x;
        if (maxX < out.right) maxX = out.right;
        if (minY > out.y) minY = out.y;
        if (maxY < out.bottom) maxY = out.bottom;
      }
      out.setTo(minX, minY, maxX - minX, maxY - minY);
      return out;
    }
  }

  /// Returns the child at a specific index in the list of children of this
  /// container.
  T getChildAt<T extends GDisplayObject>(int index) {
    final len = children.length;
    if (index < 0) index = len + index;
    if (index >= 0 && index < len) {
      return children[index] as T;
    }
    throw RangeError('Invalid child index');
  }

  /// Returns the child object that exists with the specified [name].
  ///
  /// The search includes the current object and all of its children,
  /// recursively.
  ///
  /// If the specified child does not exist, the method returns `null`.
  ///
  /// Optionally, this method can also search children of [child] recursively.
  ///
  /// The [T] generic parameter specifies the expected return type.
  /// If the type of the child that matches the specified name does not match
  /// the specified type, the method returns `null`.
  ///
  /// Usage:
  ///
  /// ```dart
  /// var container = GDisplayObjectContainer();
  /// container.addChild(GSprite()..name = 'sprite');
  /// var sprite = container.getChildByName<GSprite>('sprite');
  /// ```
  T? getChildByName<T extends GDisplayObject>(String name) {
    for (final child in children) {
      if (child.name == name) {
        return child as T;
      }
    }
    return null;
  }

  /// Returns the index of a child in the list of children of this container,
  /// or -1 if the child is not found.
  int getChildIndex(GDisplayObject child) {
    return children.indexOf(child);
  }

  /// Returns a list of display objects that are under the specified
  /// [localPoint].
  ///
  /// The list is sorted in such a way that the display object that is
  /// closest to the point is the first element.
  ///
  /// The [localPoint] parameter is in the local coordinate system of the
  /// display object container.
  ///
  /// If this display object container has a mask layer, display objects will be
  /// included in the returned list only if they are on the masked region.
  ///
  /// If the [recursive] parameter is set to `true`, the function will also
  /// return display objects that are nested within other display objects under
  /// the [localPoint].
  ///
  /// If no display objects were hit, the returned list is empty.
  List<GDisplayObject> getObjectsUnderPoint(GPoint localPoint) {
    final result = <GDisplayObject>[];
    if (!$hasTouchableArea || !mouseEnabled || !hitTestMask(localPoint)) {
      return result;
    }
    final numChild = children.length;
    GDisplayObject? target;
    for (var i = numChild - 1; i >= 0; --i) {
      var child = children[i];
      if (child.isMask) continue;
      _sHitTestMatrix.copyFrom(child.transformationMatrix);
      _sHitTestMatrix.invert();
      _sHitTestMatrix.transformCoords(
        localPoint.x,
        localPoint.y,
        _sHitTestPoint,
      );
      if (child is GDisplayObjectContainer) {
        result.addAll(child.getObjectsUnderPoint(_sHitTestPoint));
      }
      target = child.hitTest(_sHitTestPoint);
      if (target != null) {
        result.add(child);
      }
    }
    return result;
  }

  /// Determines if the display object or any of its children intersect with a
  /// [localPoint]. If [useShape] is set to true, the hit test will take the
  /// shape of the object into account. If [mouseChildren] is false, only the
  /// current display object will be tested.
  ///
  /// Returns the top-most display object that intersects with the [localPoint].
  /// If there's no intersection, returns null.
  ///
  /// If the [useShape] is set to true, the shape of the display object is used
  /// to determine the hit. Otherwise, the bounding box of the object is used.
  /// If the [mouseChildren] is set to false, only the current display object
  /// will be tested. If it is true, the hit test will continue on its children.
  @override
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!$hasTouchableArea || !mouseEnabled || !hitTestMask(localPoint)) {
      return null;
    }

    /// optimization.
    if (!mouseChildren) {
      return super.hitTest(localPoint, useShape);
    }

    final numChild = children.length;
    for (var i = numChild - 1; i >= 0; --i) {
      var child = children[i];
      if (child.isMask) continue;
      _sHitTestMatrix.copyFrom(child.transformationMatrix);
      _sHitTestMatrix.invert();
      _sHitTestMatrix.transformCoords(
        localPoint.x,
        localPoint.y,
        _sHitTestPoint,
      );
      final target = child.hitTest(_sHitTestPoint);
      if (target != null) {
        return mouseChildren ? this : target;
      }
    }
    return null;
  }

  /// Removes the specified child from this container.
  ///
  /// If the child is not a direct child of this container, `null` will be
  /// returned.
  ///
  /// If [dispose] is `true`, the removed child will also be disposed.
  ///
  /// Returns the removed child object, or `null` if the child is not a direct
  /// child of this container.
  T? removeChild<T extends GDisplayObject>(T child, [bool dispose = false]) {
    if (child.$parent != this) {
      return null;
    }
    final index = getChildIndex(child);
    if (index > -1) return removeChildAt<T>(index, dispose);
    throw 'Invalid child index';
  }

  /// Removes the child at the specified index from this container.
  ///
  /// If [index] is invalid, a `RangeError` will be thrown.
  ///
  /// If [dispose] is `true`, the removed child will also be disposed.
  ///
  /// Returns the removed child object.
  T removeChildAt<T extends GDisplayObject>(int index, [bool dispose = false]) {
    if (index >= 0 && index < children.length) {
      requiresRedraw();
      final child = children[index];
      child.$onRemoved?.dispatch();
      if (stage != null) {
        child.$onRemovedFromStage?.dispatch();
        child.removedFromStage();
        if (child is GDisplayObjectContainer) {
          _broadcastChildrenRemovedFromStage(child);
        }
      }
      child.$setParent(null);
      index = children.indexOf(child);
      if (index >= 0) {
        children.removeAt(index);
      }
      if (dispose) {
        child.dispose();
      }
      return child as T;
    }
    throw 'Invalid child index';
  }

  /// Removes a child from the list of children of this container based on its
  /// index.
  void removeChildren([
    int fromIndex = 0,
    int endIndex = -1,
    bool dispose = false,
  ]) {
    if (endIndex < 0 || endIndex >= children.length) {
      endIndex = children.length - 1;
    }

    for (var i = fromIndex; i <= endIndex; ++i) {
      removeChildAt(
        fromIndex,
        dispose,
      );
    }
  }

  /// Sets the index of a child in the list of children of this container.
  void setChildIndex(GDisplayObject child, int index) {
    final old = getChildIndex(child);
    if (old == index) return;
    if (old == -1) {
      throw ArgumentError.value(child, null, 'Not a child of this container');
    }
    children.removeAt(old);
    children.insert(index.clamp(0, numChildren), child);
    requiresRedraw();
  }

  /// Sorts the list of children of this container using a custom comparison
  /// function.
  void sortChildren(SortChildrenCallback compare) {
    children.sort(compare);
    requiresRedraw();
  }

  /// Swaps the positions of two children.
  /// Throws an [ArgumentError] if [child1] or [child2] are not children of this
  /// container. If [child1] and [child2] are the same object, nothing happens.
  ///
  /// Example:
  ///```dart
  ///   var container = GDisplayObjectContainer();
  ///   var child1 = GSprite();
  ///   var child2 = GQuad();
  ///   container.addChild(child1);
  ///   container.addChild(child2);
  ///   container.swapChildren(child1, child2);
  /// ```
  /// This will swap the positions of child1 and child2 in container.
  ///
  /// See also:
  ///
  /// * [swapChildrenAt], which swaps the positions of two children based on
  /// their indices instead of their references.
  ///
  /// * [setChildIndex], which changes the position of a child in the display
  /// list based on its index.
  void swapChildren(GDisplayObject child1, GDisplayObject child2) {
    final idx1 = getChildIndex(child1);
    final idx2 = getChildIndex(child2);
    if (idx1 == -1 || idx2 == -1) {
      throw ArgumentError('Not a child of this container');
    }
    swapChildrenAt(idx1, idx2);
  }

  /// Swaps the two children objects at the specified indexes.
  ///
  /// The index positions of the two objects are passed in as parameters to this
  /// method.
  /// If the index positions are invalid (i.e. out of range) an error is thrown.
  /// Otherwise, the objects at the specified index positions are swapped.
  /// After the swap is completed, the parent display object is redrawn if it is
  /// part of the stage display list.
  void swapChildrenAt(int index1, int index2) {
    final child1 = getChildAt(index1);
    final child2 = getChildAt(index2);
    children[index1] = child2;
    children[index2] = child1;
    requiresRedraw();
  }

  /// Returns a string representation of this container.
  @override
  String toString() {
    final nameStr = name != null ? 'name: $name, ' : '';
    final numChildrenStr =
        numChildren == 1 ? '1 child' : '$numChildren children';
    return '$runtimeType ($numChildrenStr, $nameStr)';
  }

  /// Updates all children of this container.
  ///
  /// The [delta] parameter specifies the time elapsed since the last frame.
  ///
  /// This method should be called (and gets called) once per frame to update
  /// the state of this container and its children.
  @override
  void update(double delta) {
    super.update(delta);
    final tmp = List.unmodifiable(children);
    for (var child in tmp) {
      child.update(delta);
    }
  }

  /// Recursively dispatches the added-to-stage event to all the children of the
  /// given [child] that are added to the stage. This is used internally to
  /// ensure that all the children of a container are notified when the
  /// container itself is added to the stage.
  ///
  /// If a child is a [GDisplayObjectContainer], the method will be called
  /// recursively on that child as well.
  ///
  /// This method should not be called directly by the user.
  static void _broadcastChildrenAddedToStage(
    GDisplayObjectContainer child,
  ) {
    for (var e in child.children) {
      e.addedToStage();
      e.$onAddedToStage?.dispatch();
      if (e is GDisplayObjectContainer) _broadcastChildrenAddedToStage(e);
    }
  }

  /// Notifies all child objects of a removed container [child] that they have
  /// been removed from the stage. This method is used internally by the
  /// framework to broadcast removedFromStage events to all children
  /// recursively. It should not be called directly by user code.
  static void _broadcastChildrenRemovedFromStage(
    GDisplayObjectContainer child,
  ) {
    for (var e in child.children) {
      e.removedFromStage();
      e.$onRemovedFromStage?.dispatch();
      if (e is GDisplayObjectContainer) _broadcastChildrenRemovedFromStage(e);
    }
  }

  /// TODO: implement later.
// void _drawMask(GDisplayObject mask, GDisplayObject child) {}
// void _eraseMask(GDisplayObject mask, GDisplayObject child) {}
}
