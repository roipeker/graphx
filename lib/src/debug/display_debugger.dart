import 'dart:ui' as ui;

import '../../graphx.dart';

/// An enumeration representing different modes for rendering debug bounding
/// boxes in GraphX.
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

/// A utility class for debugging and rendering the bounding boxes of
/// `GDisplayObject` instances. The `DisplayBoundsDebugger` can be used to
/// render the bounding boxes of display objects when `debugBounds` is enabled
/// on them.
///
/// To use the `DisplayBoundsDebugger`, set `$debugBounds=true` on any
/// `GDisplayObject`.
class DisplayBoundsDebugger {
  /// The debug mode for rendering bounds. When set to
  /// [DebugBoundsMode.internal], only display objects with `debugBounds`
  /// enabled will be rendered. When set to [DebugBoundsMode.full], all display
  /// objects will be rendered, regardless of the [debugBounds] flag.
  static DebugBoundsMode debugBoundsMode = DebugBoundsMode.internal;

  /// A global flag to disable all debug bounds rendering for performance.
  static bool enabled = true;

  /// A global flag to render the bounding box of every display object.
  static bool debugAll = false;

  /// The paint to use for rendering debug bounds.
  static final ui.Paint _debugPaint = ui.Paint()
    ..style = ui.PaintingStyle.stroke
    ..color = kColorCyan
    ..strokeWidth = 1;

  /// A temporary `GRect` instance used for calculating object bounds.
  static final GRect _sHelpRect = GRect();

  /// The root display object container for the bounds rendering.
  final GDisplayObjectContainer _root;

  /// The canvas to render the bounds onto.
  ui.Canvas? canvas;

  /// Creates a new [DisplayBoundsDebugger] instance with the given root
  /// `GDisplayObjectContainer`. (should be private)
  DisplayBoundsDebugger(GDisplayObjectContainer root) : _root = root;

  /// Renders the bounds of all objects that have [debugBounds] enabled or have
  /// the [debugAll] flag set to `true`.
  void render() {
    if (debugBoundsMode == DebugBoundsMode.internal || !enabled) {
      return;
    }
    _renderChildren(_root);
  }

  /// Renders the bounds of a given display object.
  void _renderBounds(GDisplayObject obj) {
    obj.getBounds(_root, _sHelpRect);
    final paint = obj.$debugBoundsPaint ?? _debugPaint;
    final linePaint = paint.clone();
    linePaint.color = linePaint.color.withOpacity(.3);
    final rect = _sHelpRect.toNative();
    canvas!.drawLine(rect.topLeft, rect.bottomRight, linePaint);
    canvas!.drawLine(rect.topRight, rect.bottomLeft, linePaint);
    canvas!.drawRect(rect, paint);
  }

  /// Recursively renders the bounds of the children of a given display object.
  void _renderChildren(GDisplayObjectContainer obj) {
    if (obj.$debugBounds || debugAll) {
      _renderBounds(obj);
    }
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
}
