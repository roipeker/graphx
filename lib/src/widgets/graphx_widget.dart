import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../graphx/core/scene_controller.dart';
import '../../graphx/input/input_converter.dart';

class SceneBuilderWidget extends StatefulWidget {
  final Widget child;
  final SceneController Function() builder;
  final bool usePointer;
  final bool useKeyboard;
  final bool isPersistent;

  /// Absorbs mouse events blocking the child.
  /// See [MouseRegion.opaque]
  final bool mouseOpaque;

  /// See [Listener.behavior]
  /// defaults to capture translucent("empty") areas.
  final HitTestBehavior pointerBehaviour;

  const SceneBuilderWidget({
    Key key,
    this.builder,
    this.child,
    this.usePointer,
    this.useKeyboard,
    this.isPersistent = false,
    this.mouseOpaque = true,
    this.pointerBehaviour = HitTestBehavior.translucent,
  }) : super(key: key);

  @override
  _SceneBuilderWidgetState createState() => _SceneBuilderWidgetState();
}

class _SceneBuilderWidgetState extends State<SceneBuilderWidget> {
  SceneController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.builder();
    _controller.config.isPersistent = widget.isPersistent;
    _controller.$init();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = CustomPaint(
      painter: _controller.buildBackPainter(),
      foregroundPainter: _controller.buildFrontPainter(),
      isComplex: _controller.config.painterIsComplex,
      willChange: _controller.config.painterWillChange,
      child: widget.child ?? Container(),
    );

    InputConverter converter = _controller.$inputConverter;
    if (_controller.config.usePointer ?? widget.usePointer) {
      child = MouseRegion(
        onEnter: converter.pointerEnter,
        onExit: converter.pointerExit,
        onHover: converter.pointerHover,
        cursor: MouseCursor.defer,
        opaque: widget.mouseOpaque,
        child: Listener(
          child: child,
          behavior: widget.pointerBehaviour,
          onPointerDown: converter.pointerDown,
          onPointerUp: converter.pointerUp,
          onPointerCancel: converter.pointerCancel,
          onPointerMove: converter.pointerMove,
          onPointerSignal: converter.pointerSignal,
        ),
      );
    }
    if (_controller.config.useKeyboard ?? widget.useKeyboard) {
      child = RawKeyboardListener(
        onKey: converter.handleKey,
        autofocus: true,
        includeSemantics: false,
        focusNode: converter.keyboard.focusNode,
        child: child,
      );
    }
    return child;
  }
}
