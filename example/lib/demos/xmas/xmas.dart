/// roipeker 2020
///
/// Snowflake effect
/// video: https://media.giphy.com/media/yTNXKR5BHbQKOKpfrS/source.mp4
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'xmas_scene.dart';

class XmasMain extends StatefulWidget {
  XmasMain({Key? key}) : super(key: key);

  @override
  _XmasMainState createState() => _XmasMainState();
}

class _XmasMainState extends State<XmasMain> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    trace('rebuild!');
    Widget child = SceneBuilderWidget(
      builder: () => SceneController(
        back: SnowScene(),
        config: SceneConfig.autoRender,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(.7),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(.7),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2373A1).withOpacity(.6),
        title: Text('graphx xmas'),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.red.shade700.withOpacity(.35),
              BlendMode.darken,
            ),
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/xmas/xmas_bg.jpg',
            ),
          ),
        ),
        child: child,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff9896AE),
        onPressed: () {
          trace('OK PRESSED!');
          _incrementCounter();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
