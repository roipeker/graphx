part of gtween;

class GTweenLerpColor extends GTweenLerpProp<Color?> {
  GTweenLerpColor({
    GTweenSetProp<Color?>? setProp,
    GTweenGetProp<Color?>? getProp,
  }) : super(
          setProp: setProp,
          getProp: getProp,
        );

  @override
  Color? resolve(double ratio) {
    final value = Color.lerp(from, to, ratio);
    setProp?.call(value);
    return value;
  }
}
