import '../../graphx.dart';

/// Extension methods to simplify the modification of [GDisplayObject]
/// properties.
extension DisplayObjectHelpers on GDisplayObject {
  /// Centers the object in the middle of the [Stage] if it's added to the
  /// stage.
  void centerInStage() {
    if (!inStage) {
      return;
    }
    setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
  }
}
