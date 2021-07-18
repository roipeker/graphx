/// Ismail Alam Khan, 2020.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'toast.dart';

class SimpleToastMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(front: ToastScene()),
      child: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double? bottom;
  final tec = TextEditingController();

  void _incrementCounter() {
    mps.emit1<Map<String, dynamic>>(
      'showSnackBar',
      {
        'text': tec.text == '' ? 'No messege' : tec.text,
        'color': Colors.red,
        'bottomInset': MediaQuery.of(context).viewInsets.bottom,
        'onMouseClick': (MouseInputData event) =>
            tec.text = event.localX.toString(),
      },
    );
  }

  void sendKeyboardOpenEvent() {
    bottom = MediaQuery.of(context).viewInsets.bottom;
    mps.emit1<double>(
      'keyboardOpened',
      MediaQuery.of(context).viewInsets.bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    // sendKeyboardOpenEvent();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: tec,
                onChanged: (value) => sendKeyboardOpenEvent(),
              ),
            ),
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
    );
  }
}
