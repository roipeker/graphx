typedef TweenEase = double Function(double value);

abstract class TweenInterp {
  double duration;
  bool complete;
  String property;
  TweenEase ease;
  double from;

  void update(double delta);
  void setValue(double value);
  dynamic getFinalValue();
  void reset();
}
