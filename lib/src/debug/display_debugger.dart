import '../../graphx.dart';

enum DebugBoundsMode {
  /// renders the bounding box transformed, inside the current object [paint()]
  /// method process.
  internal,

  /// renders the bounding box from the [Stage] itself, translating into each
  /// object's coordinate
  /// system. This represents visually the actual bounding boxes without any
  /// matrix
  /// transformations.
  stage,
}

class DisplayBoundsDebugger {
  static DebugBoundsMode debugBoundsMode = DebugBoundsMode.internal;

  /// for performance, a global way to deactivate all debug bounds rendering.
  static bool enabled = true;

  /// global way to render each and every DisplayObject bounding box using the
  /// current [DisplayBoundsDebugger.debugBoundsMode].
  static bool debugAll = false;

  static final Paint _debugPaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = Color(0xff00FFFF)
    ..strokeWidth = 1;

  final DisplayObjectContainer _root;
  Canvas canvas;
  static final GxRect _sHelpRect = GxRect();

  DisplayBoundsDebugger(DisplayObjectContainer root) : _root = root;

  void render() {
    if (debugBoundsMode == DebugBoundsMode.internal || !enabled) {
      return;
    }
    _renderChildren(_root);
  }

  void _renderChildren(DisplayObjectContainer obj) {
    if (obj.$debugBounds || debugAll) {
      _renderBounds(obj);
    }
    for (final child in obj.children) {
      if (child is DisplayObjectContainer) {
        _renderChildren(child);
      } else {
        if (child.$debugBounds || debugAll) {
          _renderBounds(child);
        }
      }
    }
  }

  void _renderBounds(DisplayObject obj) {
    obj.getBounds(_root, _sHelpRect);
    final _paint = obj.$debugBoundsPaint ?? _debugPaint;
//    $paintLine = _paint;
    final linePaint = _paint.clone();
    linePaint.color = linePaint.color.withOpacity(.3);

    final rect = _sHelpRect.toNative();
    canvas.drawLine(rect.topLeft, rect.bottomRight, linePaint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, linePaint);
    canvas.drawRect(rect, _paint);
  }
}
