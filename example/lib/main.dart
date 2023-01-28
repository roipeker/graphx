// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

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
    if (SystemUtils.usingSkia) "Graphics Clipper": const GraphicsClipperDemo(),
    if (SystemUtils.usingSkia) "Facebook Reactions": FacebookReactionsMain(),
    if (SystemUtils.usingSkia) "Dripping IV": const DrippingIVMain(),
    "Chart Mountain": const ChartMountainMain(),
    "Glowing Circle": const GlowingCircleMain(),
    if (SystemUtils.usingSkia) "Sorting Button": const SortingButtonMain(),
    "Bookmark Button": const BookmarkButtonMain(),
    "Submit Button": const SubmitButtonMain(),
    "Card Rotation 3d": const CardRotation3dMain(),
    "Raster Draw": const RasterDrawMain(),
    "Dialer": const DialerMain(),
    "Gauge Meter": const GaugeMeterMain(),
    "Spiral Loader": const SpiralLoaderMain(),
    "Universo Flutter Intro": const UniversoFlutterIntroMain(),
    if (SystemUtils.usingSkia) "Colorful Loader": const ColorfulLoaderMain(),
    "Jelly Thing": const JellyThingMain(),
    "Ball vs Line": const BallVsLineMain(),
    "DNA 3d": const Dna3dMain(),
    "Splash Intro": const SplashIntroMain(),
    if (SystemUtils.usingSkia) "Lined Button": const LinedButtonMain(),
    "Color Picker": const ColorPickerMain(),
    if (SystemUtils.usingSkia)
      "Altitude Indicator": const AltitudeIndicatorMain(),
    "Breakout": const BreakoutMain(),
    "Xmas": const XmasMain(),
    "Simple Radial Menu": const SimpleRadialMenuMain(),
    "Murat Coffee": const MuratCoffeeMain(),
    "Pie Chart": const PieChartMain(),
    "Bezier Chart": const ChartBezierMain(),
    if (SystemUtils.usingSkia) "Run Hero Canvas": const RunHeroCanvasMain(),
    "Elastic Band": const ElasticBandMain(),
    "Flower Gradient": const FlowerGradientMain(),
    "Nokia Snake": const NokiaSnakeMain(),
    "Heart Reaction": HeartReactionMain(),
    "Simple Toast": const SimpleToastMain(),
    if (SystemUtils.usingSkia) "Rating Stars": const RatingStarsMain(),
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
    "Page Indicator (desktop)": const PageIndicatorMain(),

    /// TODO: add web links.
    // fly dash: https://graphx-dash-game.surge.sh/#/
    // cells (1st demo): https://roi-graphx-cells.surge.sh/#/
    // snake: https://graphx-snake-game.surge.sh/#/
    // draw pad: https://graphx-drawpad2.surge.sh/
    // node garden: https://graphx-node-garden.surge.sh/#/
    // puzzle: https://roi-puzzle-v2.surge.sh/#/
    // widget mix: https://roi-graphx-widgetmix.surge.sh/#/
    // space shooter: https://roi-graphx-spaceshooter.surge.sh/#/
    // split rgb: https://roi-graphx-rgbsplit.surge.sh/
    // input text particles: https://roi-graphx-particles-input.surge.sh/#/
    // fish eye: https://roi-graphx-fisheyeparticles.surge.sh/#/
    // fish eye text: https://roi-graphx-fisheyetext.surge.sh/#/
    // particle emitter: https://roi-graphx-particles2.surge.sh/
    // shape maker clone: https://roi-graphx-shapemaker.surge.sh/#/
    // mouse follow: https://roi-graphx-dotchain.surge.sh/#/
    // basic hit test: http://roi-graphx-hittest.surge.sh/#/
    // spritesheet sample: https://roi-graphx-spritesheet.surge.sh/#/
    // text pivot: https://roi-graphx-textpivot.surge.sh/
    // solo ping-pong: https://roi-graphx-pingpong.surge.sh/#/
    // mask demo: https://roi-graphx-sample-masking.surge.sh/#/
    // image stack web page: https://roi-graphx-web-image-stack-grid.surge.sh/#/
    // fly hero: https://graphx-hh.surge.sh/#/
    // displacement bitmapdata (wrong colors): https://graphx-weird-displacement.surge.sh/#/
    // LOST clock: https://graphx-lost-clock-skia.surge.sh/#/
    // HUGE INC website clone: https://graphx-hugeinc.surge.sh/#/
    // OPEN maps: https://graphx-openmaps2.surge.sh/#/
    // Raster in bitmap: https://graphx-raster1.surge.sh/#/
    // Meteor shower: https://graphx-meteor-shower.surge.sh/#/
    // (bad) candle chart concept: https://graphx-candlechart-skia.surge.sh/#/
    // candle chart animated: https://roi-taso-chart19.surge.sh/#/
    // waltz circles: https://roi-fp5-waltz-circ.surge.sh/
    // waltz circles (bmp): https://roi-fp5-waltz-circ-bmp.surge.sh/
    // CrypterIcon logo: https://cryptericon-logo-dot3.surge.sh/#/
    // Runner mark test: https://graphx-runnermark.surge.sh/
    // Minimalcomps (Flash): https://graphx-minimalcomps.surge.sh/#/
    // Pan zoom: https://graphx-gesture-sample.surge.sh/#/
    // Simple transform: https://graphx-gesture-simple.surge.sh/#/
    // Dots sphere rotation: https://graphx-sphere-dots-rotation.surge.sh/#/
    // falling boxes: https://graphx-burn-boxes.surge.sh/#/
    // Sunburst chart: https://graphx-sunburst-chart.surge.sh/#/
    // 3d stars: https://roi-swr3d-stars.surge.sh/#/
    // manu painter particles: https://roi-particles-manu-painter2.surge.sh/#/
    // perlin noise terrain: https://graphx-perlin-map.surge.sh/#/
    // fly dash 1: https://graphx-trees.surge.sh/#/
    // puzzle interaction: https://graphx-puzzle-ref.surge.sh/#/
    // simple particles: https://graphx-simple-particles.surge.sh/#/


























  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GraphX Gallery'),
      ),
      body: ListView.builder(
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos.entries.elementAt(index);
          final title = demo.key;
          //     .replaceAllMapped(
          //   RegExp(r'([A-Z])'),
          //   (match) => ' ${match.group(0)}',
          // );

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
