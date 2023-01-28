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
    "SimpleShapesMain": const SimpleShapesMain(),
    "SimpleTweenMain": SimpleTweenMain(),
    "DemoSvgIconsMain": const DemoSvgIconsMain(),
    "SimpleInteractionsMain": const SimpleInteractionsMain(),
    "GraphicsClipperDemo": const GraphicsClipperDemo(),
    "FacebookReactionsMain": FacebookReactionsMain(),
    "DrippingIVMain": const DrippingIVMain(),
    "ChartMountainMain": const ChartMountainMain(),
    "GlowingCircleMain": const GlowingCircleMain(),
    "SortingButtonMain": const SortingButtonMain(),
    "BookmarkButtonMain": const BookmarkButtonMain(),
    "SubmitButtonMain": const SubmitButtonMain(),
    "CardRotation3dMain": const CardRotation3dMain(),
    "RasterDrawMain": const RasterDrawMain(),
    "DialerMain": const DialerMain(),
    "GaugeMeterMain": const GaugeMeterMain(),
    "SpiralLoaderMain": const SpiralLoaderMain(),
    "UniversoFlutterIntroMain": const UniversoFlutterIntroMain(),
    "ColorfulLoaderMain": const ColorfulLoaderMain(),
    "JellyThingMain": const JellyThingMain(),
    "BallVsLineMain": const BallVsLineMain(),
    "Dna3dMain": const Dna3dMain(),
    "SplashIntroMain": const SplashIntroMain(),
    "LinedButtonMain": const LinedButtonMain(),
    "ColorPickerMain": const ColorPickerMain(),
    "AltitudeIndicatorMain": const AltitudeIndicatorMain(),
    "BreakoutMain": const BreakoutMain(),
    "XmasMain": const XmasMain(),
    "SimpleRadialMenuMain": const SimpleRadialMenuMain(),
    "MuratCoffeeMain": const MuratCoffeeMain(),
    "PieChartMain": const PieChartMain(),
    "ChartBezierMain": const ChartBezierMain(),
    "RunHeroCanvasMain": const RunHeroCanvasMain(),
    "ElasticBandMain": const ElasticBandMain(),
    "FlowerGradientMain": const FlowerGradientMain(),
    "NokiaSnakeMain": const NokiaSnakeMain(),
    "HeartReactionMain": HeartReactionMain(),
    "SimpleToastMain": const SimpleToastMain(),
    "RatingStarsMain": const RatingStarsMain(),
    "PizzaBoxMain": const PizzaBoxMain(),
    "DrawingPadBezierMain": const DrawingPadBezierMain(),
    "IsmaChartMain": const IsmaChartMain(),
    "TriGridMain": const TriGridMain(),
    "NicoLoadingIndicatorMain": const NicoLoadingIndicatorMain(),
    "FeelingSwitchMain": const FeelingSwitchMain(),
    "MouseRepulsionMain": const MouseRepulsionMain(),
    "Globe3dMain": const Globe3dMain(),
    "LungsAnimationMain": const LungsAnimationMain(),
    "ExpanderFabMenu": const ExpanderFabMenu(),
    "PageIndicatorMain": const PageIndicatorMain()
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
          onGenerateRoute: (settings) => MaterialPageRoute(builder: (context) => child),
        ),
      ),
    );
  }
}
