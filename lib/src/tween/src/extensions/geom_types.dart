part of gtween;

extension GTweenPointExt on GxPoint {
  GTweenablePoint get twn => GTweenablePoint(this);
}

extension GTweenRectExt on GxRect {
  GTweenableRect get twn => GTweenableRect(this);
}

extension GTweenColorExt on Color {
  GTweenableColor get twn => GTweenableColor(this);
}
