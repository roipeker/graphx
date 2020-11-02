import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../graphx.dart';
import '../core/core.dart';

class SceneBuilderWidget extends StatefulWidget {
  final Widget child;
  final SceneController Function() builder;
  final bool usePointer;
  final bool useKeyboard;
  final bool useTicker;

  /// Experimental flag.
  /// avoids the disposal of SceneController when this widget is unmounted.
  final bool isPersistentScene;

  /// Rendering caching flag.
  /// Set to true if using [GxTicker] or pretend to re-render the Scene
  /// on demand based on keyboard or pointer signals.
  /// See [CustomPaint.isComplex]
  final bool painterWillChange;

  /// Rendering caching flag.
  /// See [CustomPaint.willChange]
  final bool painterIsComplex;

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
    this.useTicker,
    this.painterWillChange,
    this.painterIsComplex,
    this.isPersistentScene = false,
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
    _controller.config.isPersistent = widget.isPersistentScene;
    _controller.config.painterIsComplex ??= widget.painterIsComplex;
    _controller.config.painterWillChange ??= widget.painterWillChange;
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
      isComplex: _controller.config.painterIsComplex ?? false,
      willChange: _controller.config.painterMightChange(),
      child: widget.child ?? Container(),
    );

    var converter = _controller.$inputConverter;
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
