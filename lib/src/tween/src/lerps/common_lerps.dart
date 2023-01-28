part of gtween;

class GTweenLerpColor extends GTweenLerpProp<Color?> {
  GTweenLerpColor({
    super.setProp,
    super.getProp,
  });

  @override
  Color? resolve(double ratio) {
    final value = Color.lerp(from, to, ratio);
    setProp?.call(value);
    return value;
  }
}
