import 'dart:math' as math;
import 'dart:ui';

import 'geom.dart';

/// A [GRect] represents a rectangular area in 2D space, with a position (x, y)
/// and a size (width, height).
class GRect {
  /// List of points used to hold the four corners of the [GRect].
  static List<GPoint>? _sHelperPositions;

  /// Object used to hold temporary transformed points during the [getBounds]
  static final _sHelperPoint = GPoint();

  /// The x position of the top-left corner of the rectangle.
  double x = 0.0;

  /// The y position of the top-left corner of the rectangle.
  double y = 0.0;

  /// The width of the rectangle.
  double width = 0.0;

  /// The height of the rectangle.
  double height = 0.0;

  /// Represents the corner radius values of a [GRect].
  GxRectCornerRadius? _corners;

  /// Creates a new GRect object with the top-left corner specified by the x and
  /// y parameters and with the specified width and height parameters.
  GRect([this.x = 0.0, this.y = 0.0, this.width = 0.0, this.height = 0.0]);

  /// Returns the y-coordinate of the bottom edge of the rectangle.
  double get bottom {
    return y + height;
  }

  /// Sets the [height] based on [value] minus y.
  set bottom(double value) {
    height = value - y;
  }

  /// Returns the [GxRectCornerRadius] instance that describes the corner radii
  /// of this [GRect].
  GxRectCornerRadius? get corners {
    _corners ??= GxRectCornerRadius();
    return _corners;
  }

  /// Sets the [GxRectCornerRadius] instance that describes the corner radii of
  /// this [GRect].
  set corners(GxRectCornerRadius? value) {
    _corners = value;
  }

  /// Returns true if [GRect] has custom corners.
  /// Used for Rectangles with rounded corners.
  bool get hasCorners {
    return _corners?.isNotEmpty ?? false;
  }

  /// Determines whether or not this GRect object is empty.
  bool get isEmpty {
    return width <= 0 || height <= 0;
  }

  /// The x coordinate of the top-left corner of the rectangle.
  double get left {
    return x;
  }

  /// Sets the x coordinate of the top-left corner of the rectangle.
  /// and adjusts the width accordingly.
  set left(double value) {
    width -= value - x;
    x = value;
  }

  /// The sum of the [x] and [width] properties.
  double get right {
    return x + width;
  }

  /// Sets the [width] based on the [value] minus the x property.
  set right(double value) {
    width = value - x;
  }

  /// The [y] coordinate of the top-left corner of the rectangle.
  double get top {
    return y;
  }

  /// Sets the [y] coordinate of the top-left corner of the rectangle.
  set top(double value) {
    height -= value - y;
    y = value;
  }

  /// Scales the [GRect] object on x, y, width, height by the [scale] factor.
  GRect operator *(double scale) {
    x *= scale;
    y *= scale;
    width *= scale;
    height *= scale;
    return this;
  }

  /// Divides the [GRect] object on x, y, width, height by the [scale] factor.
  GRect operator /(double scale) {
    x /= scale;
    y /= scale;
    width /= scale;
    height /= scale;
    return this;
  }

  /// Returns a new [GRect] object with the same values for the
  /// x, y, width, and height properties as the original [GRect] object.
  GRect clone() {
    return GRect(x, y, width, height);
  }

  /// Determines whether the specified [x] and [y] coordinates are contained
  /// within the rectangular region defined by this [GRect] object.
  bool contains(double x, double y) {
    return x >= this.x && y >= this.y && x < right && y < bottom;
  }

  /// Determines whether the specified [GPoint] is contained within the
  /// rectangular region defined by this [GRect] object.
  bool containsPoint(GPoint point) {
    return point.x >= x && point.y >= y && point.x < right && point.y < bottom;
  }

  /// Determines whether the [rect] object is contained within this object. A
  /// Rectangle is said to contain another if the second Rectangle falls entirely
  /// within the boundaries of the first.
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

  /// Sets the properties of this [GRect] to be equal to those of the
  /// [sourceRect].
  ///
  /// Returns this [GRect] after the copy operation.
  GRect copyFrom(GRect sourceRect) {
    x = sourceRect.x;
    y = sourceRect.y;
    width = sourceRect.width;
    height = sourceRect.height;
    return this;
  }

  /// Determines whether [toCompare] parameter is equal to this object. This
  /// method compares the x, y, width, and height properties of an object
  /// against the same properties of this object.
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

  /// Similar to [GRect.union], adds [other] to this object to create a new
  /// [GRect] object, by filling in the horizontal and vertical space between
  /// the two rectangles.
  GRect expandToInclude(GRect other) {
    var r = right;
    var b = bottom;
    x = math.min(left, other.left);
    y = math.min(top, other.top);
    right = math.max(r, other.right);
    bottom = math.max(b, other.bottom);
    return this;
  }

  /// Returns the bounds of this [GRect] when transformed by the given [matrix],
  /// optionally storing the result in the given [out] parameter.
  ///
  /// The method first calculates the four corner points of the rectangle and
  /// then applies the matrix transformation to each of them. The bounding box
  /// of the transformed points is calculated and returned as the result.
  ///
  /// If the [out] parameter is not null, it is used to store the calculated
  /// result.
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

