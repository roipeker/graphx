import 'package:exampleGraphx/utils/utils.dart';
/// roipeker 2021

/// just wrap ur app with this, to emit "global" events (and close the dropdown)
///return SceneBuilderWidget(
///      builder: () => SceneController(front: RootScene()),
///      child: MaterialApp(
///        home: Scaffold(
import 'package:graphx/graphx.dart';

class RootWidget extends StatelessWidget {
  final Widget child;
  const RootWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SceneBuilderWidget(
      builder: () => SceneController(front: RootScene()),
      child: child,
    );
  }
}

class RootScene extends GSprite {
  @override
  void dispose() {
    stage?.onMouseDown?.removeAll();
    mps.offAll('windowMouseDown');
    super.dispose();
  }

  @override
  void addedToStage() {
    stage.onMouseDown.add((event) {
      mps.emit1('windowMouseDown', event.rawEvent.windowPosition);
    });
  }
}
