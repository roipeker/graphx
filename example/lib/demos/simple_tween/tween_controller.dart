import 'package:graphx/graphx.dart';

class TweenSceneController {
  final onRotate = Signal();
  final onScale = Signal();

  // direction can be -1, 1, or 0 (for center)
  final onTranslate = EventSignal<int>();
  final onAddCounter = Signal();

  void dispose() {
    onRotate.removeAll();
    onScale.removeAll();
    onTranslate.removeAll();
    onAddCounter.removeAll();
  }
}
