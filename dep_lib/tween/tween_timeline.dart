import 'package:graphx/graphx/tween/tween_sequence.dart';

class TweenTimeline {
  bool $dirty = false;
  List<TweenSequence> $sequences = [];

  TweenTimeline();

  void addSequence(TweenSequence sequence) {
    sequence.timeline = this;
    $sequences.add(sequence);
  }

  void removeSequence(TweenSequence sequence) {
    $sequences?.remove(sequence);
    sequence?.dispose();
  }

  void abortAllSequences() {
    while ($sequences.length > 0) {
      TweenSequence sequence = $sequences.removeAt(0);
      sequence?.dispose();
    }
  }

  void update(double delta) {
    int index = 0;
    int len = $sequences.length;
    print('updating timeline... $len');
    while (index < len) {
      $sequences[index]?.update(delta);
      ++index;
    }

    // if ($dirty) {
    //   index = $sequences.length;
    //   while (index >= 0) {
    //     TweenSequence sequence = $sequences[index];
    //     if (sequence.isComplete()) {
    //       removeSequence(sequence);
    //     }
    //   }
    //   $dirty = false;
    // }
  }
}
