import 'package:graphx/graphx/display/display_object.dart';
import 'package:graphx/graphx/utils/list_utils.dart';

typedef SortChildrenCallback = int Function(
    DisplayObject object1, DisplayObject object2);

abstract class DisplayObjectContainer extends DisplayObject {
  final children = <DisplayObject>[];

  DisplayObject addChild(DisplayObject child) {
    return addChildAt(child, children.length);
  }

  DisplayObject addChildAt(DisplayObject child, int index) {
    if (child == null) throw "Child can't be null";
    if (index < 0 || index > children.length) {
      throw RangeError('Invalid child index');
//      throw RangeError.range(
//          index, 0, children.length - 1, null, 'Invalid child index');
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
        if (child is DisplayObjectContainer) {
          _broadcastChildrenAddedToStage(child);
        } else {
          child.$onAddedToStage?.dispatch();
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

  int getChildIndex(DisplayObject child) => children.indexOf(child);

  void setChildIndex(DisplayObject child, int index) {
    final old = getChildIndex(child);
    if (old == index) return;
    if (old == -1)
      throw ArgumentError.value(child, null, "Not a child of this container");
    children.removeAt(old);
    children.insert(index, child);
    requiresRedraw();
  }

  @override
  void paint(c) {
    super.paint(c);
//    print("Paing is: $c");
  }

  void swapChildren(DisplayObject child1, DisplayObject child2) {
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

  static var _sortBuffer = [];

  void sortChildren(SortChildrenCallback compare) {
    _sortBuffer.length = children.length;
    ListUtils.mergeSort(children, compare, 0, children.length, _sortBuffer);
    _sortBuffer.clear();
    requiresRedraw();
  }

  void _broadcastChildrenAddedToStage(DisplayObjectContainer child) {
    child.children.forEach((e) {
      e.$onAddedToStage?.dispatch();
      if (e is DisplayObjectContainer) _broadcastChildrenAddedToStage(e);
    });
  }

  DisplayObject getChildAt(int index) {
    final len = children.length;
    if (index < 0) index = len + index;
    if (index >= 0 && index < len) return children[index];
    throw RangeError("Invalid child index");
    return null;
  }

  DisplayObject getChildByName(String name) {
    for (final child in children) {
      if (child.name == name) return child;
    }
    return null;
  }

  void removeChildren([
    int fromIndex = 0,
    int endIndex = 0,
    bool dispose = false,
  ]) {
    if (endIndex < 0 || endIndex >= numChildren) endIndex = numChildren - 1;
    for (var i = fromIndex; i <= endIndex; ++i)
      removeChildAt(
        fromIndex,
        dispose,
      );
  }

  int get numChildren => children.length;

  bool get hasChildren => children.isNotEmpty;

  bool contains(DisplayObject child) {
    return children.contains(child);
  }

  DisplayObject removeChildAt(int index, [bool dispose = false]) {
    if (index < 0 || index > children.length) throw "Invalid child index";
    requiresRedraw();
    final child = children[index];
    child.$onRemoved?.dispatch();
    if (stage != null) {
      if (child is DisplayObjectContainer) {
        _broadcastChildrenAddedToStage(child);
      } else {
        child.$onRemovedFromStage?.dispatch();
      }
      child.$setParent(null);
      index = children.indexOf(child);
      if (index >= 0) children.removeAt(index);
      if (dispose) child.dispose();
      return child;
    }
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
  void $applyPaint() {
    if (!visible) return;
    children.forEach((c) {
      if (c.visible) c.paint($canvas);
    });
  }

  @override
  void dispose() {
    for (final child in children) child?.dispose();
//    parent = null;
//    children.forEach((e) => e.dispose());
    children.clear();
    super.dispose();
  }
}
