import 'dart:ui' as ui;

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

  static final ui.Paint _debugPaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..color = kColorCyan
    ..strokeWidth = 1;

  final GDisplayObjectContainer _root;
  ui.Canvas? canvas;
  static final GRect _sHelpRect = GRect();

  DisplayBoundsDebugger(GDisplayObjectContainer root) : _root = root;

  void render() {
    if (debugBoundsMode == DebugBoundsMode.internal || !enabled) return;
    _renderChildren(_root);
  }

  void _renderChildren(GDisplayObjectContainer obj) {
    if (obj.$debugBounds || debugAll) _renderBounds(obj);
    for (final child in obj.children) {
      if (child is GDisplayObjectContainer) {
        _renderChildren(child);
      } else {
        if (child.$debugBounds || debugAll) {
          _renderBounds(child);
        }
      }
    }
  }

  void _renderBounds(GDisplayObject obj) {
    obj.getBounds(_root, _sHelpRect);
    final _paint = obj.$debugBoundsPaint ?? _debugPaint;
    final linePaint = _paint.clone();
    linePaint.color = linePaint.color.withOpacity(.3);
    final rect = _sHelpRect.toNative();
    canvas!.drawLine(rect.topLeft, rect.bottomRight, linePaint);
    canvas!.drawLine(rect.topRight, rect.bottomLeft, linePaint);
    canvas!.drawRect(rect, _paint);
  }
}
