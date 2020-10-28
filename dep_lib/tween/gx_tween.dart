import 'dart:ui';

import 'package:graphx/graphx/tween/tween_sequence.dart';
import 'package:graphx/graphx/tween/tween_step.dart';
import 'package:graphx/graphx/tween/tween_timeline.dart';

class GxTween {
  static bool enablePooling = false;
  static double timeScale = 1.0;

  static TweenTimeline $currentTimeline;
  static List<TweenTimeline> $timelines;

  static void addTimeline(TweenTimeline timeline, [bool setCurrent = false]) {
    if (setCurrent) $currentTimeline = timeline;
    $timelines ??= <TweenTimeline>[];
    $timelines.add(timeline);
  }

  static TweenStep create(dynamic target, [bool autorun = true]) {
    TweenSequence seq = TweenSequence.getPoolInstance();
    if ($currentTimeline == null) {
      addTimeline(TweenTimeline(), true);
    }
    $currentTimeline.addSequence(seq);
    var step = seq.addStep(TweenStep.getPoolInstance());
    // print("Sequence is $seq // step is $step");
    if (target is String) {
      step.targetId = target;
    } else {
      step.$target = target;
    }
    if (autorun) {
      seq.run();
    }
    return step;
  }

  static TweenStep delay(double time, VoidCallback callback, [List args]) {
    var step = create(null);
    print("Created step: $step");
    step = step.delay(time).onComplete(callback);
    return step;
  }

  static void update(double delta) {
    delta *= timeScale;
    if ($timelines == null) return;
    for (var timeline in $timelines) {
      timeline.update(delta);
    }
    print("${$timelines.length}");
  }

  static void abortAllTimelines() {
    if ($timelines == null) return;
    while ($timelines.length > 0) {
      $timelines.removeAt(0)?.abortAllSequences();
    }
    $currentTimeline = null;
  }

//  static createDouble(target, [bool autoRun = true]) {}
}
