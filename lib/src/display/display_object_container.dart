import '../../graphx/display/display_object.dart';
import '../../graphx/events/pointer_data.dart';
import '../../graphx/geom/gxmatrix.dart';
import '../../graphx/geom/gxpoint.dart';
import '../../graphx/geom/gxrect.dart';

typedef SortChildrenCallback = int Function(
    IAnimatable object1, IAnimatable object2);

abstract class DisplayObjectContainer extends IAnimatable {
  final children = <IAnimatable>[];

  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (DisplayObjectContainer)$msg';
  }

  static GxMatrix _sHitTestMatrix = GxMatrix();
  static GxPoint _sHitTestPoint = GxPoint();
  static GxMatrix $sBoundsMatrix = GxMatrix();
  static GxPoint $sBoundsPoint = GxPoint();

  bool touchGroup = false;

  /// capture context mouse inputs.
  @override
  void captureMouseInput(PointerEventData e) {
    if (!$hasVisibleArea || !touchable) return;

    if (!touchGroup) {
      for (final child in children) {
        child.captureMouseInput(e);
      }
    }

    if (touchable) {
      /// hit tesst?
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
  }

  @override
  GxRect getBounds(IAnimatable targetSpace, [GxRect out]) {
    out ??= GxRect();
    final len = children.length;
    if (len == 0) {
      getTransformationMatrix(targetSpace, $sBoundsMatrix);
      $sBoundsMatrix.transformCoords(0, 0, $sBoundsPoint);
      out.setTo($sBoundsPoint.x, $sBoundsPoint.y, 0, 0);
    } else if (len == 1) {
      children[0].getBounds(targetSpace, out);
    } else {
      double minx = 10000000.0;
      double maxx = -10000000.0;
      double miny = 10000000.0;
      double maxy = -10000000.0;
      final len = numChildren;
      for (var i = 0; i < len; ++i) {
        children[i].getBounds(targetSpace, out);

        /// TODO: add flag to validate this?
        if (out.isEmpty) continue;
        if (minx > out.x) minx = out.x;
        if (maxx < out.right) maxx = out.right;
        if (miny > out.y) miny = out.y;
        if (maxy < out.bottom) maxy = out.bottom;
      }
      out.setTo(minx, miny, maxx - minx, maxy - miny);
    }
    return out;
  }

  List<IAnimatable> getObjectsUnderPoint(GxPoint localPoint) {
    final result = <IAnimatable>[];
    if (!visible || !touchable || !hitTestMask(localPoint)) return result;
    final numChild = children.length;
    IAnimatable target;
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
  IAnimatable hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !touchable || !hitTestMask(localPoint)) return null;
    IAnimatable target;
    final numChild = children.length;
    for (var i = numChild - 1; i >= 0; --i) {
      var child = children[i];
      if (child.isMask) continue;
      _sHitTestMatrix.copyFrom(child.transformationMatrix);
      _sHitTestMatrix.invert();
      _sHitTestMatrix.transformCoords(
          localPoint.x, localPoint.y, _sHitTestPoint);
      target = child.hitTest(_sHitTestPoint);
      if (target != null) return touchGroup ? this : target;
    }
    return null;
  }

  IAnimatable addChild(IAnimatable child) {
    return addChildAt(child, children.length);
  }

  IAnimatable addChildAt(IAnimatable child, int index) {
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
      }
    }
    return child;
//    child?.parent?.removeChild(child);
//    child.parent = this;
//    children.insert(index, child);
//    child.$stage = stage;
//    if (child is DisplayObjectContainer) {}
  }

  int getChildIndex(IAnimatable child) => children.indexOf(child);

  void setChildIndex(IAnimatable child, int index) {
    final old = getChildIndex(child);
    if (old == index) return;
    if (old == -1)
      throw ArgumentError.value(child, null, "Not a child of this container");
    children.removeAt(old);
    children.insert(index.clamp(0, numChildren), child);
    requiresRedraw();
  }

  void swapChildren(IAnimatable child1, IAnimatable child2) {
    final idx1 = getChildIndex(child1);
    final idx2 = getChildIndex(child2);
    if (idx1 == -1 || idx2 == -1)
      throw ArgumentError("Not a child of this container");
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

  IAnimatable getChildAt(int index) {
    final len = children.length;
    if (index < 0) index = len + index;
    if (index >= 0 && index < len) return children[index];
    throw RangeError("Invalid child index");
  }

  IAnimatable getChildByName(String name) {
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
    if (endIndex < 0 || endIndex >= children.length)
      endIndex = children.length - 1;

    for (var i = fromIndex; i <= endIndex; ++i)
      removeChildAt(
        fromIndex,
        dispose,
      );
  }

  int get numChildren => children.length;

  bool get hasChildren => children.isNotEmpty;

  bool contains(IAnimatable child, [bool recursive = true]) {
    if (!recursive) return children.contains(child);
    while (child != null) {
      if (child == this) return true;
      child = child.$parent;
    }
    return false;
  }

  IAnimatable removeChildAt(int index, [bool dispose = false]) {
    if (index >= 0 && index < children.length) {
      requiresRedraw();
      final child = children[index];
      child.$onRemoved?.dispatch();
      if (stage != null) {
        child.$onRemovedFromStage?.dispatch();
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

  IAnimatable removeChild(IAnimatable child, [bool dispose = false]) {
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
  void $applyPaint() {
    if (!$hasVisibleArea) return;
    for (var child in children) {
      if (child.$hasVisibleArea) {
        var mask = child.$mask;
        if (mask != null) {
          _drawMask(mask, child);
        }
        //TODO: add filters.
        child.paint($canvas);
        if (mask != null) {
          _eraseMask(mask, child);
        }
      }
    }
  }

  @override
  void dispose() {
    for (final child in children) child?.dispose();
    children.clear();
    super.dispose();
  }

  static void _broadcastChildrenRemovedFromStage(DisplayObjectContainer child) {
    child.children.forEach((e) {
      e.$onRemovedFromStage?.dispatch();
      if (e is DisplayObjectContainer) _broadcastChildrenRemovedFromStage(e);
    });
  }

  static void _broadcastChildrenAddedToStage(DisplayObjectContainer child) {
    child.children.forEach((e) {
      e.$onAddedToStage?.dispatch();
      if (e is DisplayObjectContainer) _broadcastChildrenAddedToStage(e);
    });
  }

  void _drawMask(IAnimatable mask, IAnimatable child) {}

  void _eraseMask(IAnimatable mask, IAnimatable child) {}
}
