import '../../graphx.dart';

typedef SortChildrenCallback = int Function(
    DisplayObject object1, DisplayObject object2);

abstract class DisplayObjectContainer extends DisplayObject {
  final children = <DisplayObject>[];

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (DisplayObjectContainer)$msg';
  }

  static final _sHitTestMatrix = GxMatrix();
  static final _sHitTestPoint = GxPoint();
  static GxMatrix $sBoundsMatrix = GxMatrix();
  static GxPoint $sBoundsPoint = GxPoint();

  bool mouseChildren = true;

  /// capture context mouse inputs.
  @override
  void captureMouseInput(MouseInputData input) {
    if (!$hasVisibleArea) return;
    if (mouseChildren) {
      /// from last child to the bottom to capture the input.
      for (var i = children.length - 1; i >= 0; --i) {
        children[i].captureMouseInput(input);
      }
    }
    super.captureMouseInput(input);
  }

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
    out ??= GxRect();
    final len = children.length;
    if (len == 0) {
      getTransformationMatrix(targetSpace, $sBoundsMatrix);
      $sBoundsMatrix.transformCoords(0, 0, $sBoundsPoint);
      out.setTo($sBoundsPoint.x, $sBoundsPoint.y, 0, 0);
      return out;
    } else if (len == 1) {
      return children[0].getBounds(targetSpace, out);
    } else {
      var minx = 10000000.0;
      var maxx = -10000000.0;
      var miny = 10000000.0;
      var maxy = -10000000.0;
      final len = numChildren;
//      print('fits here with: $len');
      for (var i = 0; i < len; ++i) {
        children[i].getBounds(targetSpace, out);
//        print('i $i, out: $out $this');
        if (out.isEmpty) continue;
        if (minx > out.x) minx = out.x;
        if (maxx < out.right) maxx = out.right;
        if (miny > out.y) miny = out.y;
        if (maxy < out.bottom) maxy = out.bottom;
//        minx = minx < out.x ? minx : out.x;
//        maxx = maxx > out.right ? maxx : out.right;
//        miny = miny < out.y ? miny : out.y;
//        maxy = maxy > out.bottom ? maxy : out.bottom;
      }
      out.setTo(minx, miny, maxx - minx, maxy - miny);
      return out;
    }
  }

  List<DisplayObject> getObjectsUnderPoint(GxPoint localPoint) {
    final result = <DisplayObject>[];
    if (!$hasVisibleArea || !mouseEnabled || !hitTestMask(localPoint)) {
      return result;
    }
    final numChild = children.length;
    DisplayObject target;
    for (var i = numChild - 1; i >= 0; --i) {
      var child = children[i];
      if (child.isMask) continue;
      _sHitTestMatrix.copyFrom(child.transformationMatrix);
      _sHitTestMatrix.invert();
      _sHitTestMatrix.transformCoords(
          localPoint.x, localPoint.y, _sHitTestPoint);
      if (child is DisplayObjectContainer) {
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
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!$hasVisibleArea || !mouseEnabled || !hitTestMask(localPoint)) {
      return null;
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

  DisplayObject addChild(DisplayObject child) {
    return addChildAt(child, children.length);
  }

  DisplayObject addChildAt(DisplayObject child, int index) {
    if (child == null) throw "::child can't be null";
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
        if (child is DisplayObjectContainer) {
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

  int getChildIndex(DisplayObject child) => children.indexOf(child);

  void setChildIndex(DisplayObject child, int index) {
    final old = getChildIndex(child);
    if (old == index) return;
    if (old == -1) {
      throw ArgumentError.value(child, null, 'Not a child of this container');
    }
    children.removeAt(old);
    children.insert(index.clamp(0, numChildren), child);
    requiresRedraw();
  }

  void swapChildren(DisplayObject child1, DisplayObject child2) {
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

  DisplayObject getChildAt(int index) {
    final len = children.length;
    if (index < 0) index = len + index;
    if (index >= 0 && index < len) return children[index];
    throw RangeError('Invalid child index');
  }

  DisplayObject getChildByName(String name) {
    for (final child in children) {
      if (child.name == name) return child;
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

  bool contains(DisplayObject child, [bool recursive = true]) {
    if (!recursive) return children.contains(child);
    while (child != null) {
      if (child == this) return true;
      child = child.$parent;
    }
    return false;
  }

  DisplayObject removeChildAt(int index, [bool dispose = false]) {
    if (index >= 0 && index < children.length) {
      requiresRedraw();
      final child = children[index];
      child.$onRemoved?.dispatch();
      if (stage != null) {
        child.$onRemovedFromStage?.dispatch();
        child.removedFromStage();
        if (child is DisplayObjectContainer) {
          _broadcastChildrenRemovedFromStage(child);
        }
      }
      child.$setParent(null);
      index = children.indexOf(child);
      if (index >= 0) children.removeAt(index);
      if (dispose) child.dispose();
      return child;
    }
//    throw "Invalid child index";
    return null;
  }

  DisplayObject removeChild(DisplayObject child, [bool dispose = false]) {
    if (child == null || child?.$parent != this) return null;
    final index = getChildIndex(child);
    if (index > -1) return removeChildAt(index, dispose);
    return null;
//    throw "$child belongs to another parent. Can't be removed.";
//    child?.$onRemoved?.dispatch();
//    if (child.stage != null) {
//      child?.$onRemovedFromStage?.dispatch();
//    }
//    child.parent = null;
//    return children.remove(child);
  }

  @override
  void paint(c) {
    super.paint(c);
//    print("Paing is: $c");
  }

  @override
  void update(double delta) {
    for (var child in children) {
      child.update(delta);
    }
  }

  @override
  void $applyPaint(Canvas canvas) {
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
  void dispose() {
    for (final child in children) {
      child?.dispose();
    }
    children.clear();
    super.dispose();
  }

  static void _broadcastChildrenRemovedFromStage(DisplayObjectContainer child) {
    child.children.forEach((e) {
      e.removedFromStage();
      e.$onRemovedFromStage?.dispatch();
      if (e is DisplayObjectContainer) _broadcastChildrenRemovedFromStage(e);
    });
  }

  static void _broadcastChildrenAddedToStage(DisplayObjectContainer child) {
    child.children.forEach((e) {
      e.addedToStage();
      e.$onAddedToStage?.dispatch();
      if (e is DisplayObjectContainer) _broadcastChildrenAddedToStage(e);
    });
  }

  void _drawMask(DisplayObject mask, DisplayObject child) {}

  void _eraseMask(DisplayObject mask, DisplayObject child) {}
}
