import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:graphx/graphx/input_converter.dart';
import 'package:graphx/graphx/scene_controller.dart';

class SceneBuilderWidget extends StatefulWidget {
  final Widget child;
  final SceneController Function() builder;
  final bool usePointer;
  final bool useKeyboard;
  final bool isPersistent;

  const SceneBuilderWidget({
    Key key,
    this.builder,
    this.child,
    this.usePointer,
    this.useKeyboard,
    this.isPersistent = false,
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
        child: Listener(
          child: child,
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
