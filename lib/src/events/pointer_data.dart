import 'package:flutter/gestures.dart';

import '../../graphx.dart';

/// Data class that contains information about a mouse event.
class MouseInputData {
  /// Duration in milliseconds within which two mouse clicks count as a double
  /// click.
  static int doubleClickTime = 250;

  static final GPoint _localDelta = GPoint();

  /// Unique static identifier to assign to new mouse events.
  static int uniqueId = 0;

  /// Whether the mouse event has been captured.
  bool captured = false;

  /// The display object that is the target of the event.
  GDisplayObject? target;

  /// The display object that is the dispatcher of the event.
  GDisplayObject dispatcher;

  /// The type of mouse event that occurred.
  MouseInputType type;

  /// Whether the mouse button is pressed.
  bool buttonDown = false;

  /// Whether the mouse is outside the display object's bounds.
  bool mouseOut = false;

  /// The time at which the event occurred.
  double time = 0;

  /// The raw pointer event that triggered the mouse event.
  PointerEventData? rawEvent;

  /// An integer that defines which mouse buttons are pressed.
  int? buttonsFlags;

  final GPoint _stagePosition = GPoint();

  /// The position of the mouse in the display object's coordinate system.
  GPoint localPosition = GPoint();

  /// The delta of the mouse wheel or the pan gesture in the display object's
  /// coordinate system.
  GPoint scrollDelta = GPoint();

  /// Unique identifier for the mouse event.
  late int uid;

  /// Creates a new instance of MouseInputData.
  MouseInputData({this.target, required this.dispatcher, required this.type});

  /// Whether the primary mouse button is pressed.
  bool get isPrimaryDown => buttonsFlags! & kPrimaryButton == kPrimaryButton;

  /// Whether the secondary mouse button is pressed.
  bool get isSecondaryDown =>
      buttonsFlags! & kSecondaryButton == kSecondaryButton;

  /// Whether the tertiary mouse button is pressed.
  bool get isTertiaryDown => buttonsFlags! & 0x04 == 0x04;

  /// The delta of the mouse movement in the display object's coordinate system.
  GPoint get localDelta {
    final d = rawEvent?.rawEvent.localDelta;
    if (d == null) {
      return _localDelta.setEmpty();
    }
    return _localDelta.setTo(d.dx, d.dy);
  }

  /// The x-coordinate of the mouse in the display object's coordinate system.
  double get localX => localPosition.x;

  /// The y-coordinate of the mouse in the display object's coordinate system.
  double get localY => localPosition.y;

  /// The position of the mouse in the stage's coordinate system.
  GPoint get stagePosition => _stagePosition;

  /// The x-coordinate of the mouse in the stage's coordinate system.
  double get stageX => _stagePosition.x;

  /// The y-coordinate of the mouse in the stage's coordinate system.
  double get stageY => _stagePosition.y;

  /// The x-coordinate of the mouse in the window's coordinate system.
  double get windowX => rawEvent?.rawEvent.original?.position.dx ?? 0;

  /// The y-coordinate of the mouse in the window's coordinate system.
  double get windowY => rawEvent?.rawEvent.original?.position.dy ?? 0;

  /// Clones a new instance of MouseInputData with the provided [target],
  /// [dispatcher] and [type], and copies the properties of the original
  /// instance into the new one, including [uid], [buttonDown], [rawEvent],
  /// [captured], [buttonsFlags], [time], [_stagePosition], [scrollDelta],
  /// [localPosition], and [mouseOut]. Returns the new instance.
  ///
  /// Throws an error if [target] is null.
  MouseInputData clone(
    GDisplayObject target,
    GDisplayObject dispatcher,
    MouseInputType type,
  ) {
    var input = MouseInputData(
      target: target,
      dispatcher: dispatcher,
      type: type,
    );
    input.uid = uid;
    input.buttonDown = buttonDown;
    input.rawEvent = rawEvent;
    input.captured = captured;
    input.buttonsFlags = buttonsFlags;
    input.time = time;
    input._stagePosition.setTo(_stagePosition.x, _stagePosition.y);
    input.scrollDelta.setTo(scrollDelta.x, scrollDelta.y);
    input.localPosition.setTo(localPosition.x, localPosition.y);
    input.mouseOut = mouseOut;
    return input;
  }

  /// Returns a string representation of the [MouseInputData].
  @override
  String toString() {
    return (StringBuffer()
          ..write('MouseInputData {')
          ..write('\n  captured: $captured, ')
          ..write('\n  target: $target, ')
          ..write('\n  dispatcher: $dispatcher, ')
          ..write('\n  type: $type, ')
          ..write('\n  buttonDown: $buttonDown, ')
          ..write('\n  mouseOut: $mouseOut, ')
          ..write('\n  time: $time, ')
          ..write('\n  buttonsFlags: $buttonsFlags, ')
          ..write('\n  localPosition: $localPosition, ')
          ..write('\n  stagePosition: $_stagePosition, ')
          ..write('\n  scrollDelta: $scrollDelta')
          ..write('\n}'))
        .toString();
  }

