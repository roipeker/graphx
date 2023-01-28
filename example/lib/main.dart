// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'demos/demos.dart';
import 'utils/utils.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff241e30),
          fontFamily: 'Roboto',
          appBarTheme: AppBarTheme(color: Color(0xff241e30), elevation: 0)),
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  static final demos = <_Scene>[
    _SampleScene(
      title: "Simple Shapes",
      build: () => const SimpleShapesMain(),
    ),
    _SampleScene(
      title: "Simple Tween",
      build: () => SimpleTweenMain(),
    ),
    _SampleScene(
      title: "Svg Icons",
      build: () => const DemoSvgIconsMain(),
    ),
    if (isWebDesktop)
      _SampleScene(
        title: "Simple Interactions",
        build: () => const SimpleInteractionsMain(),
      ),
    if (isSkia)
      _SampleScene(
        title: "Graphics Clipper",
        build: () => const GraphicsClipperDemo(),
      ),
    if (isSkia)
      _SampleScene(
        title: "Facebook Reactions",
        build: () => FacebookReactionsMain(),
      ),
    if (isSkia)
      _SampleScene(
        title: "Dripping IV",
        build: () => const DrippingIVMain(),
      ),
    _SampleScene(
      title: "Chart Mountain",
      build: () => const ChartMountainMain(),
    ),
    _SampleScene(
      title: "Glowing Circle",
      build: () => const GlowingCircleMain(),
    ),
    if (isSkia)
      _SampleScene(
        title: "Sorting Button",
        build: () => const SortingButtonMain(),
      ),
    _SampleScene(
      title: "Bookmark Button",
      build: () => const BookmarkButtonMain(),
    ),
    _SampleScene(
      title: "Submit Button",
      build: () => const SubmitButtonMain(),
    ),
    _SampleScene(
      title: "Card Rotation 3d",
      build: () => const CardRotation3dMain(),
    ),
    _SampleScene(
      title: "Raster Draw",
      build: () => const RasterDrawMain(),
    ),
    _SampleScene(
      title: "Dialer",
      build: () => const DialerMain(),
    ),
    _SampleScene(
      title: "Gauge Meter",
      build: () => const GaugeMeterMain(),
    ),
    _SampleScene(
      title: "Spiral Loader",
      build: () => const SpiralLoaderMain(),
    ),
    _SampleScene(
      title: "Universo Flutter Intro",
      build: () => const UniversoFlutterIntroMain(),
    ),
    if (isSkia)
      _SampleScene(
        title: "Colorful Loader",
        build: () => const ColorfulLoaderMain(),
      ),
    _SampleScene(
      title: "Jelly Thing",
      build: () => const JellyThingMain(),
    ),
    _SampleScene(
      title: "Ball vs Line",
      build: () => const BallVsLineMain(),
    ),
    _SampleScene(
      title: "DNA 3d",
      build: () => const Dna3dMain(),
    ),
    _SampleScene(
      title: "Splash Intro",
      build: () => const SplashIntroMain(),
    ),
    if (isSkia)
      _SampleScene(
        title: "Lined Button",
        build: () => const LinedButtonMain(),
      ),
    _SampleScene(
      title: "Color Picker",
      build: () => const ColorPickerMain(),
    ),
    if (isSkia && isWebDesktop)
      _SampleScene(
        title: "Altitude Indicator",
        build: () => const AltitudeIndicatorMain(),
      ),
    if (isWebDesktop)
      _SampleScene(
        title: "Breakout",
        build: () => const BreakoutMain(),
      ),
    _SampleScene(
      title: "Xmas",
      build: () => const XmasMain(),
    ),
    _SampleScene(
      title: "Simple Radial Menu",
      build: () => const SimpleRadialMenuMain(),
    ),
    _SampleScene(
      title: "Murat Coffee",
      build: () => const MuratCoffeeMain(),
    ),
    _SampleScene(
      title: "Pie Chart",
      build: () => const PieChartMain(),
    ),
    _SampleScene(
      title: "Bezier Chart",
      build: () => const ChartBezierMain(),
    ),
    if (isSkia)
      _SampleScene(
        title: "Run Hero Canvas",
        build: () => const RunHeroCanvasMain(),
      ),
    _SampleScene(
      title: "Elastic Band",
      build: () => const ElasticBandMain(),
    ),
    _SampleScene(
      title: "Flower Gradient",
      build: () => const FlowerGradientMain(),
    ),
    _SampleScene(
      title: "Nokia Snake",
      build: () => const NokiaSnakeMain(),
    ),
    _SampleScene(
      title: "Heart Reaction",
      build: () => HeartReactionMain(),
    ),
    _SampleScene(
      title: "Simple Toast",
      build: () => const SimpleToastMain(),
    ),
    if (isSkia)
      _SampleScene(
        title: "Rating Stars",
        build: () => const RatingStarsMain(),
      ),
    _SampleScene(
      title: "Pizza Box",
      build: () => const PizzaBoxMain(),
    ),
    _SampleScene(
      title: "Drawing Pad Bezier",
      build: () => const DrawingPadBezierMain(),
    ),
    _SampleScene(
      title: "Isma Chart",
      build: () => const IsmaChartMain(),
    ),
    _SampleScene(
      title: "TriGrid",
      build: () => const TriGridMain(),
    ),
    _SampleScene(
      title: "Nico Loading",
      build: () => const NicoLoadingIndicatorMain(),
    ),
    _SampleScene(
      title: "Feeling Switch",
      build: () => const FeelingSwitchMain(),
    ),
    _SampleScene(
      title: "Mouse Repulsion",
      build: () => const MouseRepulsionMain(),
    ),
    _SampleScene(
      title: "Globe 3d",
      build: () => const Globe3dMain(),
    ),
    _SampleScene(
      title: "Lungs Animation",
      build: () => const LungsAnimationMain(),
    ),
    _SampleScene(
      title: "Expander Fab",
      build: () => const ExpanderFabMenu(),
    ),
    if (isWebDesktop)
      _SampleScene(
        title: "Page Indicator (desktop)",
        build: () => const PageIndicatorMain(),
      ),
    _ExternalScene(
      title: 'Fly Dash 🡥',
      url: Uri.parse('https://graphx-dash-game.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-dash-game.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Cells (1st demo)',
      url: Uri.parse('https://roi-graphx-cells.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-cells.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Snake',
      url: Uri.parse('https://graphx-snake-game.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-snake-game.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Draw Pad',
      url: Uri.parse('https://graphx-drawpad2.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-drawpad2.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Node Garden',
      url: Uri.parse('https://graphx-node-garden.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-node-garden.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Puzzle',
      url: Uri.parse('https://roi-puzzle-v2.surge.sh'),
      thumbnail: 'assets/thumbs/roi-puzzle-v2.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Widget Mix',
      url: Uri.parse('https://roi-graphx-widgetmix.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-widgetmix.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Space Shooter',
      url: Uri.parse('https://roi-graphx-spaceshooter.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-spaceshooter.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Split RGB',
      url: Uri.parse('https://roi-graphx-rgbsplit.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-rgbsplit.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Input Text Particles',
      url: Uri.parse('https://roi-graphx-particles-input.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-particles-input.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Fish Eye',
      url: Uri.parse('https://roi-graphx-fisheyeparticles.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-fisheyeparticles.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Fish Eye Text',
      url: Uri.parse('https://roi-graphx-fisheyetext.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-fisheyetext.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Particle Emitter',
      url: Uri.parse('https://roi-graphx-particles2.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-particles2.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Shape Maker Clone',
      url: Uri.parse('https://roi-graphx-shapemaker.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-shapemaker.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Mouse Follow',
      url: Uri.parse('https://roi-graphx-dotchain.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-dotchain.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Basic Hit Test',
      url: Uri.parse('http://roi-graphx-hittest.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-hittest.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Spritesheet Sample',
      url: Uri.parse('https://roi-graphx-spritesheet.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-spritesheet.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Text Pivot',
      url: Uri.parse('https://roi-graphx-textpivot.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-textpivot.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Solo Ping-Pong',
      url: Uri.parse('https://roi-graphx-pingpong.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-pingpong.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Mask Demo',
      url: Uri.parse('https://roi-graphx-sample-masking.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-sample-masking.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Image Stack Web Page',
      url: Uri.parse('https://roi-graphx-web-image-stack-grid.surge.sh'),
      thumbnail: 'assets/thumbs/roi-graphx-web-image-stack-grid.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Fly Hero',
      url: Uri.parse('https://graphx-hh.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-hh.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Displacement Bitmapdata (Wrong Colors)',
      url: Uri.parse('https://graphx-weird-displacement.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-weird-displacement.surge.sh.png',
    ),
    _ExternalScene(
      title: 'LOST Clock',
      url: Uri.parse('https://graphx-lost-clock-skia.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-lost-clock-skia.surge.sh.png',
    ),
    _ExternalScene(
      title: 'HUGE INC Website Clone',
      url: Uri.parse('https://graphx-hugeinc.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-hugeinc.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Open Maps',
      url: Uri.parse('https://graphx-openmaps2.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-openmaps2.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Raster In Bitmap',
      url: Uri.parse('https://graphx-raster1.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-raster1.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Meteor Shower',
      url: Uri.parse('https://graphx-meteor-shower.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-meteor-shower.surge.sh.png',
    ),
    _ExternalScene(
      title: '(Bad) Candle Chart Concept',
      url: Uri.parse('https://graphx-candlechart-skia.surge.sh'),
      thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Candle Chart Animated',
      url: Uri.parse('https://roi-taso-chart19.surge.sh'),
      thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Waltz Circles',
      url: Uri.parse('https://roi-fp5-waltz-circ.surge.sh'),
      thumbnail: 'assets/thumbs/roi-fp5-waltz-circ.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Waltz Circles (BMP)',
      url: Uri.parse('https://roi-fp5-waltz-circ-bmp.surge.sh'),
      thumbnail: 'assets/thumbs/roi-fp5-waltz-circ-bmp.surge.sh.png',
    ),
    _ExternalScene(
      title: 'CrypterIcon Logo',
      url: Uri.parse('https://cryptericon-logo-dot3.surge.sh'),
      thumbnail: 'assets/thumbs/cryptericon-logo-dot3.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Runner Mark Test',
      url: Uri.parse('https://graphx-runnermark.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-runnermark.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Minimalcomps (Flash)',
      url: Uri.parse('https://graphx-minimalcomps.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-minimalcomps.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Pan Zoom',
      url: Uri.parse('https://graphx-gesture-sample.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-gesture-sample.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Simple Transform',
      url: Uri.parse('https://graphx-gesture-simple.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-gesture-simple.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Dots Sphere Rotation',
      url: Uri.parse('https://graphx-sphere-dots-rotation.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-sphere-dots-rotation.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Falling Boxes',
      url: Uri.parse('https://graphx-burn-boxes.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-burn-boxes.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Sunburst Chart',
      url: Uri.parse('https://graphx-sunburst-chart.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-sunburst-chart.surge.sh.png',
    ),
    _ExternalScene(
      title: '3d Stars',
      url: Uri.parse('https://roi-swr3d-stars.surge.sh'),
      thumbnail: 'assets/thumbs/roi-swr3d-stars.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Manu Painter Particles',
      url: Uri.parse('https://roi-particles-manu-painter2.surge.sh'),
      thumbnail: 'assets/thumbs/roi-particles-manu-painter2.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Perlin Noise Terrain',
      url: Uri.parse('https://graphx-perlin-map.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-perlin-map.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Fly Dash 1',
      url: Uri.parse('https://graphx-trees.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-trees.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Puzzle Interaction',
      url: Uri.parse('https://graphx-puzzle-ref.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-puzzle-ref.surge.sh.png',
    ),
    _ExternalScene(
      title: 'Simple Particles',
      url: Uri.parse('https://graphx-simple-particles.surge.sh'),
      thumbnail: 'assets/thumbs/graphx-simple-particles.surge.sh.png',
    ),
  ];

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: SvgPicture.asset(
        'assets/graphx_logo.svg',
        color: Colors.white,
        height: 20,
      ))),
      backgroundColor: Color(0xff241e30),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 10,
        ),
        padding: EdgeInsets.all(20),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withAlpha(60),
            ),
            child: ListTile(
              leading: demo.thumbnail?.isNotEmpty == true
                  ? Image.asset(
                      demo.thumbnail!,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(
                demo.title.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              subtitle:
                  demo is _ExternalScene ? Text(demo.url.toString()) : null,
              onTap: () {
                if (demo is _ExternalScene) {
                  launchUrl(demo.url);
                  return;
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Demo(text: demo.title, child: demo.build() as Widget);
                }));
              },
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

abstract class _Scene<T> {
  final String title;
  final T Function() build;
  final String? thumbnail;

  const _Scene({
    required this.title,
    required this.build,
    this.thumbnail,
  });
}

class _SampleScene extends _Scene<Widget> {
  const _SampleScene({
    required super.title,
    required super.build,
    super.thumbnail,
  });
}

class _ExternalScene extends _Scene<Uri> {
  final Uri url;

  _ExternalScene({
    required super.title,
    required this.url,
    super.thumbnail,
  }) : super(build: () => url);
}
