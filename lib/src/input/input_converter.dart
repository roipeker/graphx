import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../graphx.dart';

/// A class that converts various input events into [PointerEventData] or
/// [KeyboardEventData] to be processed by [PointerManager] or
/// [KeyboardManager].
///
/// For internal use of GraphX.
///
class InputConverter {
  /// Manages pointer events and provides a mechanism for converting them into
  /// events that can be used in GraphX Scenes. The [PointerManager] class works
  /// in conjunction with the [InputConverter] class to handle pointer events
  /// and convert them into higher-level pointer events.
  final PointerManager pointer;

  /// A [KeyboardManager] instance that handles keyboard input events.
  final KeyboardManager keyboard;

  /// Creates a new [InputConverter] instance with the given [PointerManager]
  /// and [KeyboardManager] instances.
  InputConverter(this.pointer, this.keyboard);

  /// Called when a keyboard event is detected.
  void handleKey(RawKeyEvent event) {
    final isDown = event is RawKeyDownEvent;
    keyboard.$process(KeyboardEventData(
      type: isDown ? KeyEventType.down : KeyEventType.up,
      rawEvent: event,
    ));
  }

  /// Called when a pointer is canceled.
  void pointerCancel(PointerCancelEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.cancel,
      rawEvent: event,
    ));
  }

  /// Called when a pointer down event is detected.
  void pointerDown(PointerDownEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.down,
      rawEvent: event,
    ));
  }

  /// Called when the pointer enters a region.
  void pointerEnter(PointerEnterEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.enter,
      rawEvent: event,
    ));
  }

  /// Called when the pointer exits a region.
  void pointerExit(PointerExitEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.exit,
      rawEvent: event,
    ));
  }

  /// Called when the pointer is hovering (moving inside) over a region.
  void pointerHover(PointerHoverEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.hover,
      rawEvent: event,
    ));
  }

  /// Called when the pointer is moving.
  void pointerMove(PointerMoveEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.move,
      rawEvent: event,
    ));
  }

  /// Called when a pointer pan zoom event ends.
  void pointerPanZoomEnd(PointerPanZoomEndEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  /// Called when a pointer pan zoom event starts.
  /// Usually triggered by a 2-finger trackpad or pen gesture.
  void pointerPanZoomStart(PointerPanZoomStartEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  /// Called when a pointer pan zoom event is updated.
  void pointerPanZoomUpdate(PointerPanZoomUpdateEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.zoomPan,
      rawEvent: event,
    ));
  }

  /// Called when a pointer signal (mouse wheel) event is detected.
  void pointerSignal(PointerSignalEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.scroll,
      rawEvent: event,
    ));
  }

  /// Called when a pointer up event is detected.
  void pointerUp(PointerUpEvent event) {
    pointer.$process(PointerEventData(
      type: PointerEventType.up,
      rawEvent: event,
    ));
  }
}
