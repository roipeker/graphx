part of gtween;

class GTweenableDisplayObject with GTweenable {
  static GTweenable wrap(Object target) {
    if (target is! DisplayObject) return null;
    return GTweenableDisplayObject(target);
  }

  GTweenableDisplayObject(DisplayObject target) {
    this.target = target;

    _addLerp(
      'colorize',
      GTweenLerpColor(
        setProp: (Color value) => target.colorize = value,
        getProp: () => target.colorize,
      ),
    );
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() =>
      CommonTweenWraps.displayObject(target);
}
