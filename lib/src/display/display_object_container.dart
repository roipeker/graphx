import 'dart:ui' as ui;

import '../../graphx.dart';

typedef SortChildrenCallback = int Function(
  GDisplayObject object1,
  GDisplayObject object2,
);

abstract class GDisplayObjectContainer extends GDisplayObject {
  final children = <GDisplayObject>[];

  GDisplayObjectContainer() {
    allowSaveLayer = true;
  }

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (DisplayObjectContainer)$msg';
  }

  static final _sHitTestMatrix = GMatrix();
  static final _sHitTestPoint = GPoint();
  static GMatrix $sBoundsMatrix = GMatrix();
  static GPoint $sBoundsPoint = GPoint();

  bool mouseChildren = true;

  /// capture context mouse inputs.
  @override
  void captureMouseInput(MouseInputData input) {
    if (!$hasTouchableArea) return;
    if (mouseChildren) {
      /// from last child to the bottom to capture the input.
      for (var i = children.length - 1; i >= 0; --i) {
        children[i].captureMouseInput(input);
      }
    }
    super.captureMouseInput(input);
  }

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

  T addChild<T extends GDisplayObject>(T child) {
    return addChildAt(child, children.length);
  }

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

  int getChildIndex(GDisplayObject child) => children.indexOf(child);

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

  void swapChildren(GDisplayObject child1, GDisplayObject child2) {
    final idx1 = getChildIndex(child1);
    final idx2 = getChildIndex(child2);
    if (idx1 == -1 || idx2 == -1) {
      throw ArgumentError('Not a child of this container');
    }
    swapChildrenAt(idx1, idx2);
  }

  void swapChildrenAt(int index1, int index2) {
    final child1 = getChildAt(index1);
    final child2 = getChildAt(index2);
    children[index1] = child2;
    children[index2] = child1;
    requiresRedraw();
  }

//  static final _sortBuffer = <DisplayObject>[];

  void sortChildren(SortChildrenCallback compare) {
    children.sort(compare);
//    _sortBuffer.length = children.length;
//    print("buffer len:: ${_sortBuffer.length}");
//    ListUtils.mergeSort(children, compare, 0, children.length, _sortBuffer);
//    _sortBuffer.clear();
    requiresRedraw();
  }

  T getChildAt<T extends GDisplayObject>(int index) {
    final len = children.length;
    if (index < 0) index = len + index;
    if (index >= 0 && index < len) return children[index] as T;
    throw RangeError('Invalid child index');
  }

  T? getChildByName<T extends GDisplayObject>(String name) {
    for (final child in children) {
      if (child.name == name) return child as T;
    }
    return null;
  }

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

  int get numChildren => children.length;

  bool get hasChildren => children.isNotEmpty;

  bool contains(GDisplayObject? child, [bool recursive = true]) {
    if (!recursive) return children.contains(child);
    while (child != null) {
      if (child == this) return true;
      child = child.$parent;
    }
    return false;
  }

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
      if (index >= 0) children.removeAt(index);
      if (dispose) child.dispose();
      return child as T;
    }
    throw 'Invalid child index';
  }

  T? removeChild<T extends GDisplayObject>(T child, [bool dispose = false]) {
    if (child.$parent != this) return null;
    final index = getChildIndex(child);
    if (index > -1) return removeChildAt<T>(index, dispose);
    throw 'Invalid child index';
  }

  @override
  void update(double delta) {
    super.update(delta);
    final tmp = List.unmodifiable(children);
    for (var child in tmp) {
      child.update(delta);
    }
  }

  @override
  void $applyPaint(ui.Canvas canvas) {
    if (!$hasVisibleArea) return;
    for (var child in children) {
      if (child.$hasVisibleArea) {
        var mask = child.$mask;
        if (mask != null) {
          _drawMask(mask, child);
        }
        //TODO: add filters.
        child.paint(canvas);
        if (mask != null) {
          _eraseMask(mask, child);
        }
      }
    }
  }

  @override
  @mustCallSuper
  void dispose() {
    for (final child in children) {
      child.dispose();
    }
    children.clear();
    super.dispose();
  }

  static void _broadcastChildrenRemovedFromStage(
    GDisplayObjectContainer child,
  ) {
    for (var e in child.children) {
      e.removedFromStage();
      e.$onRemovedFromStage?.dispatch();
      if (e is GDisplayObjectContainer) _broadcastChildrenRemovedFromStage(e);
    }
  }

  static void _broadcastChildrenAddedToStage(
    GDisplayObjectContainer child,
  ) {
    for (var e in child.children) {
      e.addedToStage();
      e.$onAddedToStage?.dispatch();
      if (e is GDisplayObjectContainer) _broadcastChildrenAddedToStage(e);
    }
  }

  void _drawMask(GDisplayObject mask, GDisplayObject child) {}

  void _eraseMask(GDisplayObject mask, GDisplayObject child) {}
}
