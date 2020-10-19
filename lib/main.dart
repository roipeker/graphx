import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphx/demos/test1.dart';
import 'package:graphx/graphx/graphx_widget.dart';
import 'package:graphx/graphx/scene_controller.dart';

import 'demos/test2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: MyHomeList(),
    );
  }
}

class MyHomeList extends StatefulWidget {
  @override
  _MyHomeListState createState() => _MyHomeListState();
}

class _MyHomeListState extends State<MyHomeList> {
//  final controller = SceneController.withLayers(
//    front: MyAvatarFront(),
//    back: MyAvatarBack(),
//  );

  bool _isDragging = false;

  Future<void> handleDragging(bool flag) async {
    _isDragging = flag;
//    print('PRE set state!');
//    await Future.delayed(Duration(milliseconds: 16));
    print('set state $_isDragging!');
    setState(() {});
//    SchedulerBinding.instance.addPostFrameCallback((e) {
//      setState(() {});
//    });
//    setState(() {});
  }

//  Ticker myTicker;
  int _scheduled;

  var _myScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
//    _myScrollController.
//    SchedulerBinding.instance.addPostFrameCallback(_onTick);
//        .scheduleWarmUpFrame(_onTick, rescheduling: false);
//    SchedulerBinding.instance.addPersistentFrameCallback(_onTick);
//    myTicker = Ticker(_onTick);
//    myTicker.start();
  }

  void _onTick(Duration d) {
    print("Ticker: $d --- _scheduled:$_scheduled");
//    SchedulerBinding.instance.addPersistentFrameCallback(_onTick);
//    _scheduled = SchedulerBinding.instance
//        .scheduleFrameCallback(_onTick, rescheduling: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphX mix with Flutter'),
      ),
      body: Container(
        child: IgnorePointer(
          ignoring: _isDragging,
          child: ListView.builder(
            dragStartBehavior: DragStartBehavior.start,
            physics:
                _isDragging ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            itemBuilder: (ctx, idx) {
              return ListTile(
                title: Text("Some cool title!"),
                subtitle: Text("Some subtitle"),
                leading: SceneBuilderWidget(
                  isPersistent: true,
//                builder: () => controller,
                  builder: () => SceneController.withLayers(
                    front: MyAvatarFront(handleDragging),
                    back: MyAvatarBack(),
                  ),
                  child: CircleAvatar(
                    child: Text("$idx"),
                  ),
                ),
                contentPadding: EdgeInsets.all(14),
              );
            },
            itemExtent: 90,
            padding: EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      useKeyboard: false,
      usePointer: true,
      builder: () => SceneController.withLayers(
//        back: MainBackScene(),
        front: Test2Scene(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
