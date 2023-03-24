import 'package:flutter/widgets.dart';

import '../../graphx.dart';

/// A widget that builds a scene using the GraphX engine.
///
/// This widget is responsible for rendering the scene using the provided
/// [builder] function which must return a [SceneController].
///
/// [SceneBuilderWidget] also handles the input events from mouse and keyboard
/// and sends them to the [SceneController] as events.
///
/// If [autoSize] is `true`, the widget will wrap the [CustomPaint] in a
/// [SizedBox.expand], so it takes the available space in the parent.
/// Warning: this will not work inside flex widgets.
///
/// If the [child] parameter is non-null, it will be drawn above the scene.
class SceneBuilderWidget extends StatefulWidget {
  /// The child widget to draw above the scene.
  final Widget? child;

  /// The function that creates a [SceneController].
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

  /// Wraps the [CustomPaint] in an [SizedBox.expand()]
  /// so it takes the available space in the parent.
  /// Warning: will not work with inside Flex Widgets.
  final bool autoSize;

  /// Creates a new instance of [SceneBuilderWidget].
  const SceneBuilderWidget({
    super.key,
    required this.builder,
    this.child,
    this.painterIsComplex = true,
    this.mouseOpaque = true,
    this.pointerBehaviour = HitTestBehavior.translucent,
    this.autoSize = false,
  });

  @override
  SceneBuilderWidgetState createState() => SceneBuilderWidgetState();
}

/// The state object for [SceneBuilderWidget].
class SceneBuilderWidgetState extends State<SceneBuilderWidget> {
  /// The [SceneController] instance that manages the state of the
  /// SceneBuilderWidget. It is created in [initState] using the builder
  /// function passed to the constructor, and is disposed in [dispose] when the
  /// widget is removed from the tree. It is also used to access the
  /// SceneController methods for building the painters, resolving window
  /// bounds, handling user input, and more.
  ///
  /// The starting point core of the GraphX engine.
  late SceneController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.builder();
    _controller.resolveWindowBounds = _getRenderObjectWindowBounds;
    _controller.$init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.size?.isEmpty == true) {
        trace("""Warning:
SceneBuilderWidget is being rendered without a layout, resulting in an
empty size. As a consequence, you will not be able to interact with touch or
mouse events and the stage dimensions will report 0. 

To resolve this issue, you can either wrap SceneBuilderWidget() in a SizedBox()
or any other widget that constrains the size, or you can set autoSize to true in
the constructor, which will use a SizedBox.expand() as the parent widget. If you
are using flex widgets like Column() or Row(), consider using Expanded() or
Flexible().
""");
      }
    });
  }

  GRect? _getRenderObjectWindowBounds() {
    if (!mounted) {
      return null;
    }
    return ContextUtils.getRenderObjectBounds(context);
  }

  @override
  void dispose() {
    _controller.dispose();
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
        opaque: widget.mouseOpaque,
        child: Listener(
          behavior: widget.pointerBehaviour,
          onPointerDown: converter.pointerDown,
          onPointerUp: converter.pointerUp,
          onPointerCancel: converter.pointerCancel,
          onPointerMove: converter.pointerMove,
          onPointerSignal: converter.pointerSignal,
          onPointerPanZoomStart: converter.pointerPanZoomStart,
          onPointerPanZoomUpdate: converter.pointerPanZoomUpdate,
          onPointerPanZoomEnd: converter.pointerPanZoomEnd,
          child: child,
        ),
      );
    }
    if (_controller.config.useKeyboard) {
      child = Focus(
        onKeyEvent: (node, event) => KeyEventResult.handled,
        // autofocus: true,
        // descendantsAreFocusable: true,
        child: RawKeyboardListener(
          onKey: converter.handleKey,
          autofocus: true,
          includeSemantics: false,
          focusNode: converter.keyboard.focusNode,
          child: child,
        ),
      );
    }
    return child;
  }
}