  /// Converts a [PointerEventType] into the equivalent [MouseInputType] as
  /// follows:
  ///
  /// - [PointerEventType.down]: [MouseInputType.down]
  /// - [PointerEventType.up]: [MouseInputType.up]
  /// - [PointerEventType.hover]: [MouseInputType.move]
  /// - [PointerEventType.move]: [MouseInputType.move]
  /// - [PointerEventType.exit]: [MouseInputType.exit]
  /// - [PointerEventType.scroll]: [MouseInputType.wheel]
  /// - [PointerEventType.zoomPan]: [MouseInputType.zoomPan]
  ///
  /// If the input [nativeType] does not match any of the above, it returns
  /// [MouseInputType.unknown].
  static MouseInputType fromNativeType(PointerEventType? nativeType) {
    if (nativeType == PointerEventType.down) {
      return MouseInputType.down;
    } else if (nativeType == PointerEventType.up) {
      return MouseInputType.up;
    } else if (nativeType == PointerEventType.hover ||
        nativeType == PointerEventType.move) {
      return MouseInputType.move;
    } else if (nativeType == PointerEventType.exit) {
      return MouseInputType.exit;
    } else if (nativeType == PointerEventType.scroll) {
      return MouseInputType.wheel;
    } else if (nativeType == PointerEventType.zoomPan) {
      return MouseInputType.zoomPan;
    }
    return MouseInputType.unknown;
  }
}

/// An enumeration of mouse input types.
enum MouseInputType {
  over,
  out,
  move,
  down,
  exit,
  enter,
  up,
  click,
  still,
  wheel,
  zoomPan,

  /// check button directly with: isPrimaryDown, isSecondaryDown...
//  rightDown,
//  rightUp,
//  rightClick,
  unknown
}

/// A class representing the data associated with a pointer event.
class PointerEventData {
  /// Defines the delay for a double click event.
  /// 300 milliseconds by default.
  static int doubleClickTime = 300;

  /// The x-coordinate of the pointer on the stage.
  final double stageX;

  /// The y-coordinate of the pointer on the stage.
  final double stageY;

  /// The type of the pointer event.
  final PointerEventType type;

  /// The raw pointer event.
  final PointerEvent rawEvent;

  /// The local position of the pointer on the display object.
  late GPoint localPosition;

  /// The display object that is the target of the event.
  /// TODO: decide how to name mouse/pointer events.
  GDisplayObject? target;

  /// The display object that is the dispatcher of the event.
  GDisplayObject? dispatcher;

  /// A flag indicating whether this event has been captured or not.
  bool captured = false;

  /// A flag indicating whether the mouse has gone out of the [target] object or
  /// not.
  bool mouseOut = false;

  /// Creates a new instance of [PointerEventData].
  PointerEventData({required this.type, required this.rawEvent})
      : stageX = rawEvent.localPosition.dx,
        stageY = rawEvent.localPosition.dy {
    localPosition = GPoint(stageX, stageY);
  }

  /// The x-coordinate of the pointer in the local coordinate system.
  double get localX => localPosition.x;

  /// The y-coordinate of the pointer in the local coordinate system.
  double get localY => localPosition.y;

  /// The scroll delta of the pointer event, if applicable.
  Offset? get scrollDelta {
    if (rawEvent is PointerScrollEvent) {
      return (rawEvent as PointerScrollEvent).scrollDelta;
    } else if (rawEvent is PointerPanZoomUpdateEvent) {
      // TODO: temporal workaround for mouse wheel compatibility.
      // will be removed in next version and change "onScroll" for "onSignal"
      // to keep Flutter's compatibility.
      return (rawEvent as PointerPanZoomUpdateEvent).localPanDelta;
    }
    return null;
  }

//  Offset get position => rawEvent.localPosition;

  /// The position of the pointer on the stage.
  GPoint get stagePosition => GPoint.fromNative(rawEvent.localPosition);

  /// The time in milliseconds when the pointer event occurred.
  int get time => rawEvent.timeStamp.inMilliseconds;

  /// The position of the pointer on the window.
  GPoint get windowPosition => GPoint.fromNative(rawEvent.original!.position);

  /// The type of zoom and pan event, if applicable.
  PointerZoomPanType get zoomPanEventType {
    if (rawEvent is PointerPanZoomStartEvent) {
      return PointerZoomPanType.start;
    } else if (rawEvent is PointerPanZoomUpdateEvent) {
      return PointerZoomPanType.update;
    } else if (rawEvent is PointerPanZoomEndEvent) {
      return PointerZoomPanType.end;
    }
    return PointerZoomPanType.none;
  }

  /// Clones this [PointerEventData] object with the specified [target],
  /// [dispatcher] and [type].
  PointerEventData clone(
    GDisplayObject target,
    GDisplayObject dispatcher,
    PointerEventType type,
  ) {
    var i = PointerEventData(type: type, rawEvent: rawEvent);
    i.target = target;
    i.dispatcher = dispatcher;
    i.captured = captured;
    return i;
  }

  /// Returns a string representation of this [PointerEventData] object.
  @override
  String toString() {
    return 'PointerEventData {'
        '\n  type: $type,'
        '\n  stageX: $stageX,'
        '\n  stageY: $stageY,'
        '\n  localX: $localX,'
        '\n  localY: $localY'
        '\n}';
  }
}

/// An enum representing different pointer event types that can be handled by
/// the [PointerEventData] class.
enum PointerEventType {
  /// Zoom and pan event type.
  zoomPan,

  /// Scroll event type.
  scroll,

  /// Cancel event type.
  cancel,

  /// Move event type.
  move,

  /// Up event type.
  up,

  /// Down event type.
  down,

  /// Enter event type.
  enter,

  /// Exit event type.
  exit,

  /// Hover event type.
  hover,
}

/// An enum representing different zoom and pan event types that can be handled
/// by the [PointerEventData] class.
enum PointerZoomPanType {
  /// The start of a zoom and pan event.
  start,

  /// The update of a zoom and pan event.
  update,

  /// The end of a zoom and pan event.
  end,

  /// No zoom and pan event.
  none,
}
