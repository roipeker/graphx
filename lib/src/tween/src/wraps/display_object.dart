part of gtween;

class GTweenableDisplayObject with GTweenable {
  static GTweenable? wrap(Object? target) {
    if (target is! GDisplayObject) return null;
    return GTweenableDisplayObject(target);
  }

  GTweenableDisplayObject(GDisplayObject target) {
    this.target = target;

    _addLerp(
      'colorize',
      GTweenLerpColor(
        setProp: (value) => target.colorize = value,
        getProp: () => target.colorize,
      ),
    );
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() =>
      CommonTweenWraps.displayObject(target as GDisplayObject?);
}
