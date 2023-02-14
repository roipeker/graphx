import 'package:flutter/foundation.dart';

import 'demos/demos.dart';
import 'utils/utils.dart';

extension GitUrl on String {
  String get git =>
      'https://github.com/roipeker/graphx/tree/master/example/lib/demos/$this';
}

final demos = <Scene>[
  if (!kIsWeb)
    SampleScene(
      title: "Colorful Shaders",
      build: () => const ColorfulShadersMain(),
      thumbnail: 'assets/thumbs/example_colorful_shaders.png',
      hash: 'LJE.qx-.0LxtB~5PIU-.IW-Fx@XR',
      source: 'colorful_shaders'.git,
    ),
  SampleScene(
    title: "Simple Shapes",
    build: () => const SimpleShapesMain(),
    thumbnail: 'assets/thumbs/example_simple_shapes.png',
    hash: 'LVSF%[\$]bgR?V@fjfRa#%QN4jBt0',
    source: 'simple_shape'.git,
  ),
  SampleScene(
    title: "Fun",
    build: () => const FunMain(),
    thumbnail: 'assets/thumbs/ss-fun.png',
    hash: 'LYS6Pgr@?dS}t3a#jJfi.AX8ISrs',
    source: 'fun'.git,
  ),
  SampleScene(
    title: "Simple Tween",
    build: () => const SimpleTweenMain(),
    thumbnail: 'assets/thumbs/example_tween.png',
    hash: 'LJO:-Cj@_Nt7tRj[V@ae_Nj]8_WB',
    source: 'simple_tween'.git,
  ),
  SampleScene(
    title: "Svg Icons",
    build: () => const DemoSvgIconsMain(),
    thumbnail: 'assets/thumbs/example_svg.png',
    hash: 'LQRfX-IV?t%eogWBWBt7_L%eIBIV',
    source: 'svg_icons'.git,
  ),
  if (isDesktop)
    SampleScene(
      title: "Simple Interactions",
      build: () => const SimpleInteractionsMain(),
      thumbnail: 'assets/thumbs/example_simple_interactions.png',
      hash: 'LlNTzY4n_3%Mt7t7WBay~q%MIUWB',
      source: 'simple_interactions'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Graphics Clipper",
      build: () => const GraphicsClipperDemo(),
      thumbnail: 'assets/thumbs/example_clipper.png',
      hash: 'LnM@K6=D?bS%-;bcRjjF_MN{M{s,',
      source: 'graphics_clipper_demo'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Facebook Reactions",
      build: () => FacebookReactionsMain(),
      thumbnail: 'assets/thumbs/example_fb.png',
      hash: 'LWMaS0XVJt-i~qng-NN1%MWAska\$',
      source: 'fb_reactions'.git,
    ),
  if (isSkia)
    SampleScene(
      title: "Dripping IV",
      build: () => const DrippingIVMain(),
      thumbnail: 'assets/thumbs/example_dripping.png',
      hash: 'L5PxOzs.*KwdrDf6pIfkz;jZK%bH',
      source: 'dripping_iv'.git,
    ),
  SampleScene(
    title: "Chart Mountain",
    build: () => const ChartMountainMain(),
    thumbnail: 'assets/thumbs/example_chart.png',
    hash: 'LoO3^Bxb%gxv?aRjV^V@?dSJRPV@',
    source: 'chart_mountain'.git,
  ),
  SampleScene(
    title: "Glowing Circle",
    build: () => const GlowingCircleMain(),
    thumbnail: 'assets/thumbs/example_glowing.png',
    hash: 'LpP\$?|of_Lf8x[azRjay_LayIBfj',
    source: 'glowing_circle'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Sorting Button",
      build: () => const SortingButtonMain(),
      thumbnail: 'assets/thumbs/example_sorting_list.png',
      hash: 'LgKx6pof~qayt7fQWBfQ~qayD%j[',
      source: 'sorting_button'.git,
    ),
  SampleScene(
    title: "Bookmark Button",
    build: () => const BookmarkButtonMain(),
    thumbnail: 'assets/thumbs/example_bookmark_button.png',
    hash: 'L5R:KTNObf%O~mRla\$a\$9.jWM^IT',
    source: 'bookmark_button'.git,
  ),
  SampleScene(
    title: "Submit Button",
    build: () => const SubmitButtonMain(),
    thumbnail: 'assets/thumbs/example_submit.png',
    hash: 'LzKx-cj[ayj[NGfQfQfQ~Djuj[fQ',
    source: 'submit_button'.git,
  ),
  SampleScene(
    title: "Card Rotation 3d",
    build: () => const CardRotation3dMain(),
    thumbnail: 'assets/thumbs/example_3drot.png',
    hash: 'LMRyZ?I9t6%\$%MkCWBWC.T%hR*IA',
    source: 'card_rotation'.git,
  ),
  SampleScene(
    title: "Raster Draw",
    build: () => const RasterDrawMain(),
    thumbnail: 'assets/thumbs/example_raster_draw.png',
    hash: 'L4SF;L%M?b%M-;-;IURj~qD%M{of',
    source: 'raster_draw'.git,
  ),
  SampleScene(
    title: "Dialer",
    build: () => const DialerMain(),
    thumbnail: 'assets/thumbs/example_dialer.png',
    hash: 'L87dk7~WWBDiozXRj[R*009Fxa-;',
    source: 'dialer'.git,
  ),
  SampleScene(
    title: "Gauge Meter",
    build: () => const GaugeMeterMain(),
    thumbnail: 'assets/thumbs/example_gauge.png',
    hash: 'L8SY]isoyDtlbbfks:ae?^kWRPa0',
    source: 'gauge_meter'.git,
  ),
  SampleScene(
    title: "Spiral Loader",
    build: () => const SpiralLoaderMain(),
    thumbnail: 'assets/thumbs/example_spiral_loader.png',
    hash: 'LJQvzct7x]t6xua|ayj?~VbHt6az',
    source: 'spiral_loader'.git,
  ),
  SampleScene(
    title: "Universo Flutter Intro",
    build: () => const UniversoFlutterIntroMain(),
    thumbnail: 'assets/thumbs/example_universo_flutter.png',
    hash: 'LGBERLS%0L?vq@McD%s89~ng?GIA',
    source: 'universo_flutter_intro'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Colorful Loader",
      build: () => const ColorfulLoaderMain(),
      thumbnail: 'assets/thumbs/example_colorful_loader.png',
      hash: 'LWR3Te%Kxtxt-.WBWBWC~nM|M|Rk',
      source: 'colorful_loader'.git,
    ),
  SampleScene(
    title: "Jelly Thing",
    build: () => const JellyThingMain(),
    thumbnail: 'assets/thumbs/example_jelly.png',
    hash: 'LfK.tTWB%5Rixcs=f8WA?KoMoNay',
    source: 'jelly_thing'.git,
  ),
  SampleScene(
    title: "Ball vs Line",
    build: () => const BallVsLineMain(),
    thumbnail: 'assets/thumbs/example_ball_vs_line.png',
    hash: 'LOQvg-H[nVI7tm%g%ftS?cxnVqVz',
    source: 'ball_line_collision'.git,
  ),
  SampleScene(
    title: "DNA 3d",
    build: () => const Dna3dMain(),
    thumbnail: 'assets/thumbs/example_dna.png',
    hash: 'LPR:HGRj~q%MWBofofRjt7ayRjof',
    source: 'dna_3d'.git,
  ),
  SampleScene(
    title: "Splash Intro",
    build: () => const SplashIntroMain(),
    thumbnail: 'assets/thumbs/example_splash_intro.png',
    hash: 'LCRH}CZhVsn4yXVsaKaKL#o~kWkW',
    source: 'splash_intro'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Lined Button",
      build: () => const LinedButtonMain(),
      thumbnail: 'assets/thumbs/example_lined_button.png',
      hash: 'L18E6\$j[9FayoffQayfQ00fQ-;of',
      source: 'lined_button'.git,
    ),
  SampleScene(
    title: "Color Picker",
    build: () => const ColorPickerMain(),
    thumbnail: 'assets/thumbs/example_color_picker.png',
    hash: 'LOAK5rIT%CD+xgx-RPRjQ,cEZ+o|',
    source: 'color_picker'.git,
  ),
  if (isSkia && isDesktop)
    SampleScene(
      title: "Altitude Indicator",
      build: () => const AltitudeIndicatorMain(),
      thumbnail: 'assets/thumbs/example_altitud_indicator.png',
      hash: 'LWB;a[jYofjYyZaeaJaxrpoengkD',
      source: 'altitude_indicator'.git,
    ),
  if (isDesktop)
    SampleScene(
      title: "Breakout",
      build: () => const BreakoutMain(),
      thumbnail: 'assets/thumbs/example_breakout.png',
      hash: 'LHByf~NHIoR.}pWrozR*4Yt6xtj=',
      source: 'breakout'.git,
    ),
  SampleScene(
    title: "Xmas",
    build: () => const XmasMain(),
    thumbnail: 'assets/thumbs/example_xmas.png',
    hash: 'LVKJ+D0zI?t8=waybIbIE3-VNGR*',
    source: 'xmas'.git,
  ),
  SampleScene(
    title: "Simple Radial Menu",
    build: () => const SimpleRadialMenuMain(),
    thumbnail: 'assets/thumbs/example_radial_menu.png',
    hash: 'LLOq4}-m~Ps:%Jj@odWD~PR+oKRm',
    source: 'simple_radial_menu'.git,
  ),
  SampleScene(
    title: "Murat Coffee",
    build: () => const MuratCoffeeMain(),
    thumbnail: 'assets/thumbs/example_murat_coffee.png',
    hash: 'L:OMpis:?^R*RPofozWBozj[V@af',
    source: 'murat_coffee'.git,
  ),
  SampleScene(
    title: "Pie Chart",
    build: () => const PieChartMain(),
    thumbnail: 'assets/thumbs/example_pie_chart.png',
    hash: 'LkMPnV\$+_MkSK+nhwIba_MN_tRaK',
    source: 'pie_chart'.git,
  ),
  SampleScene(
    title: "Bezier Chart",
    build: () => const ChartBezierMain(),
    thumbnail: 'assets/thumbs/example_bezier_chart.png',
    hash: 'L00]I1smofWVEebHjsjtNaNbNaoM',
    source: 'chart_bezier'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Run Hero",
      build: () => const RunHeroCanvasMain(),
      thumbnail: 'assets/thumbs/example_run_hero.png',
      hash: 'LRN0uE-O01D%x*o|9FE1_MM}xaxu',
      source: 'run_hero_canvas'.git,
    ),
  SampleScene(
    title: "Elastic Band",
    build: () => const ElasticBandMain(),
    thumbnail: 'assets/thumbs/example_elastic_band.png',
    hash: 'L]8?UgVBazkrkCaxfQfkbHfQjsfQ',
    source: 'elastic_band'.git,
  ),
  SampleScene(
    title: "Flower Gradient",
    build: () => const FlowerGradientMain(),
    thumbnail: 'assets/thumbs/example_gradient_flower.png',
    hash: 'LcONC4Dk%gXR_2NGR6sB~o-:Iobb',
    source: 'flower_gradient'.git,
  ),
  SampleScene(
    title: "Nokia Snake",
    build: () => const NokiaSnakeMain(),
    thumbnail: 'assets/thumbs/example_nokia_snake.png',
    hash: 'L4H2MD%YpB=e-mRlR+r^_CMlVyEy',
    source: 'nokia_snake'.git,
  ),
  SampleScene(
    title: "Heart Reaction",
    build: () => HeartReactionMain(),
    thumbnail: 'assets/thumbs/example_heart_reaction.png',
    hash: 'LLLE1xk=tlVr*0RjS2a0OqxasoRj',
    source: 'heart_reaction'.git,
  ),
  SampleScene(
    title: "Simple Toast",
    build: () => const SimpleToastMain(),
    thumbnail: 'assets/thumbs/example_toast.png',
    hash: 'L_RxcXozkWkCy?aeaeaeVsj[j[fk',
    source: 'simple_toast'.git,
  ),
  if (isSkia)
    SampleScene(
      title: "Rating Stars",
      build: () => const RatingStarsMain(),
      thumbnail: 'assets/thumbs/example_stars.png',
      hash: 'LJRC=8ogbdogoIfRfkfRThf6jDf6',
      source: 'rating_star'.git,
    ),
  SampleScene(
    title: "Pizza Box",
    build: () => const PizzaBoxMain(),
    thumbnail: 'assets/thumbs/example_pizza.png',
    hash: 'LqPieg.8.TRP-;RiRjaycZsmaJV@',
    source: 'pizza_box'.git,
  ),
  SampleScene(
    title: "Drawing Pad Bezier",
    build: () => const DrawingPadBezierMain(),
    thumbnail: 'assets/thumbs/example_drawing_pad_bezier.png',
    hash: 'L7Dj^[J|1],vDz5@wf,.^T,m=HWZ',
    source: 'drawing_pad_bezier'.git,
  ),
  SampleScene(
    title: "Isma Chart",
    build: () => const IsmaChartMain(),
    thumbnail: 'assets/thumbs/example_isma_chart.png',
    hash: 'LCSs1?DgI8Z}MIrCrWn3MdrCrWnN',
    source: 'isma_chart'.git,
  ),
  SampleScene(
    title: "TriGrid",
    build: () => const TriGridMain(),
    thumbnail: 'assets/thumbs/example_tri_grid.png',
    hash: 'LHF4u]13EQ^OxaNbNIaeEks.ayR*',
    source: 'trigrid'.git,
  ),
  SampleScene(
    title: "Nico Loading",
    build: () => const NicoLoadingIndicatorMain(),
    thumbnail: 'assets/thumbs/example_nico_loading.png',
    hash: 'LWR3TWRj~qxuayayofj[~qt74nRj',
    source: 'nico_loading_indicator'.git,
  ),
  SampleScene(
    title: "Feeling Switch",
    build: () => const FeelingSwitchMain(),
    thumbnail: 'assets/thumbs/example_feeling_switch.png',
    hash: 'LERfh2R%t8xv-;t7WBWB_4oMaxR%',
    source: 'feeling_switch'.git,
  ),
  SampleScene(
    title: "Mouse Repulsion",
    build: () => const MouseRepulsionMain(),
    thumbnail: 'assets/thumbs/example_lines_repulsion.png',
    hash: 'L8R:NTxvaxt7^-%3R%ayxvaxWUof',
    source: 'mouse_repulsion'.git,
  ),
  SampleScene(
    title: "Globe 3d",
    build: () => const Globe3dMain(),
    thumbnail: 'assets/thumbs/example_globe_3d.png',
    hash: 'L9SY5ryAuatQt7f7fjf7VvpEuaag',
    source: 'globe_3d'.git,
  ),
  SampleScene(
    title: "Lungs Animation",
    build: () => const LungsAnimationMain(),
    thumbnail: 'assets/thumbs/example_lungs.png',
    hash: 'LfNS{XjFVYyX?vx]x]Rj?^V@Rjwe',
    source: 'lungs'.git,
  ),
  SampleScene(
    title: "Expander Fab",
    build: () => const ExpanderFabMenu(),
    thumbnail: 'assets/thumbs/example_expander_fab.png',
    hash: 'LAP_pxoKHXsotRf6Vsj[o}f6Vsfk',
    source: 'expander_fab_menu'.git,
  ),
  if (isDesktop)
    SampleScene(
      title: "Page Indicator",
      build: () => const PageIndicatorMain(),
      thumbnail: 'assets/thumbs/example_page_indicator.png',
      hash: 'LTP?p~D5+bvee:aeo0jYayf6jtjs',
      source: 'page_indicator'.git,
    ),
  SampleScene(
    title: "Zoom Gesture",
    build: () => const ZoomGestureMain(),
    thumbnail: 'assets/thumbs/example_zoom_gesture.png',
    hash: 'LQHezq4mD\$It9Exvt8s,D\$tRo#t2',
    source: 'zoom_gesture'.git,
  ),
  SampleScene(
    title: "Zoom Pivot",
    build: () => const ZoomPivotMain(),
    thumbnail: 'assets/thumbs/example_zoom_pivot.png',
    hash: 'LeS#;dp3pItjk0oqa^ajo[a\$aiaw',
    source: 'zoom_pivot'.git,
  ),
  ExternalScene(
    title: 'Fly Dash !',
    url: Uri.parse('https://graphx-dash-game.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-dash-game.surge.sh.png',
    hash: 'LkLh0cRkjbxtp3bckDWX0gbckCoL',
  ),
  ExternalScene(
    title: 'Cells (1st demo)',
    url: Uri.parse('https://roi-graphx-cells.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-cells.surge.sh.png',
    hash: 'L95z-0EGoJj]W,oMj]j?oMoMW-j[',
  ),
  ExternalScene(
    title: 'Snake',
    url: Uri.parse('https://graphx-snake-game.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-snake-game.surge.sh.png',
    hash: 'L2S?DW%MVW~Wx]IUV?oKMuM_58Iq',
  ),
  ExternalScene(
    title: 'Draw Pad',
    url: Uri.parse('https://graphx-drawpad2.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-drawpad2.surge.sh.png',
    hash: 'LA97050K?F9vNDT0r^xF59}?5Qxu',
  ),
  ExternalScene(
    title: 'Node Garden',
    url: Uri.parse('https://graphx-node-garden.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-node-garden.surge.sh.png',
    hash: 'L34K]N5j+dKh61]pAU,u=fAU,uE{',
  ),
  ExternalScene(
    title: 'Puzzle',
    url: Uri.parse('https://roi-puzzle-v2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-puzzle-v2.surge.sh.png',
    hash: 'L9Dl=?x]9GNb~Vxu%Mxv~qen-;%1',
  ),
  ExternalScene(
    title: 'Widget Mix',
    url: Uri.parse('https://roi-graphx-widgetmix.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-widgetmix.surge.sh.png',
    hash: 'LcQ0p[E1M|Wp0moff8f70jj@WVay',
  ),
  ExternalScene(
    title: 'Space Shooter',
    url: Uri.parse('https://roi-graphx-spaceshooter.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-spaceshooter.surge.sh.png',
    hash: 'L01yLQkCf5jZj[ayayayjYf6bHfk',
  ),
  ExternalScene(
    title: 'Split RGB',
    url: Uri.parse('https://roi-graphx-rgbsplit.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-rgbsplit.surge.sh.png',
    hash: 'LXG8Dqt69aIpI=RkxGt60fnjxaoy',
  ),
  ExternalScene(
    title: 'Input Text Particles',
    url: Uri.parse('https://roi-graphx-particles-input.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-particles-input.surge.sh.png',
    hash: 'L467Zd=e5,ACs:oLWVWV1vEz=K,@',
  ),
  ExternalScene(
    title: 'Fish Eye',
    url: Uri.parse('https://roi-graphx-fisheyeparticles.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-fisheyeparticles.surge.sh.png',
    hash: 'L03+4VbHS}j[%2s:bHoLX-oLsAfR',
  ),
  ExternalScene(
    title: 'Fish Eye Text',
    url: Uri.parse('https://roi-graphx-fisheyetext.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-fisheyetext.surge.sh.png',
    hash: 'L03[xT-;D%IUWBayt7j[00IU-;%M',
  ),
  ExternalScene(
    title: 'Particle Emitter',
    url: Uri.parse('https://roi-graphx-particles2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-particles2.surge.sh.png',
    hash: 'L042C#~W~Cv#uOK%F_Ez;##8#S-V',
  ),
  ExternalScene(
    title: 'Shape Maker Clone',
    url: Uri.parse('https://roi-graphx-shapemaker.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-shapemaker.surge.sh.png',
    hash: 'L03[#cxuD\$kDxvofs.kCMcWBxvWA',
  ),
  ExternalScene(
    title: 'Mouse Follow',
    url: Uri.parse('https://roi-graphx-dotchain.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-dotchain.surge.sh.png',
    hash: 'L14LXis\$x_s*-?oY%Os*-=oaxvs.',
  ),
  ExternalScene(
    title: 'Basic Hit Test',
    url: Uri.parse('http://roi-graphx-hittest.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-hittest.surge.sh.png',
    hash: 'L43+\$9kDY.i]bcf+jXenmAf4Ygf.',
  ),
  ExternalScene(
    title: 'SpriteSheet Sample',
    url: Uri.parse('https://roi-graphx-spritesheet.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-spritesheet.surge.sh.png',
    hash: 'L55}U39tEL~Bs.WVa#s:57-V%157',
  ),
  ExternalScene(
    title: 'Text Pivot',
    url: Uri.parse('https://roi-graphx-textpivot.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-textpivot.surge.sh.png',
    hash: 'L45}W~9wxYM*0k=^I=o^-A9x\$}sB',
  ),
  ExternalScene(
    title: 'Solo Ping-Pong',
    url: Uri.parse('https://roi-graphx-pingpong.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-pingpong.surge.sh.png',
    hash: 'L48XC1Iv8^N2D,?FR;xo4mNM-.IW',
  ),
  ExternalScene(
    title: 'Mask Demo',
    url: Uri.parse('https://roi-graphx-sample-masking.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-sample-masking.surge.sh.png',
    hash: 'LMJt9.P.L0xZ.PV|Rkix3=z;#8Wn',
  ),
  ExternalScene(
    title: 'Image Stack Web Page',
    url: Uri.parse('https://roi-graphx-web-image-stack-grid.surge.sh'),
    thumbnail: 'assets/thumbs/roi-graphx-web-image-stack-grid.surge.sh.png',
    hash: 'LTHxZ;4nbw4TpIjFMxkqMykWM{xu',
  ),
  ExternalScene(
    title: 'Fly Hero',
    url: Uri.parse('https://graphx-hh.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-hh.surge.sh.png',
    hash: 'LXK:JfazflofB@j?oIbFm+ayWAjY',
  ),
  ExternalScene(
    title: 'Displacement BitmapData (Wrong Colors)',
    url: Uri.parse('https://graphx-weird-displacement.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-weird-displacement.surge.sh.png',
    hash: 'Ld4f,vkCRiaepMj[bIazgkfPkDfk',
  ),
  ExternalScene(
    title: 'LOST Clock',
    url: Uri.parse('https://graphx-lost-clock-skia.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-lost-clock-skia.surge.sh.png',
    hash: 'L13IhiMdR*ofNGaej[ay00ogt7WB',
  ),
  ExternalScene(
    title: 'HUGE INC Website Clone',
    url: Uri.parse('https://graphx-hugeinc.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-hugeinc.surge.sh.png',
    hash: 'LIBM*]E14TR*D%%MRjaykqRPkWxa',
  ),
  ExternalScene(
    title: 'Open Maps',
    url: Uri.parse('https://graphx-openmaps2.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-openmaps2.surge.sh.png',
    hash: 'L142F*?a024.NctRt7IVMzaht7oy',
  ),
  ExternalScene(
    title: 'Raster In Bitmap',
    url: Uri.parse('https://graphx-raster1.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-raster1.surge.sh.png',
    hash: 'L18E3uIx;CKv8~95R6te?toEQniv',
  ),
  ExternalScene(
    title: 'Meteor Shower',
    url: Uri.parse('https://graphx-meteor-shower.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-meteor-shower.surge.sh.png',
    hash: 'L04n[B\$bR31#Iv,HRppFDQs=J-Vi',
  ),
  ExternalScene(
    title: '(Bad) Candle Chart Concept',
    url: Uri.parse('https://graphx-candlechart-skia.surge.sh'),
    thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
    hash: 'L47A@~XRU_tk\$%EMaLo{0gE2tPxa',
  ),
  ExternalScene(
    title: 'Candle Chart Animated',
    url: Uri.parse('https://roi-taso-chart19.surge.sh'),
    thumbnail: 'assets/thumbs/roi-taso-chart19.surge.sh.png',
    hash: 'L47A@~XRU_tk\$%EMaLo{0gE2tPxa',
  ),
  ExternalScene(
    title: 'Waltz Circles',
    url: Uri.parse('https://roi-fp5-waltz-circ.surge.sh'),
    thumbnail: 'assets/thumbs/roi-fp5-waltz-circ.surge.sh.png',
    hash: 'L01Cf=niWBj[Wrj[j@kCkBkCRjjY',
  ),
  ExternalScene(
    title: 'Waltz Circles (BMP)',
    url: Uri.parse('https://roi-fp5-waltz-circ-bmp.surge.sh'),
    thumbnail: 'assets/thumbs/roi-fp5-waltz-circ-bmp.surge.sh.png',
    hash: 'L04o1eys_NM{~6IApK_2-.~C4:%M',
  ),
  ExternalScene(
    title: 'CrypterIcon Logo',
    url: Uri.parse('https://cryptericon-logo-dot3.surge.sh'),
    thumbnail: 'assets/thumbs/cryptericon-logo-dot3.surge.sh.png',
    hash: 'L04Kc}oL1JoLoKa|fQfQWWa|j@a|',
  ),
  ExternalScene(
    title: 'Runner Mark Test',
    url: Uri.parse('https://graphx-runnermark.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-runnermark.surge.sh.png',
    hash: 'LGC%Ef^jxDV[4mEKWDNGX9NGRjba',
  ),
  ExternalScene(
    title: 'Minimalcomps (Flash)',
    url: Uri.parse('https://graphx-minimalcomps.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-minimalcomps.surge.sh.png',
    hash: 'LdQmSKRjRkof0mofa#ay0joffRfQ',
  ),
  ExternalScene(
    title: 'Pan Zoom',
    url: Uri.parse('https://graphx-gesture-sample.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-gesture-sample.surge.sh.png',
    hash: 'L58p_m*_OS0OD67y#8?t7XIHpcQm',
  ),
  ExternalScene(
    title: 'Simple Transform',
    url: Uri.parse('https://graphx-gesture-simple.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-gesture-simple.surge.sh.png',
    hash: 'LMIYeED\$I9Mw0=o#t7kE5JxZS7og',
  ),
  ExternalScene(
    title: 'Dots Sphere Rotation',
    url: Uri.parse('https://graphx-sphere-dots-rotation.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-sphere-dots-rotation.surge.sh.png',
    hash: 'L009j]f3W5fnj.fTa%f4jmfTa%fO',
  ),
  ExternalScene(
    title: 'Falling Boxes',
    url: Uri.parse('https://graphx-burn-boxes.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-burn-boxes.surge.sh.png',
    hash: 'L%GjE0}n#,M~IaN0a|t5OqOpSxWo',
  ),
  ExternalScene(
    title: 'Sunburst Chart',
    url: Uri.parse('https://graphx-sunburst-chart.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-sunburst-chart.surge.sh.png',
    hash: 'LoP\$tBkAu6jv5ua#V?j?AMazaday',
  ),
  ExternalScene(
    title: '3d Stars',
    url: Uri.parse('https://roi-swr3d-stars.surge.sh'),
    thumbnail: 'assets/thumbs/roi-swr3d-stars.surge.sh.png',
    hash: 'L00J8VayWBfQfQfQj[j[fQayj[j[',
  ),
  ExternalScene(
    title: 'Manu Painter Particles',
    url: Uri.parse('https://roi-particles-manu-painter2.surge.sh'),
    thumbnail: 'assets/thumbs/roi-particles-manu-painter2.surge.sh.png',
    hash: 'LiQck?V=tmtS0MadkEkC9+o#ROV?',
  ),
  ExternalScene(
    title: 'Perlin Noise Terrain',
    url: Uri.parse('https://graphx-perlin-map.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-perlin-map.surge.sh.png',
    hash: 'L~L4.@00t7%Mt7oLR*WBt7ofWBWB',
  ),
  ExternalScene(
    title: 'Fly Dash 1',
    url: Uri.parse('https://graphx-trees.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-trees.surge.sh.png',
    hash: 'L11fbxMxDN%\$ROkCtSRP8wtl%\$Mc',
  ),
  ExternalScene(
    title: 'Puzzle Interaction',
    url: Uri.parse('https://graphx-puzzle-ref.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-puzzle-ref.surge.sh.png',
    hash: 'LfH_[U%0S5RjThR+jFofA3R%bJs:',
  ),
  ExternalScene(
    title: 'Simple Particles',
    url: Uri.parse('https://graphx-simple-particles.surge.sh'),
    thumbnail: 'assets/thumbs/graphx-simple-particles.surge.sh.png',
    hash: 'LQCiKRk90PRn4@jb-,t4R+azodWV',
  ),
];

abstract class Scene<T> {
  final String title;
  final T Function() build;
  final String? _thumbnail;
  final String? source;
  final String? hash;

  static const kDefaultThumbnail = 'assets/thumbs/roi-simple-shapes.png';

  String get thumbnail {
    var str = _thumbnail ?? kDefaultThumbnail;
    if (str.contains('?')) {
      str = str.split('?').first;
    }

    /// BlurHash Library workaround (asset vs network req).
    if (kIsWeb) {
      str = 'assets/$str';
    }
    return str;
  }

  Uri? get sourceUri => source != null ? Uri.tryParse(source!) : null;

  const Scene({
    required this.title,
    required this.build,
    String? thumbnail,
    this.hash,
    this.source,
  }) : _thumbnail = thumbnail;

  Uri get thumbnailUri => Uri.parse(thumbnail);
}

class SampleScene extends Scene<Widget> {
  SampleScene({
    required super.title,
    required super.build,
    super.thumbnail,
    super.source,
    super.hash,
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
    super.hash,
  }) : super(build: () => url);
}
