import 'package:flutter/foundation.dart';

import 'demos/demos.dart';
import 'utils/utils.dart';

extension GitUrl on String {
  String get git => 'https://github.com/roipeker/graphx/tree/master/example/lib/demos/$this';
}

final demos = <Scene>[
  if (!kIsWeb)
    SampleScene(
      title: "Colorful Shaders",
      build: () => const ColorfulShadersMain(),
      thumbnail: 'assets/thumbs/example_colorful_shaders.png',
      source: 'colorful_shaders'.git,
    ),
  SampleScene(
    title: "Simple Shapes",
    build: () => const SimpleShapesMain(),
    thumbnail: 'assets/thumbs/example_simple_shapes.png',
    source: 'simple_shape'.git,
  ),
  SampleScene(
    title: "Fun",
    build: () => const FunMain(),
    thumbnail: 'assets/thumbs/ss-fun.png',
    source: 'fun'.git,
  ),
  SampleScene(
    title: "Simple Tween",
    build: () => const SimpleTweenMain(),
    thumbnail: 'assets/thumbs/example_tween.png',
    source: 'simple_tween'.git,
  ),
  SampleScene(
    title: "Svg Icons",
    build: () => const DemoSvgIconsMain(),
    thumbnail: 'assets/thumbs/example_svg.png',
    source: 'svg_icons'.git,
  ),
  if (isDesktop)
    SampleScene(
      title: "Simple Interactions",
      build: () => const SimpleInteractionsMain(),
      thumbnail: 'assets/thumbs/example_simple_interactions.png',
      source: 'simple_interactions'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Graphics Clipper",
      build: () => const GraphicsClipperDemo(),
      thumbnail: 'assets/thumbs/example_clipper.png',
      source: 'graphics_clipper_demo'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Facebook Reactions",
      build: () => FacebookReactionsMain(),
      thumbnail: 'assets/thumbs/example_fb.png',
      source: 'fb_reactions'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Dripping IV",
      build: () => const DrippingIVMain(),
      thumbnail: 'assets/thumbs/example_dripping.png',
      source: 'dripping_iv'.git,
    ),
  SampleScene(
    title: "Chart Mountain",
    build: () => const ChartMountainMain(),
    thumbnail: 'assets/thumbs/example_chart.png',
    source: 'chart_mountain'.git,
  ),
  SampleScene(
    title: "Glowing Circle",
    build: () => const GlowingCircleMain(),
    thumbnail: 'assets/thumbs/example_glowing.png',
    source: 'glowing_circle'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Sorting Button",
      build: () => const SortingButtonMain(),
      thumbnail: 'assets/thumbs/example_sorting_list.png',
      source: 'sorting_button'.git,
    ),
  SampleScene(
    title: "Bookmark Button",
    build: () => const BookmarkButtonMain(),
    thumbnail: 'assets/thumbs/example_bookmark_button.png',
    source: 'bookmark_button'.git,
  ),
  SampleScene(
    title: "Submit Button",
    build: () => const SubmitButtonMain(),
    thumbnail: 'assets/thumbs/example_submit.png',
    source: 'submit_button'.git,
  ),
  SampleScene(
    title: "Card Rotation 3d",
    build: () => const CardRotation3dMain(),
    thumbnail: 'assets/thumbs/example_3drot.png',
    source: 'card_rotation'.git,
  ),
  SampleScene(
    title: "Raster Draw",
    build: () => const RasterDrawMain(),
    thumbnail: 'assets/thumbs/example_raster_draw.png',
    source: 'raster_draw'.git,
  ),
  SampleScene(
    title: "Dialer",
    build: () => const DialerMain(),
    thumbnail: 'assets/thumbs/example_dialer.png',
    source: 'dialer'.git,
  ),
  SampleScene(
    title: "Gauge Meter",
    build: () => const GaugeMeterMain(),
    thumbnail: 'assets/thumbs/example_gauge.png',
    source: 'gauge_meter'.git,
  ),
  SampleScene(
    title: "Spiral Loader",
    build: () => const SpiralLoaderMain(),
    thumbnail: 'assets/thumbs/example_spiral_loader.png',
    source: 'spiral_loader'.git,
  ),
  SampleScene(
    title: "Universo Flutter Intro",
    build: () => const UniversoFlutterIntroMain(),
    thumbnail: 'assets/thumbs/example_universo_flutter.png',
    source: 'universo_flutter_intro'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Colorful Loader",
      build: () => const ColorfulLoaderMain(),
      thumbnail: 'assets/thumbs/example_colorful_loader.png',
      source: 'colorful_loader'.git,
    ),
  SampleScene(
    title: "Jelly Thing",
    build: () => const JellyThingMain(),
    thumbnail: 'assets/thumbs/example_jelly.png',
    source: 'jelly_thing'.git,
  ),
  SampleScene(
    title: "Ball vs Line",
    build: () => const BallVsLineMain(),
    thumbnail: 'assets/thumbs/example_ball_vs_line.png',
    source: 'ball_line_collision'.git,
  ),
  SampleScene(
    title: "DNA 3d",
    build: () => const Dna3dMain(),
    thumbnail: 'assets/thumbs/example_dna.png',
    source: 'dna_3d'.git,
  ),
  SampleScene(
    title: "Splash Intro",
    build: () => const SplashIntroMain(),
    thumbnail: 'assets/thumbs/example_splash_intro.png',
    source: 'splash_intro'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Lined Button",
      build: () => const LinedButtonMain(),
      thumbnail: 'assets/thumbs/example_lined_button.png',
      source: 'lined_button'.git,
    ),
  SampleScene(
    title: "Color Picker",
    build: () => const ColorPickerMain(),
    thumbnail: 'assets/thumbs/example_color_picker.png',
    source: 'color_picker'.git,
  ),
  if (isSkia && isDesktop)
    SampleScene(
      title: "Altitude Indicator",
      build: () => const AltitudeIndicatorMain(),
      thumbnail: 'assets/thumbs/example_altitud_indicator.png',
      source: 'altitude_indicator'.git,
    ),
  if (isDesktop)
    SampleScene(
      title: "Breakout",
      build: () => const BreakoutMain(),
      thumbnail: 'assets/thumbs/example_breakout.png',
      source: 'breakout'.git,
    ),
  SampleScene(
    title: "Xmas",
    build: () => const XmasMain(),
    thumbnail: 'assets/thumbs/example_xmas.png',
    source: 'xmas'.git,
  ),
  SampleScene(
    title: "Simple Radial Menu",
    build: () => const SimpleRadialMenuMain(),
    thumbnail: 'assets/thumbs/example_radial_menu.png',
    source: 'simple_radial_menu'.git,
  ),
  SampleScene(
    title: "Murat Coffee",
    build: () => const MuratCoffeeMain(),
    thumbnail: 'assets/thumbs/example_murat_coffee.png',
    source: 'murat_coffee'.git,
  ),
  SampleScene(
    title: "Pie Chart",
    build: () => const PieChartMain(),
    thumbnail: 'assets/thumbs/example_pie_chart.png',
    source: 'pie_chart'.git,
  ),
  SampleScene(
    title: "Bezier Chart",
    build: () => const ChartBezierMain(),
    thumbnail: 'assets/thumbs/example_bezier_chart.png',
    source: 'chart_bezier'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Run Hero",
      build: () => const RunHeroCanvasMain(),
      thumbnail: 'assets/thumbs/example_run_hero.png',
      source: 'run_hero_canvas'.git,
    ),
  SampleScene(
    title: "Elastic Band",
    build: () => const ElasticBandMain(),
    thumbnail: 'assets/thumbs/example_elastic_band.png',
    source: 'elastic_band'.git,
  ),
  SampleScene(
    title: "Flower Gradient",
    build: () => const FlowerGradientMain(),
    thumbnail: 'assets/thumbs/example_gradient_flower.png',
    source: 'flower_gradient'.git,
  ),
  SampleScene(
    title: "Nokia Snake",
    build: () => const NokiaSnakeMain(),
    thumbnail: 'assets/thumbs/example_nokia_snake.png',
    source: 'nokia_snake'.git,
  ),
  SampleScene(
    title: "Heart Reaction",
    build: () => HeartReactionMain(),
    thumbnail: 'assets/thumbs/example_heart_reaction.png',
    source: 'heart_reaction'.git,
  ),
  SampleScene(
    title: "Simple Toast",
    build: () => const SimpleToastMain(),
    thumbnail: 'assets/thumbs/example_toast.png',
    source: 'simple_toast'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Rating Stars",
      build: () => const RatingStarsMain(),
      thumbnail: 'assets/thumbs/example_stars.png',
      source: 'rating_star'.git,
    ),
  SampleScene(
    title: "Pizza Box",
    build: () => const PizzaBoxMain(),
    thumbnail: 'assets/thumbs/example_pizza.png',
    source: 'pizza_box'.git,
  ),
  SampleScene(
    title: "Drawing Pad Bezier",
    build: () => const DrawingPadBezierMain(),
    thumbnail: 'assets/thumbs/example_drawing_pad_bezier.png',
    source: 'drawing_pad_bezier'.git,
  ),
  SampleScene(
    title: "Isma Chart",
    build: () => const IsmaChartMain(),
    thumbnail: 'assets/thumbs/example_isma_chart.png',
    source: 'isma_chart'.git,
  ),
  SampleScene(
    title: "TriGrid",
    build: () => const TriGridMain(),
    thumbnail: 'assets/thumbs/example_tri_grid.png',
    source: 'trigrid'.git,
  ),
  SampleScene(
    title: "Nico Loading",
    build: () => const NicoLoadingIndicatorMain(),
    thumbnail: 'assets/thumbs/example_nico_loading.png',
    source: 'nico_loading_indicator'.git,
  ),
  SampleScene(
    title: "Feeling Switch",
    build: () => const FeelingSwitchMain(),
    thumbnail: 'assets/thumbs/example_feeling_switch.png',
    source: 'feeling_switch'.git,
  ),
  SampleScene(
    title: "Mouse Repulsion",
    build: () => const MouseRepulsionMain(),
    thumbnail: 'assets/thumbs/example_lines_repulsion.png',
    source: 'mouse_repulsion'.git,
  ),
  SampleScene(
    title: "Globe 3d",
    build: () => const Globe3dMain(),
    thumbnail: 'assets/thumbs/example_globe_3d.png',
    source: 'globe_3d'.git,
  ),
  SampleScene(
    title: "Lungs Animation",
    build: () => const LungsAnimationMain(),
    thumbnail: 'assets/thumbs/example_lungs.png',
    source: 'lungs'.git,
  ),
  SampleScene(
    title: "Expander Fab",
    build: () => const ExpanderFabMenu(),
    thumbnail: 'assets/thumbs/example_expander_fab.png',
    source: 'expander_fab_menu'.git,
  ),
  if (isDesktop)
    SampleScene(
      title: "Page Indicator",
      build: () => const PageIndicatorMain(),
      thumbnail: 'assets/thumbs/example_page_indicator.png',
      source: 'page_indicator'.git,
    ),
  SampleScene(
    title: "Zoom Gesture",
    build: () => const ZoomGestureMain(),
    thumbnail: 'assets/thumbs/example_zoom_gesture.png',
    source: 'zoom_gesture'.git,
  ),
  SampleScene(
    title: "Zoom Pivot",
    build: () => const ZoomPivotMain(),
    thumbnail: 'assets/thumbs/example_zoom_pivot.png',
    source: 'zoom_pivot'.git,
  ),
  ExternalScene(
    title: 'Fly Dash !',
    url: Uri.parse('https://graphx-dash-game.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-dash-game.surge.sh.png',
  ),
  ExternalScene(
    title: 'Cells (1st demo)',
    url: Uri.parse('https://roi-graphx-cells.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-cells.surge.sh.png',
  ),
  ExternalScene(
    title: 'Snake',
    url: Uri.parse('https://graphx-snake-game.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-snake-game.surge.sh.png',
  ),
  ExternalScene(
    title: 'Draw Pad',
    url: Uri.parse('https://graphx-drawpad2.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-drawpad2.surge.sh.png',
  ),
  ExternalScene(
    title: 'Node Garden',
    url: Uri.parse('https://graphx-node-garden.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-node-garden.surge.sh.png',
  ),
  ExternalScene(
    title: 'Puzzle',
    url: Uri.parse('https://roi-puzzle-v2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-puzzle-v2.surge.sh.png',
  ),
  ExternalScene(
    title: 'Widget Mix',
    url: Uri.parse('https://roi-graphx-widgetmix.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-widgetmix.surge.sh.png',
  ),
  ExternalScene(
    title: 'Space Shooter',
    url: Uri.parse('https://roi-graphx-spaceshooter.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-spaceshooter.surge.sh.png',
  ),
  ExternalScene(
    title: 'Split RGB',
    url: Uri.parse('https://roi-graphx-rgbsplit.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-rgbsplit.surge.sh.png',
  ),
  ExternalScene(
    title: 'Input Text Particles',
    url: Uri.parse('https://roi-graphx-particles-input.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-particles-input.surge.sh.png',
  ),
  ExternalScene(
    title: 'Fish Eye',
    url: Uri.parse('https://roi-graphx-fisheyeparticles.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-fisheyeparticles.surge.sh.png',
  ),
  ExternalScene(
    title: 'Fish Eye Text',
    url: Uri.parse('https://roi-graphx-fisheyetext.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-fisheyetext.surge.sh.png',
  ),
  ExternalScene(
    title: 'Particle Emitter',
    url: Uri.parse('https://roi-graphx-particles2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-particles2.surge.sh.png',
  ),
  ExternalScene(
    title: 'Shape Maker Clone',
    url: Uri.parse('https://roi-graphx-shapemaker.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-shapemaker.surge.sh.png',
  ),
  ExternalScene(
    title: 'Mouse Follow',
    url: Uri.parse('https://roi-graphx-dotchain.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-dotchain.surge.sh.png',
  ),
  ExternalScene(
    title: 'Basic Hit Test',
    url: Uri.parse('http://roi-graphx-hittest.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-hittest.surge.sh.png',
  ),
  ExternalScene(
    title: 'SpriteSheet Sample',
    url: Uri.parse('https://roi-graphx-spritesheet.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-spritesheet.surge.sh.png',
  ),
  ExternalScene(
    title: 'Text Pivot',
    url: Uri.parse('https://roi-graphx-textpivot.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-textpivot.surge.sh.png',
  ),
  ExternalScene(
    title: 'Solo Ping-Pong',
    url: Uri.parse('https://roi-graphx-pingpong.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-pingpong.surge.sh.png',
  ),
  ExternalScene(
    title: 'Mask Demo',
    url: Uri.parse('https://roi-graphx-sample-masking.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-sample-masking.surge.sh.png',
  ),
  ExternalScene(
    title: 'Image Stack Web Page',
    url: Uri.parse('https://roi-graphx-web-image-stack-grid.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-web-image-stack-grid.surge.sh.png',
  ),
  ExternalScene(
    title: 'Fly Hero',
    url: Uri.parse('https://graphx-hh.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-hh.surge.sh.png',
  ),
  ExternalScene(
    title: 'Displacement BitmapData (Wrong Colors)',
    url: Uri.parse('https://graphx-weird-displacement.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-weird-displacement.surge.sh.png',
  ),
  ExternalScene(
    title: 'LOST Clock',
    url: Uri.parse('https://graphx-lost-clock-skia.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-lost-clock-skia.surge.sh.png',
  ),
  ExternalScene(
    title: 'HUGE INC Website Clone',
    url: Uri.parse('https://graphx-hugeinc.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-hugeinc.surge.sh.png',
  ),
  ExternalScene(
    title: 'Open Maps',
    url: Uri.parse('https://graphx-openmaps2.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-openmaps2.surge.sh.png',
  ),
  ExternalScene(
    title: 'Raster In Bitmap',
    url: Uri.parse('https://graphx-raster1.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-raster1.surge.sh.png',
  ),
  ExternalScene(
    title: 'Meteor Shower',
    url: Uri.parse('https://graphx-meteor-shower.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-meteor-shower.surge.sh.png',
  ),
  ExternalScene(
    title: '(Bad) Candle Chart Concept',
    url: Uri.parse('https://graphx-candlechart-skia.surge.sh'),
    thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
  ),
  ExternalScene(
    title: 'Candle Chart Animated',
    url: Uri.parse('https://roi-taso-chart19.surge.sh'),
    thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
  ),
  ExternalScene(
    title: 'Waltz Circles',
    url: Uri.parse('https://roi-fp5-waltz-circ.surge.sh'),
    thumbnail: 'assets/thumbs/roi-fp5-waltz-circ.surge.sh.png',
  ),
  ExternalScene(
    title: 'Waltz Circles (BMP)',
    url: Uri.parse('https://roi-fp5-waltz-circ-bmp.surge.sh'),
    thumbnail: 'assets/thumbs/roi-fp5-waltz-circ-bmp.surge.sh.png',
  ),
  ExternalScene(
    title: 'CrypterIcon Logo',
    url: Uri.parse('https://cryptericon-logo-dot3.surge.sh'),
    thumbnail: 'assets/thumbs/cryptericon-logo-dot3.surge.sh.png',
  ),
  ExternalScene(
    title: 'Runner Mark Test',
    url: Uri.parse('https://graphx-runnermark.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-runnermark.surge.sh.png',
  ),
  ExternalScene(
    title: 'Minimalcomps (Flash)',
    url: Uri.parse('https://graphx-minimalcomps.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-minimalcomps.surge.sh.png',
  ),
  ExternalScene(
    title: 'Pan Zoom',
    url: Uri.parse('https://graphx-gesture-sample.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-gesture-sample.surge.sh.png',
  ),
  ExternalScene(
    title: 'Simple Transform',
    url: Uri.parse('https://graphx-gesture-simple.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-gesture-simple.surge.sh.png',
  ),
  ExternalScene(
    title: 'Dots Sphere Rotation',
    url: Uri.parse('https://graphx-sphere-dots-rotation.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-sphere-dots-rotation.surge.sh.png',
  ),
  ExternalScene(
    title: 'Falling Boxes',
    url: Uri.parse('https://graphx-burn-boxes.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-burn-boxes.surge.sh.png',
  ),
  ExternalScene(
    title: 'Sunburst Chart',
    url: Uri.parse('https://graphx-sunburst-chart.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-sunburst-chart.surge.sh.png',
  ),
  ExternalScene(
    title: '3d Stars',
    url: Uri.parse('https://roi-swr3d-stars.surge.sh'),
    thumbnail: 'assets/thumbs/roi-swr3d-stars.surge.sh.png',
  ),
  ExternalScene(
    title: 'Manu Painter Particles',
    url: Uri.parse('https://roi-particles-manu-painter2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-particles-manu-painter2.surge.sh.png',
  ),
  ExternalScene(
    title: 'Perlin Noise Terrain',
    url: Uri.parse('https://graphx-perlin-map.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-perlin-map.surge.sh.png',
  ),
  ExternalScene(
    title: 'Fly Dash 1',
    url: Uri.parse('https://graphx-trees.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-trees.surge.sh.png',
  ),
  ExternalScene(
    title: 'Puzzle Interaction',
    url: Uri.parse('https://graphx-puzzle-ref.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-puzzle-ref.surge.sh.png',
  ),
  ExternalScene(
    title: 'Simple Particles',
    url: Uri.parse('https://graphx-simple-particles.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-simple-particles.surge.sh.png',
  ),
];

abstract class Scene<T> {
  final String title;
  final T Function() build;
  final String? thumbnail;
  final String? source;

  Uri? get sourceUri => source != null ? Uri.tryParse(source!) : null;

  const Scene({
    required this.title,
    required this.build,
    this.thumbnail,
    this.source,
  });
}

class SampleScene extends Scene<Widget> {
  SampleScene({
    required super.title,
    required super.build,
    super.thumbnail,
    super.source,
    String? path,
  }) : path = path ?? "/${title.replaceAll(' ', '_').toLowerCase()}";
  final String path;
}

class ExternalScene extends Scene<Uri> {
  final Uri url;

  ExternalScene({
    required super.title,
    required this.url,
    super.thumbnail,
    super.source,
  }) : super(build: () => url);
}
