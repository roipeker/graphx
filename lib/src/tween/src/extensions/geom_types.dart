part of gtween;

extension GTweenPointExt on GPoint {
  GTweenablePoint get twn => GTweenablePoint(this);
}

extension GTweenRectExt on GRect {
  GTweenableRect get twn => GTweenableRect(this);
}

extension GTweenColorExt on Color {
  GTweenableColor get twn => GTweenableColor(this);
}
