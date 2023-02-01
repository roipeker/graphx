// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'demos/demos.dart';
import 'demos/zoom_gesture/zoom_gesture.dart';
import 'demos/zoom_pivot/zoom_pivot.dart';
import 'utils/utils.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff241e30),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(color: Color(0xff241e30), elevation: 0),
      ),
      home: const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  static get demos => <_Scene>[
        _SampleScene(
          title: "Simple Shapes",
          build: () => const SimpleShapesMain(),
          thumbnail: 'assets/thumbs/example_simple_shapes.png',
        ),
        _SampleScene(
          title: "Simple Tween",
          build: () => SimpleTweenMain(),
          thumbnail: 'assets/thumbs/example_tween.png',
        ),
        _SampleScene(
          title: "Svg Icons",
          build: () => const DemoSvgIconsMain(),
          thumbnail: 'assets/thumbs/example_svg.png',
        ),
        if (isDesktop)
          _SampleScene(
            title: "Simple Interactions",
            build: () => const SimpleInteractionsMain(),
            thumbnail: 'assets/thumbs/example_simple_interactions.png',
          ),
        if (isSkia)
          _SampleScene(
            title: "Graphics Clipper",
            build: () => const GraphicsClipperDemo(),
            thumbnail: 'assets/thumbs/example_clipper.png',
          ),
        if (isSkia)
          _SampleScene(
            title: "Facebook Reactions",
            build: () => FacebookReactionsMain(),
            thumbnail: 'assets/thumbs/example_fb.png',
          ),
        if (isSkia)
          _SampleScene(
            title: "Dripping IV",
            build: () => const DrippingIVMain(),
            thumbnail: 'assets/thumbs/example_dripping.png',
          ),
        _SampleScene(
          title: "Chart Mountain",
          build: () => const ChartMountainMain(),
          thumbnail: 'assets/thumbs/example_chart.png',
        ),
        _SampleScene(
          title: "Glowing Circle",
          build: () => const GlowingCircleMain(),
          thumbnail: 'assets/thumbs/example_glowing.png',
        ),
        if (isSkia)
          _SampleScene(
            title: "Sorting Button",
            build: () => const SortingButtonMain(),
            thumbnail: 'assets/thumbs/example_sorting_list.png',
          ),
        _SampleScene(
          title: "Bookmark Button",
          build: () => const BookmarkButtonMain(),
          thumbnail: 'assets/thumbs/example_bookmark_button.png',
        ),
        _SampleScene(
          title: "Submit Button",
          build: () => const SubmitButtonMain(),
          thumbnail: 'assets/thumbs/example_submit.png',
        ),
        _SampleScene(
          title: "Card Rotation 3d",
          build: () => const CardRotation3dMain(),
          thumbnail: 'assets/thumbs/example_3drot.png',
        ),
        _SampleScene(
          title: "Raster Draw",
          build: () => const RasterDrawMain(),
          thumbnail: 'assets/thumbs/example_raster_draw.png',
        ),
        _SampleScene(
          title: "Dialer",
          build: () => const DialerMain(),
          thumbnail: 'assets/thumbs/example_dialer.png',
        ),
        _SampleScene(
          title: "Gauge Meter",
          build: () => const GaugeMeterMain(),
          thumbnail: 'assets/thumbs/example_gauge.png',
        ),
        _SampleScene(
          title: "Spiral Loader",
          build: () => const SpiralLoaderMain(),
          thumbnail: 'assets/thumbs/example_spiral_loader.png',
        ),
        _SampleScene(
          title: "Universo Flutter Intro",
          build: () => const UniversoFlutterIntroMain(),
          thumbnail: 'assets/thumbs/example_universo_flutter.png',
        ),
        if (isSkia)
          _SampleScene(
            title: "Colorful Loader",
            build: () => const ColorfulLoaderMain(),
            thumbnail: 'assets/thumbs/example_colorful_loader.png',
          ),
        _SampleScene(
          title: "Jelly Thing",
          build: () => const JellyThingMain(),
          thumbnail: 'assets/thumbs/example_jelly.png',
        ),
        _SampleScene(
          title: "Ball vs Line",
          build: () => const BallVsLineMain(),
          thumbnail: 'assets/thumbs/example_ball_vs_line.png',
        ),
        _SampleScene(
          title: "DNA 3d",
          build: () => const Dna3dMain(),
          thumbnail: 'assets/thumbs/example_dna.png',
        ),
        _SampleScene(
          title: "Splash Intro",
          build: () => const SplashIntroMain(),
          thumbnail: 'assets/thumbs/example_splash_intro.png',
        ),
        if (isSkia)
          _SampleScene(
            title: "Lined Button",
            build: () => const LinedButtonMain(),
            thumbnail: 'assets/thumbs/example_lined_button.png',
          ),
        _SampleScene(
          title: "Color Picker",
          build: () => const ColorPickerMain(),
          thumbnail: 'assets/thumbs/example_color_picker.png',
        ),
        if (isSkia && isDesktop)
          _SampleScene(
            title: "Altitude Indicator",
            build: () => const AltitudeIndicatorMain(),
            thumbnail: 'assets/thumbs/example_altitud_indicator.png',
          ),
        if (isDesktop)
          _SampleScene(
            title: "Breakout",
            build: () => const BreakoutMain(),
            thumbnail: 'assets/thumbs/example_breakout.png',
          ),
        _SampleScene(
          title: "Xmas",
          build: () => const XmasMain(),
          thumbnail: 'assets/thumbs/example_xmas.png',
        ),
        _SampleScene(
          title: "Simple Radial Menu",
          build: () => const SimpleRadialMenuMain(),
          thumbnail: 'assets/thumbs/example_radial_menu.png',
        ),
        _SampleScene(
          title: "Murat Coffee",
          build: () => const MuratCoffeeMain(),
          thumbnail: 'assets/thumbs/example_murat_coffee.png',
        ),
        _SampleScene(
          title: "Pie Chart",
          build: () => const PieChartMain(),
          thumbnail: 'assets/thumbs/example_pie_chart.png',
        ),
        _SampleScene(
          title: "Bezier Chart",
          build: () => const ChartBezierMain(),
          thumbnail: 'assets/thumbs/example_bezier_chart.png',
        ),
        if (isSkia)
          _SampleScene(
            title: "Run Hero",
            build: () => const RunHeroCanvasMain(),
            thumbnail: 'assets/thumbs/example_run_hero.png',
          ),
        _SampleScene(
          title: "Elastic Band",
          build: () => const ElasticBandMain(),
          thumbnail: 'assets/thumbs/example_elastic_band.png',
        ),
        _SampleScene(
          title: "Flower Gradient",
          build: () => const FlowerGradientMain(),
          thumbnail: 'assets/thumbs/example_gradient_flower.png',
        ),
        _SampleScene(
          title: "Nokia Snake",
          build: () => const NokiaSnakeMain(),
          thumbnail: 'assets/thumbs/example_nokia_snake.png',
        ),
        _SampleScene(
          title: "Heart Reaction",
          build: () => HeartReactionMain(),
          thumbnail: 'assets/thumbs/example_heart_reaction.png',
        ),
        _SampleScene(
          title: "Simple Toast",
          build: () => const SimpleToastMain(),
          thumbnail: 'assets/thumbs/example_toast.png',
        ),
        if (isSkia)
          _SampleScene(
            title: "Rating Stars",
            build: () => const RatingStarsMain(),
            thumbnail: 'assets/thumbs/example_stars.png',
          ),
        _SampleScene(
          title: "Pizza Box",
          build: () => const PizzaBoxMain(),
          thumbnail: 'assets/thumbs/example_pizza.png',
        ),
        _SampleScene(
          title: "Drawing Pad Bezier",
          build: () => const DrawingPadBezierMain(),
          thumbnail: 'assets/thumbs/example_drawing_pad_bezier.png',
        ),
        _SampleScene(
          title: "Isma Chart",
          build: () => const IsmaChartMain(),
          thumbnail: 'assets/thumbs/example_isma_chart.png',
        ),
        _SampleScene(
          title: "TriGrid",
          build: () => const TriGridMain(),
          thumbnail: 'assets/thumbs/example_tri_grid.png',
        ),
        _SampleScene(
          title: "Nico Loading",
          build: () => const NicoLoadingIndicatorMain(),
          thumbnail: 'assets/thumbs/example_nico_loading.png',
        ),
        _SampleScene(
          title: "Feeling Switch",
          build: () => const FeelingSwitchMain(),
          thumbnail: 'assets/thumbs/example_feeling_switch.png',
        ),
        _SampleScene(
          title: "Mouse Repulsion",
          build: () => const MouseRepulsionMain(),
          thumbnail: 'assets/thumbs/example_lines_repulsion.png',
        ),
        _SampleScene(
          title: "Globe 3d",
          build: () => const Globe3dMain(),
          thumbnail: 'assets/thumbs/example_globe_3d.png',
        ),
        _SampleScene(
          title: "Lungs Animation",
          build: () => const LungsAnimationMain(),
          thumbnail: 'assets/thumbs/example_lungs.png',
        ),
        _SampleScene(
          title: "Expander Fab",
          build: () => const ExpanderFabMenu(),
          thumbnail: 'assets/thumbs/example_expander_fab.png',
        ),
        if (isDesktop)
          _SampleScene(
            title: "Page Indicator",
            build: () => const PageIndicatorMain(),
            thumbnail: 'assets/thumbs/example_page_indicator.png',
          ),
        _SampleScene(
          title: "Zoom Gesture",
          build: () => const ZoomGestureMain(),
          thumbnail: 'assets/thumbs/example_page_indicator.png',
        ),
        _SampleScene(
          title: "Zoom Pivot",
          build: () => const ZoomPivotMain(),
          thumbnail: 'assets/thumbs/example_page_indicator.png',
        ),
        _ExternalScene(
          title: 'Fly Dash !',
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
          title: 'SpriteSheet Sample',
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
          thumbnail:
              'assets/thumbs/roi-graphx-web-image-stack-grid.surge.sh.png',
        ),
        _ExternalScene(
          title: 'Fly Hero',
          url: Uri.parse('https://graphx-hh.surge.sh'),
          thumbnail: 'assets/thumbs/graphx-hh.surge.sh.png',
        ),
        _ExternalScene(
          title: 'Displacement BitmapData (Wrong Colors)',
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
          ),
        ),
      ),
      backgroundColor: const Color(0xff241e30),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        padding: const EdgeInsets.all(20),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos[index];

          return Material(
            color: Colors.white.withAlpha(60),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: demo.thumbnail?.isNotEmpty == true
                  ? Image.asset(
                      demo.thumbnail!,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                    )
                  : null,
              contentPadding: const EdgeInsets.all(8),
              title: Text(
                demo.title.toUpperCase(),
                style: const TextStyle(
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
