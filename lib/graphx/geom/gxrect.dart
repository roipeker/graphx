import 'dart:math' as math;
import 'dart:ui';

import 'package:graphx/graphx/geom/gxpoint.dart';

class GxRect {
  static GxRect fromNative(Rect nativeRect) {
    return GxRect(
        nativeRect.left, nativeRect.top, nativeRect.width, nativeRect.height);
  }

  Rect toNative() {
    return Rect.fromLTWH(x, y, width, height);
  }

  double x, y, width, height;

  double get bottom => y + height;

  set bottom(double value) => height = value - y;

  double get left => x;

  set left(double value) {
    width -= value - x;
    x = value;
  }

  double get right => x + width;

  set right(double value) {
    width = value - x;
  }

  double get top => y;

  set top(double value) {
    height -= value - y;
    y = value;
  }

  GxRect([this.x = 0, this.y = 0, this.width = 0, this.height = 0]);

  void setTo(double x, double y, double w, double h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }

  GxRect clone() => GxRect(x, y, width, height);

  GxRect intersection(GxRect rect) {
    GxRect result;
    var x0 = x < rect.x ? rect.x : 0;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 <= 0) {
      result = GxRect();
    } else {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 <= y0) {
        result = GxRect();
      } else {
        result = GxRect(x0, y0, x1 - x0, y1 - y0);
      }
    }
    return result;
  }

  bool intersects(GxRect rect) {
    var x0 = x < rect.x ? rect.x : x;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 > x0) {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 > y0) return true;
    }
    return false;
  }

  void expandToInclude(GxRect other) {
    x = math.min(left, other.left);
    y = math.min(top, other.top);
    width = math.max(right, other.right);
    height = math.max(bottom, other.bottom);
  }

  bool contains(double x, double y) =>
      x >= this.x && y >= this.y && x < right && y < bottom;

  bool containsPoint(GxPoint point) =>
      point.x >= this.x &&
      point.y >= this.y &&
      point.x < right &&
      point.y < bottom;

  GxRect operator *(double scale) {
    x *= scale;
    y *= scale;
    width *= scale;
    height *= scale;
    return this;
  }
}