  /// Returns a list of four [GPoint] instances representing the positions of
  /// the top-left, top-right, bottom-right, and bottom-left corners of this
  /// [GRect].
  ///
  /// If an [out] list is provided, it will be used to store the four corner
  /// positions and returned. Otherwise, a new list will be generated.
  List<GPoint> getPositions([List<GPoint>? out]) {
    out ??= List.generate(4, (i) => GPoint());
    out[2].x = out[0].x = left;
    out[1].y = out[0].y = top;
    out[3].x = out[1].x = right;
    out[3].y = out[2].y = bottom;
    return out;
  }

  /// Increases the size of the [GRect] object by the specified amounts, in
  /// pixels. The center point of the Rectangle object stays the same, and its
  /// size increases to the left and right by the [dx] value, and to the top and
  /// the bottom by the [dy] value.
  GRect inflate(double dx, double dy) {
    x -= dx;
    y -= dy;
    width += dx * 2;
    height += dy * 2;
    return this;
  }

  /// Increases the size of the GRect object. This method is similar to the
  /// [GRect.inflate] method except it takes a [point] object as a parameter.
  GRect inflatePoint(GPoint point) {
    inflate(point.x, point.y);
    return this;
  }

  /// If the [GRect] object specified in the [toIntersect] parameter intersects
  /// with this [GRect] object, returns the area of intersection as a [GRect]
  /// object.
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

  /// Determines whether the object specified in the [rect] parameter
  /// intersects with this [GRect] object.
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

  /// Translates the rectangle's position by the specified [dx] and [dy] values.
  /// Determined by its top-left corner, by the specified amounts.
  GRect offset(double dx, double dy) {
    x += dx;
    y += dy;
    return this;
  }

  /// Offsets the rectangle's x and y values by the corresponding x and y values
  /// of the given [point].
  /// Returns this GRect after the offset is applied.
  GRect offsetPoint(GPoint point) {
    x += point.x;
    y += point.y;
    return this;
  }

  /// Sets the values of the GRect to (0,0,0,0) to make it an empty rectangle.
  /// Returns the modified GRect object.
  GRect setEmpty() {
    return setTo(0, 0, 0, 0);
  }

  /// Sets the x, y, width, and height values of this [GRect] instance to the
  /// specified values.
  ///
  /// Returns this instance after updating its properties.
  GRect setTo(double x, double y, double width, double height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    return this;
  }

  /// Returns a dart [Rect] instance based on this GRect x,y,width,height
  Rect toNative() {
    return Rect.fromLTWH(x, y, width, height);
  }

  /// Converts the [GRect] to a rounded native [RRect] using the corners
  /// specified in the [GCorner] class, or null for a rectangular [RRect], and
  /// returns the native [RRect] instance.
  RRect toRoundNative() {
    return corners!.toNative(this);
  }

  /// Builds and returns a string that lists the horizontal and vertical
  /// positions and the width and height of the Rectangle object.
  @override
  String toString() {
    return 'GRect {x: $x, y: $y, w: $width, h: $height}';
  }

  /// Adds two rectangles together to create a new GRect object, by
  /// filling in the horizontal and vertical space between the two
  /// rectangles.
  /// Note: The [union] method ignores rectangles with 0 as the
  /// height or width value, such as:
  /// `var rect2:Rectangle = new Rectangle(300,300,50,0);`
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

  /// Creates a new [GRect] object based on the [Rect] counterpart.
  static GRect fromNative(Rect nativeRect) {
    return GRect(
        nativeRect.left, nativeRect.top, nativeRect.width, nativeRect.height);
  }

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

/// Represents a set of corner radii for a rounded rectangle. This class is used
/// internally to build a rounded rectangle by specifying different radii for
/// each of its corners.
class GxRectCornerRadius {
  /// The radius of the top-left corner of the rectangle.
  double topLeft;

  /// The radius of the top-right corner of the rectangle.
  double topRight;

  /// The radius of the bottom-right corner of the rectangle.
  double bottomRight;

  /// The radius of the bottom-left corner of the rectangle.
  double bottomLeft;

  /// Creates a new [GxRectCornerRadius] instance.
  GxRectCornerRadius([
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomRight = 0,
    this.bottomLeft = 0,
  ]);

  /// Returns true if any of the corner radii are not equal to zero, false
  /// otherwise.
  bool get isNotEmpty {
    return topLeft != 0 || topRight != 0 || bottomLeft != 0 || bottomRight != 0;
  }

  /// Sets all the corner [radius] to the same value.
  void allTo(double radius) {
    topLeft = topRight = bottomLeft = bottomRight = radius;
  }

  /// Sets the radii for the [left] and [right] corners.
  void setLeftRight(double left, double right) {
    topLeft = bottomLeft = left;
    topRight = bottomRight = right;
  }

  /// Sets the radius for each of the corners individually.
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

  /// Sets the radii for the [top] and [bottom] corners.
  void setTopBottom(double top, double bottom) {
    topLeft = topRight = top;
    bottomLeft = bottomRight = bottom;
  }

  /// Returns a native Flutter [RRect] instance based on this
  /// [GxRectCornerRadius] instance.
  ///
  /// The [RRect] instance is built using the specified [GRect] instance as its
  /// bounding box and the corner radii for each of its corners.
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
