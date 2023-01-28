// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'demos/demos.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final demos = {
    "Simple Shapes": const SimpleShapesMain(),
    "Simple Tween": SimpleTweenMain(),
    "Svg Icons": const DemoSvgIconsMain(),
    "Simple Interactions": const SimpleInteractionsMain(),
    "Graphics Clipper": const GraphicsClipperDemo(),
    "Facebook Reactions": FacebookReactionsMain(),
    "Dripping IV": const DrippingIVMain(),
    "Chart Mountain": const ChartMountainMain(),
    "Glowing Circle": const GlowingCircleMain(),
    "Sorting Button": const SortingButtonMain(),
    "Bookmark Button": const BookmarkButtonMain(),
    "Submit Button": const SubmitButtonMain(),
    "Card Rotation 3d": const CardRotation3dMain(),
    "Raster Draw": const RasterDrawMain(),
    "Dialer": const DialerMain(),
    "Gauge Meter": const GaugeMeterMain(),
    "Spiral Loader": const SpiralLoaderMain(),
    "Universo Flutter Intro": const UniversoFlutterIntroMain(),
    "Colorful Loader": const ColorfulLoaderMain(),
    "Jelly Thing": const JellyThingMain(),
    "Ball vs Line": const BallVsLineMain(),
    "DNA 3d": const Dna3dMain(),
    "Splash Intro": const SplashIntroMain(),
    "Lined Button": const LinedButtonMain(),
    "Color Picker": const ColorPickerMain(),
    "Altitude Indicator": const AltitudeIndicatorMain(),
    "Breakout": const BreakoutMain(),
    "Xmas": const XmasMain(),
    "Simple Radial Menu": const SimpleRadialMenuMain(),
    "Murat Coffee": const MuratCoffeeMain(),
    "Pie Chart": const PieChartMain(),
    "Bezier Chart": const ChartBezierMain(),
    "Run Hero Canvas": const RunHeroCanvasMain(),
    "Elastic Band": const ElasticBandMain(),
    "Flower Gradient": const FlowerGradientMain(),
    "Nokia Snake": const NokiaSnakeMain(),
    "Heart Reaction": HeartReactionMain(),
    "Simple Toast": const SimpleToastMain(),
    "Rating Stars": const RatingStarsMain(),
    "Pizza Box": const PizzaBoxMain(),
    "Drawing Pad Bezier": const DrawingPadBezierMain(),
    "Isma Chart": const IsmaChartMain(),
    "TriGrid": const TriGridMain(),
    "Nico Loading": const NicoLoadingIndicatorMain(),
    "Feeling Switch": const FeelingSwitchMain(),
    "Mouse Repulsion": const MouseRepulsionMain(),
    "Globe 3d": const Globe3dMain(),
    "Lungs Animation": const LungsAnimationMain(),
    "Expander Fab": const ExpanderFabMenu(),
    "Page Indicator": const PageIndicatorMain()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GraphX Demos')),
      body: ListView.builder(
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos.entries.elementAt(index);
          final title = demo.key.replaceAllMapped(
            RegExp(r'([A-Z])'),
            (match) => ' ${match.group(0)}',
          );
          final widget = demo.value;
          return ListTile(
            title: Text(title),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Demo(text: title, child: widget),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // return child;
    return Scaffold(
      appBar: AppBar(title: Text(text)),
      body: Center(
        child: Navigator(
          onGenerateRoute: (settings) =>
              MaterialPageRoute(builder: (context) => child),
        ),
      ),
    );
  }
}
