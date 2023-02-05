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
  GRect copyFrom(GRect sourceRect) {
    x = sourceRect.x;
    y = sourceRect.y;
    width = sourceRect.width;
    height = sourceRect.height;
    return this;
  }

  // Determines whether the object specified in the `toCompare`
  // parameter is equal to this Rectangle object. This method compares the
  // `x`, `y`, `width`, and `height` properties of an object against the same
  // properties of this Rectangle object.
  bool equals(GRect? toCompare) {
    if (toCompare == this) {
      return true;
    } else {
      return toCompare != null &&
          x == toCompare.x &&
          y == toCompare.y &&
          width == toCompare.width &&
          height == toCompare.height;
    }
  }

  // If the GRect object specified in the `toIntersect` parameter intersects
  // with this GRect object, returns the area of intersection
  // as a GRect object.
  GRect intersection(GRect toIntersect) {
    late GRect result;
    var x0 = x < toIntersect.x ? toIntersect.x : 0.0;
    var x1 = right > toIntersect.right ? toIntersect.right : right;
    if (x1 <= 0) {
      result = GRect();
    } else {
      var y0 = y < toIntersect.y ? toIntersect.y : y;
      var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;
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

  // Adds two rectangles together to create a new GRect object, by
  // filling in the horizontal and vertical space between the two
  // rectangles.
  // Note: The `union()` method ignores rectangles with `0` as the
  // height or width value, such as:
  // `var rect2:Rectangle = new Rectangle(300,300,50,0);`
  GRect union(GRect toUnion) {
    if (width == 0 || height == 0) {
      return toUnion.clone();
    } else if (toUnion.width == 0 || toUnion.height == 0) {
      return clone();
    }
    final x0 = x > toUnion.x ? toUnion.x : x;
    final x1 = right < toUnion.right ? toUnion.right : right;
    final y0 = y > toUnion.y ? toUnion.y : y;
    final y1 = bottom < toUnion.bottom ? toUnion.bottom : bottom;
    return GRect(x0, y0, x1 - x0, y1 - y0);
  }

  /// Like GRect::union
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

  // Increases the size of the GRect object by the specified amounts,
  // in pixels. The center point of the Rectangle object stays the same,
  // and its size increases to the left and right by the `dx` value, and to
  // the top and the bottom by the `dy` value.
  GRect inflate(double dx, double dy) {
    x -= dx;
    y -= dy;
    width += dx * 2;
    height += dy * 2;
    return this;
  }

  // Increases the size of the GRect object. This method is similar to
  // the `GRect.inflate()` method except it takes a Point object as a
  // parameter.
  GRect inflatePoint(GPoint point) {
    inflate(point.x, point.y);
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

  // Determines whether the Rectangle object specified by the `rect`
  // parameter is contained within this Rectangle object. A Rectangle object is
  // said to contain another if the second Rectangle object falls entirely
  // within the boundaries of the first.
  bool containsRect(GRect rect) {
    if (rect.width <= 0 || rect.height <= 0) {
      return rect.x > x &&
          rect.y > y &&
          rect.right < right &&
          rect.bottom < bottom;
    } else {
      return rect.x >= x &&
          rect.y >= y &&
          rect.right <= right &&
          rect.bottom <= bottom;
    }
  }

  // Transform `input` GRect by `m` GMatrix.
  // Returns the transformed Rectangle.
  // static GRect transform(GRect input, GMatrix m, [GRect? output]) {
  //   output ??= GRect();
  //   var tx0 = m.a * input.x + m.c * input.y;
  //   var tx1 = tx0;
  //   var ty0 = m.b * input.x + m.d * input.y;
  //   var ty1 = ty0;
  //
  //   var tx = m.a * (input.x + input.width) + m.c * input.y;
  //   var ty = m.b * (input.x + input.width) + m.d * input.y;
  //
  //   if (tx < tx0) tx0 = tx;
  //   if (ty < ty0) ty0 = ty;
  //   if (tx > tx1) tx1 = tx;
  //   if (ty > ty1) ty1 = ty;
  //
  //   tx = m.a * (input.x + input.width) + m.c * (input.y + input.height);
  //   ty = m.b * (input.x + input.width) + m.d * (input.y + input.height);
  //
  //   if (tx < tx0) tx0 = tx;
  //   if (ty < ty0) ty0 = ty;
  //   if (tx > tx1) tx1 = tx;
  //   if (ty > ty1) ty1 = ty;
  //
  //   tx = m.a * input.x + m.c * (input.y + input.height);
  //   ty = m.b * input.x + m.d * (input.y + input.height);
  //
  //   if (tx < tx0) tx0 = tx;
  //   if (ty < ty0) ty0 = ty;
  //   if (tx > tx1) tx1 = tx;
  //   if (ty > ty1) ty1 = ty;
  //
  //   return output.setTo(tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
  // }

  // Scales the GRect object on x, y, width, height by the `scale` factor.
  GRect operator *(double scale) {
    x *= scale;
    y *= scale;
    width *= scale;
    height *= scale;
    return this;
  }

  // Divides the GRect object on x, y, width, height by the `scale` factor.
  GRect operator /(double scale) {
    x /= scale;
    y /= scale;
    width /= scale;
    height /= scale;
    return this;
  }

  /// --- Round Rect implementation ---
  GxRectCornerRadius? _corners;

  // Returns true if GRect has custom `corners`.
  // Used for RoundRects
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
