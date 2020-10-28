import 'package:graphx/graphx/core/graphx.dart';

class JugglerDemoMain extends RootScene {
  @override
  void init() {
    owner.core.config.useTicker = true;
//    owner.core.config.useKeyboard = true;
//    owner.core.config.usePointer = true;
  }

  @override
  void ready() {
    super.ready();
    owner.core.resumeTicker();
    owner.needsRepaint = true;

    test();
  }

  var stopwatch = Stopwatch();
  void test() {
    print('execute in 5 seconds.');
    stopwatch.start();
    print("stopwatch time:: ${stopwatch.elapsedMilliseconds}");
    stage.juggler.delayedCall(
      () {
        print('Elapsed time: ${stage.juggler.elapsedTime}');
        print('llamado dps de 2sec! ${stopwatch.elapsedMilliseconds}');
        stopwatch.stop();
      },
      2,
    );
  }
}
