import 'package:flutter/material.dart';

import 'demos/demos.dart';

void main() {
  runApp(
    MaterialApp(home: _SamplesApp()),
  );
}

/// --- Wrapper widget for easy visualiation with hot reload.
class _SamplesApp extends StatelessWidget {
  const _SamplesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleShapesMain();
    // return SimpleTweenMain();
    // return DemoSvgIconsMain();
    // return SimpleInteractionsMain();
    // return GraphicsClipperDemo();
    // return FacebookReactionsMain();
    // return DrippingIVMain();
    // return ChartMountainMain();
    // return GlowingCircleMain();
    // return SortingButtonMain();
    // return BookmarkButtonMain();
    // return SubmitButtonMain();
    // return CardRotation3dMain();
    // return RasterDrawingMain();
    // return DialerMain();
    // return GaugeMeterMain();
    // return SpiralLoaderMain();
    // return UniversoFlutterIntroMain();
    // return ColorfulLoaderMain();
    // return JellyThingMain();
    // return BallVsLineMain();
    // return Dna3dMain();
    // return SplashIntroMain();
    // return LinedButtonMain();
    // return ColorPickerMain();
    // return AltitudeIndicatorMain();
    // return BreakoutMain();
    // return XmasMain();
    // return SimpleRadialMenuMain();
    // return MuratCoffeeMain();
    // return PieChartMain();
    // return ChartBezierMain();
    // return RunHeroCanvasMain();
    // return ElasticBandMain();
    // return FlowerGradientMain();
    // return NokiaSnakeMain();
    // return HeartReactionMain();
    // return SimpleToastMain();
    // return RatingStarsMain();
    // return PizzaBoxMain();
    // return DrawingPadBezierMain();
    // return IsmaChartMain();
    // return TriGridMain();
    // return NicoLoadingIndicatorMain();
    // return FeelingSwitchMain();
    // return MouseRepulsionMain();
    // return Globe3dMain();
    // return LungsAnimationMain();
    // return ExpanderFabMenu();
    // return PageIndicatorMain();
  }
}
