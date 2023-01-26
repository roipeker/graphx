import 'dart:math' as math;
import 'dart:ui';

import 'geom.dart';

class GRect {

  // Creates a new GRect object based on the Rect counterpart.
  static GRect fromNative(Rect nativeRect) => GRect(
      nativeRect.left, nativeRect.top, nativeRect.width, nativeRect.height);

  // Builds and returns a string that lists the horizontal and vertical
  // positions and the width and height of the Rectangle object.
  @override
  String toString() => 'GRect {x: $x, y: $y, w: $width, h: $height}';

  // Returns a Rect instance based on this GRect x,y,width,height
  Rect toNative() {
    return Rect.fromLTWH(x, y, width, height);
  }

  double x = 0.0, y = 0.0, width = 0.0, height = 0.0;

  // Returns the sum of the y and height properties.
  double get bottom => y + height;

  // Sets the height based on value minus y.
  set bottom(double value) => height = value - y;

  // The x coordinate of the top-left corner of the rectangle.
  double get left => x;

  // Sets the x coordinate of the top-left corner of the rectangle.
  // and adjusts the width accordingly.
  set left(double value) {
    width -= value - x;
    x = value;
  }

  // The sum of the x and width properties.
  double get right => x + width;

  // Sets the width based on the value minus the x property.
  set right(double value) {
    width = value - x;
  }

  // The y coordinate of the top-left corner of the rectangle.
  double get top => y;

  // Sets the y coordinate of the top-left corner of the rectangle.
  set top(double value) {
    height -= value - y;
    y = value;
  }

  // Creates a new GRect object with the top-left corner specified by the x and y parameters and with the specified width and height parameters.
  GRect([this.x = 0.0, this.y = 0.0, this.width = 0.0, this.height = 0.0]);

  // Sets the members of GRect to the specified values
  GRect setTo(double x, double y, double width, double height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    return this;
  }

  static List<GPoint>? _sHelperPositions;
  static final _sHelperPoint = GPoint();

  GRect getBounds(GMatrix matrix, [GRect? out]) {
    out ??= GRect();
    var minX = 10000000.0;
    var maxX = -10000000.0;
    var minY = 10000000.0;
    var maxY = -10000000.0;
    final positions = getPositions(_sHelperPositions);
    for (var point in positions) {
      matrix.transformCoords(point.x, point.y, _sHelperPoint);
      if (minX > _sHelperPoint.x) minX = _sHelperPoint.x;
      if (maxX < _sHelperPoint.x) maxX = _sHelperPoint.x;
      if (minY > _sHelperPoint.y) minY = _sHelperPoint.y;
      if (maxY < _sHelperPoint.y) maxY = _sHelperPoint.y;
    }
    return out.setTo(minX, minY, maxX - minX, maxY - minY);
  }

  List<GPoint> getPositions([List<GPoint>? out]) {
    out ??= List.generate(4, (i) => GPoint());
    out[2].x = out[0].x = left;
    out[1].y = out[0].y = top;
    out[3].x = out[1].x = right;
    out[3].y = out[2].y = bottom;
    return out;
  }

  // Returns a new GRect object with the same values for the
  // x, y, width, and height properties as the original GRect object.
  GRect clone() => GRect(x, y, width, height);

  // Copies all of rectangle data from the source GRect object into
  // the calling GRect object.
  GRect copyFrom(GRect other) {
    return setTo(other.x, other.y, other.width, other.height);
  }

