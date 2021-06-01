import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../graphx.dart';
import '../core/core.dart';

class SceneBuilderWidget extends StatefulWidget {
  final Widget child;

  final SceneController Function() builder;

  /// Rendering caching flag.
  /// See [CustomPaint.willChange]
  final bool painterIsComplex;

  /// Absorbs mouse events blocking the child.
  /// See [MouseRegion.opaque]
  final bool mouseOpaque;

  /// See [Listener.behavior]
  /// defaults to capture translucent("empty") areas.
  final HitTestBehavior pointerBehaviour;

  /// Wraps the [CustomPaint] in an expanded SizedBox
  /// so it takes the available space in the parent.
  final bool autoSize;

  const SceneBuilderWidget({
    Key key,
    this.builder,
    this.child,
    this.painterIsComplex = true,
    this.mouseOpaque = true,
    this.autoSize = true,
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
    _controller.resolveWindowBounds = _getRenderObjectWindowBounds;
    _controller.$init();
  }

  GRect _getRenderObjectWindowBounds() {
    if (!mounted) return null;
    return ContextUtils.getRenderObjectBounds(context);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _controller.reassembleWidget();
  }

  // @override
  // void didChangeDependencies() {}

  // @override
  // void didUpdateWidget(SceneBuilderWidget oldWidget) {}

  @override
  Widget build(BuildContext context) {
    Widget child = CustomPaint(
      painter: _controller.buildBackPainter(),
      foregroundPainter: _controller.buildFrontPainter(),
      isComplex: widget.painterIsComplex,
      willChange: _controller.config.painterMightChange(),
      child: widget.child ?? const SizedBox(),
    );
    if (widget.autoSize) {
      child = SizedBox.expand(
        child: child,
      );
    }
    var converter = _controller.$inputConverter;
    if (_controller.config.usePointer) {
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
    if (_controller.config.useKeyboard) {
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
