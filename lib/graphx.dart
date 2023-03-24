/// GraphX is a powerful 2D graphics library for creating custom drawings,
/// animations, charts, and visualizations in Flutter.
///
/// It provides a flexible and customizable framework for building a wide range
/// of visualizations with ease. Whether you want to create a simple line
/// drawing or a complex game, GraphX has got you covered.
///
/// GraphX is inspired by the Flash API and offers a similar development
/// experience for Flutter developers. It uses the Canvas API exposed by the
/// SKIA engine through CustomPainter and provides a framework for running
/// isolated from the Widget's world.
///
/// To get started, simply create a [SceneBuilderWidget] widget, assign your
/// Scene and add your custom drawings or animations to it.
///
/// You can also use **GraphX** to create charts, graphs, and other visualizations
/// with ease.
///
/// You can also find sample code and prototypes on the [GraphX
/// repo](https://github.com/roipeker/graphx/tree/master/example). Also check
/// out the [GraphX gallery](https://graphx-gallery.surge.sh/) for more examples.
///
///
/// To use **GraphX** in your Flutter app, simply add it to your dependencies in
/// `pubspec.yaml`. For example:
///
/// ```yaml
/// dependencies:
///   graphx: any
/// ```
///
/// Then, import the library and create a new [SceneBuilderWidget] widget:
///
/// ```dart
/// import 'package:graphx/graphx.dart';
///
/// class MyScene extends GSprite {
///   @override
///   void addedToStage() {
///     var circle = addChild(GShape());
///     circle.graphics.beginFill(Colors.purple).drawCircle(0, 0, 20).endFill();
///     circle.x = 20;
///     circle.y = 20;
///     // Add your custom drawings or animations here.
///   }
/// }
///
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Scaffold(
///         body: SizedBox.expand(
///           child: SceneBuilderWidget(
///             builder: () => SceneController(front: MyScene()),
///           ),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// This will create a new Flutter app with a GraphX scene that you can
/// customize as needed. It will create a Shape, draw a purple circle and
/// position it at coordinates (20, 20).
///
library graphx;

export 'package:flutter/foundation.dart';
export 'package:flutter/services.dart';

export 'src/core/core.dart';
export 'src/debug/debug.dart';
export 'src/extensions/extensions.dart';
export 'src/display/display.dart';
export 'src/events/events.dart';
export 'src/geom/geom.dart';
export 'src/input/input.dart';
export 'src/io/io.dart';
export 'src/log/trace.dart';
export 'src/math.dart';
export 'src/render/filters/filters.dart';
export 'src/render/render.dart';
export 'src/textures/textures.dart';
export 'src/ticker/ticker.dart';
export 'src/tween/gtween.dart';
export 'src/utils/utils.dart';
export 'src/widgets/widgets.dart';