  // If the GRect object specified in the `rect` parameter intersects
  // with this GRect object, returns the area of intersection
  // as a GRect object.
  GRect intersection(GRect rect) {
    GRect result;
    var x0 = x < rect.x ? rect.x : 0.0;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 <= 0) {
      result = GRect();
    } else {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 <= y0) {
        result = GRect();
      } else {
        result = GRect(x0, y0, x1 - x0, y1 - y0);
      }
    }
    return result;
  }

  // Determines whether the object specified in the `rect` parameter
  // intersects with this GRect object.
  bool intersects(GRect rect) {
    var x0 = x < rect.x ? rect.x : x;
    var x1 = right > rect.right ? rect.right : right;
    if (x1 > x0) {
      var y0 = y < rect.y ? rect.y : y;
      var y1 = bottom > rect.bottom ? rect.bottom : bottom;
      if (y1 > y0) return true;
    }
    return false;
  }

  /// Like AS3 Rectangle::union
  /// Adds two rectangles together to create a new GRect object,
  /// by filling in the horizontal and vertical space
  /// between the two rectangles.
  GRect expandToInclude(GRect other) {
    var r = right;
    var b = bottom;
    x = math.min(left, other.left);
    y = math.min(top, other.top);
    right = math.max(r, other.right);
    bottom = math.max(b, other.bottom);
    return this;
  }

  // Adjusts the location of the GRect object,
  // as determined by its top-left corner, by the specified amounts.
  GRect offset(double dx, double dy) {
    x += dx;
    y += dy;
    return this;
  }

  // Adjusts the location of the GRect object using a
  // GPoint object as a parameter.
  GRect offsetPoint(GPoint point) {
    x += point.x;
    y += point.y;
    return this;
  }

  // Increases the size of the GRect object by the specified amounts, in pixels.
  GRect inflate(double dx, double dy) {
    x -= dx;
    y -= dy;
    width += dx * 2;
    height += dy * 2;
    return this;
  }

  // Sets all of the GRect object's properties to 0.
  GRect setEmpty() {
    return setTo(0, 0, 0, 0);
  }

  // Determines whether or not this GRect object is empty.
  bool get isEmpty => width <= 0 || height <= 0;

  // Determines whether the specified coordinate is contained within the
  // rectangular region defined by this GRect object.
  bool contains(double x, double y) =>
      x >= this.x && y >= this.y && x < right && y < bottom;

  // Determines whether the specified GPoint is contained within the
  // rectangular region defined by this GRect object.
  bool containsPoint(GPoint point) =>
      point.x >= x && point.y >= y && point.x < right && point.y < bottom;

  GRect operator *(double scale) {
    x *= scale;
    y *= scale;
    width *= scale;
    height *= scale;
    return this;
  }

  GRect operator /(double scale) {
    x /= scale;
    y /= scale;
    width /= scale;
    height /= scale;
    return this;
  }

  /// --- Round Rect implementation ---
  GxRectCornerRadius? _corners;

  bool get hasCorners => _corners?.isNotEmpty ?? false;

  GxRectCornerRadius? get corners {
    _corners ??= GxRectCornerRadius();
    return _corners;
  }

  set corners(GxRectCornerRadius? value) => _corners = value;

  RRect toRoundNative() => corners!.toNative(this);

  /// Creates a GxRect from a `RRect` assigning the `GxRectCornerRadius`
  /// properties from the tr, tl, br, bl radiusX axis.
  static GRect fromRoundNative(RRect nativeRect) {
    return GRect(
      nativeRect.left,
      nativeRect.top,
      nativeRect.width,
      nativeRect.height,
    )..corners!.setTo(
        nativeRect.tlRadiusX,
        nativeRect.trRadiusX,
        nativeRect.brRadiusX,
        nativeRect.blRadiusX,
      );
  }
}

class GxRectCornerRadius {
  double topLeft, topRight, bottomRight, bottomLeft;

  GxRectCornerRadius([
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomRight = 0,
    this.bottomLeft = 0,
  ]);

  void setTo([
    double topLeft = 0,
    double topRight = 0,
    double bottomRight = 0,
    double bottomLeft = 0,
  ]) {
    this.topLeft = topLeft;
    this.topRight = topRight;
    this.bottomLeft = bottomLeft;
    this.bottomRight = bottomRight;
  }

  void setTopBottom(double top, double bottom) {
    topLeft = topRight = top;
    bottomLeft = bottomRight = bottom;
  }

  void setLeftRight(double left, double right) {
    topLeft = bottomLeft = left;
    topRight = bottomRight = right;
  }

  void allTo(double radius) =>
      topLeft = topRight = bottomLeft = bottomRight = radius;

  bool get isNotEmpty =>
      topLeft != 0 || topRight != 0 || bottomLeft != 0 || bottomRight != 0;

  RRect toNative(GRect rect) {
    final tl = topLeft == 0 ? Radius.zero : Radius.circular(topLeft);
    final tr = topRight == 0 ? Radius.zero : Radius.circular(topRight);
    final br = bottomRight == 0 ? Radius.zero : Radius.circular(bottomRight);
    final bl = bottomLeft == 0 ? Radius.zero : Radius.circular(bottomLeft);
    return RRect.fromLTRBAndCorners(
      rect.left,
      rect.top,
      rect.right,
      rect.bottom,
      topLeft: tl,
      topRight: tr,
      bottomLeft: bl,
      bottomRight: br,
    );
  }
}
