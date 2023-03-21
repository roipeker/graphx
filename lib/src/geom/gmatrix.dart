import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'geom.dart';

/// Represents a 2D affine transformation matrix that can be used to manipulate
/// graphical elements, such as lines, rectangles, paths, and bitmaps.
///
/// The GMatrix class provides various methods for performing common matrix
/// operations such as concatenation, inversion, scaling, rotation, and
/// translation. It also provides methods for converting between matrices and
/// other formats, such as points, rectangles, and lists.
///
/// The GMatrix class has six fields that define the properties of the matrix:
///
/// * [a], [b], [c], [d]: These fields represent the six elements of the 3x3
/// transformation matrix in the order: [a b 0 c d 0 0 0 1].
///
/// * [tx] and [ty]: These fields define the translation vector.
class GMatrix {
  /// The value that affects the positioning of pixels along the x axis when
  /// scaling or rotating an image.
  double a = 0.0;

  /// The value that affects the positioning of pixels along the y axis when
  /// rotating or skewing an image.
  double b = 0.0;

  /// The value that affects the positioning of pixels along the x axis when
  /// rotating or skewing an image.
  double c = 0.0;

  /// The value that affects the positioning of pixels along the y axis when
  /// scaling or rotating an image.
  double d = 0.0;

  /// The distance by which to translate each point along the x axis.
  double tx = 0.0;

  /// The distance by which to translate each point along the y axis.
  double ty = 0.0;

  /// Matrix for native use in Flutter.
  final Matrix4 _native = Matrix4.identity();

  /// Constructor with optional parameters for all matrix values.
  GMatrix([
    this.a = 1,
    this.b = 0,
    this.c = 0,
    this.d = 1,
    this.tx = 0,
    this.ty = 0,
  ]);

  /// Creates a new [GMatrix] object from a list of 6 doubles.
  ///
  /// The list is in the format [a, b, tx, c, d, ty], where:
  ///
  /// - [a] is the scale factor x of the horizontal axis.
  /// - [b] is the shear factor x of the vertical axis.
  /// - [tx] is the translation offset x of the horizontal axis.
  /// - [c] is the shear factor y of the horizontal axis.
  /// - [d] is the scale factor y of the vertical axis.
  /// - [ty] is the translation offset y of the vertical axis.
  ///
  /// The matrix elements are numbered as follows:
  ///
  ///     [ a  c  tx ]
  ///     [ b  d  ty ]
  ///     [ 0  0  1  ]
  ///
  /// Throws a [RangeError] if [value] does not have at least 6 elements.
  GMatrix.fromList(List<double> value) {
    if (value.length < 6) {
      throw RangeError('List must have at least 6 elements');
    }
    a = value[0];
    b = value[1];
    c = value[3];
    d = value[4];
    tx = value[2];
    ty = value[5];
  }

  /// Multiplies this matrix by another matrix, concatenating the two matrices.
  ///
  /// The resulting matrix combines the geometric effects of the two original
  /// matrices. In mathematical terms, if matrix A scales, rotates, and
  /// translates geometric object P, and matrix B scales, rotates, and
  /// translates geometric object Q, then the combined matrix C = A * B
  /// scales, rotates, and translates P and Q.
  ///
  /// Returns this matrix after the concatenation for easy chaining
  GMatrix append(GMatrix matrix) {
    final a1 = a;
    final b1 = b;
    final c1 = c;
    final d1 = d;
    a = (matrix.a * a1) + (matrix.b * c1);
    b = (matrix.a * b1) + (matrix.b * d1);
    c = (matrix.c * a1) + (matrix.d * c1);
    d = (matrix.c * b1) + (matrix.d * d1);

    tx = (matrix.tx * a1) + (matrix.ty * c1) + tx;
    ty = (matrix.tx * b1) + (matrix.ty * d1) + ty;

    return this;
  }

  /// Creates a new instance of [GMatrix] with the same values as the current
  /// instance, and returns it.
  GMatrix clone() {
    return GMatrix(
      a,
      b,
      c,
      d,
      tx,
      ty,
    );
  }

  /// Concatenates the given [matrix] with this matrix by multiplying the two
  /// matrices together. This matrix is on the right-hand side and the given
  /// matrix is on the left-hand side. Returns the current matrix for chaining.
  GMatrix concat(GMatrix matrix) {
    double a1, c1, tx1;
    a1 = a * matrix.a + b * matrix.c;
    b = a * matrix.b + b * matrix.d;
    a = a1;

    c1 = c * matrix.a + d * matrix.c;
    d = c * matrix.b + d * matrix.d;
    c = c1;

    tx1 = tx * matrix.a + ty * matrix.c + matrix.tx;
    ty = tx * matrix.b + ty * matrix.d + matrix.ty;
    tx = tx1;
    return this;
  }

  /// Copies all of the matrix data from the source matrix into this matrix.
  GMatrix copyFrom(GMatrix source) {
    a = source.a;
    b = source.b;
    c = source.c;
    d = source.d;
    tx = source.tx;
    ty = source.ty;
    return this;
  }

  /// Given a point in the pre-transformed coordinate space, returns the
  /// coordinates of that point after the transformation occurs. Unlike the
  /// standard transformation applied using the `transformPoint()` method, the
  /// `deltaTransformPoint()` method's transformation does not consider the
  /// translation parameters `tx` and `ty`.
  ///
  /// The [point] for which you want to get the result of the matrix
  /// transformation.
  ///
  /// Returns the point resulting from applying the matrix transformation.
  GPoint deltaTransformPoint(GPoint point, [GPoint? out]) {
    out ??= GPoint();
    return out.setTo(point.x * a + point.y * c, point.x * b + point.y * d);
  }

  /// Sets each matrix property to a value that causes a null transformation. An
  /// object transformed by applying an identity matrix will be identical to the
  /// original.
  ///
  /// After calling the identity() method, the resulting matrix has the
  /// following properties: a=1, b=0, c=0, d=1, tx=0, ty=0.
  ///
  /// Returns itself for chaining.
  GMatrix identity() {
    a = 1;
    b = 0;
    c = 0;
    d = 1;
    tx = 0;
    ty = 0;
    return this;
  }

  /// Inverts this matrix, i.e. applies a matrix transformation that is the
  /// opposite of the original one.
  ///
  /// If the matrix is not invertible (i.e. its determinant is 0), this method
  /// sets the values of the matrix to a non-invertible state and returns
  /// itself.
  ///
  /// Returns this matrix instance after inverting it for easy chaining.
  GMatrix invert() {
    var n = a * d - b * c;
    if (n == 0) {
      a = b = c = d = 0;
      tx = -tx;
      ty = -ty;
    } else {
      n = 1 / n;
      var a1 = d * n;
      d = a * n;
      a = a1;
      b *= -n;
      c *= -n;
      var tx1 = -a * tx - c * ty;
      ty = -b * tx - d * ty;
      tx = tx1;
    }
    return this;
  }

  /// Applies a rotation transformation to this matrix object.
  void rotate(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);

    var a1 = a * cos - b * sin;
    b = a * sin + b * cos;
    a = a1;

    var c1 = c * cos - d * sin;
    d = c * sin + d * cos;
    c = c1;

    var tx1 = tx * cos - ty * sin;
    ty = tx * sin + ty * cos;
    tx = tx1;
  }

  /// Applies a scaling transformation to this matrix.
  GMatrix scale(double scaleX, [double? scaleY]) {
    scaleY ??= scaleX;
    a *= scaleX;
    b *= scaleY;
    c *= scaleX;
    d *= scaleY;
    tx *= scaleX;
    ty *= scaleY;
    return this;
  }

  /// Sets the members of this matrix to the specified values.
  GMatrix setTo(double a, double b, double c, double d, double tx, double ty) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.tx = tx;
    this.ty = ty;
    return this;
  }

  /// Utility function that calculates directly the transformation for a
  /// DisplayObject.
  GMatrix setTransform(
    double x,
    double y,
    double pivotX,
    double pivotY,
    double scaleX,
    double scaleY,
    double skewX,
    double skewY,
    double rotation,
  ) {
    a = math.cos(rotation + skewY) * scaleX;
    b = math.sin(rotation + skewY) * scaleX;
    c = -math.sin(rotation - skewX) * scaleY;
    d = math.cos(rotation - skewX) * scaleY;
    tx = x - ((pivotX * a) + (pivotY * c));
    ty = y - ((pivotX * b) + (pivotY * d));
    return this;
  }

  /// Applies a skew transformation (in radians) to the matrix.
  void skew(double skewX, double skewY) {
    var sinX = math.sin(skewX);
    var cosX = math.cos(skewX);
    var sinY = math.sin(skewY);
    var cosY = math.cos(skewY);
    setTo(
      a * cosY - b * sinX,
      a * sinY + b * cosX,
      c * cosY - d * sinX,
      c * sinY + d * cosX,
      tx * cosY - ty * sinX,
      tx * sinY + ty * cosX,
    );
  }

  /// Returns a native Matrix4 instance based on this [GMatrix] a,b,c,d,tx,ty
  Matrix4 toNative() {
    _native.setValues(a, b, 0, 0, c, d, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1);
    return _native;
  }

  /// Returns a text value listing the properties of this matrix object.
  @override
  String toString() {
    return 'GMatrix {a: $a, b: $b, c: $c, d: $d, tx: $tx, ty: $ty}';
  }

  /// Transforms the given point (x,y) using this matrix and stores the result
  /// in the [out] point or a new [GPoint] instance if [out] is not provided.
  ///
  /// The transformed point will be:
  /// `(x', y') = (a * x + c * y + tx, d * y + b * x + ty)`
  /// where (x,y) are the original coordinates, and (x', y') are the transformed
  /// coordinates.
  ///
  /// If the optional [out] argument is provided, it will be modified to contain
  /// the transformed point, otherwise a new [GPoint] will be returned.
  GPoint transformCoords(double x, double y, [GPoint? out]) {
    out ??= GPoint();
    out.x = a * x + c * y + tx;
    out.y = d * y + b * x + ty;
    return out;
  }

  /// Transforms the given coordinates [x] and [y] from the global coordinate
  /// space to the local coordinate space of this matrix. The transformed
  /// coordinates are stored in the [out] point object if provided, or a new
  /// [GPoint] object is created and returned. The original point object is not
  /// modified.
  ///
  /// To transform a point from the local coordinate space of this matrix to
  /// the global coordinate space, use [transformPoint].
  ///
  /// If the [out] parameter is null, a new [GPoint] object is created and
  /// returned with the transformed coordinates. Otherwise, the transformed
  /// coordinates are stored in the [out] object and returned.
  GPoint transformInverseCoords(double x, double y, [GPoint? out]) {
    out ??= GPoint();
    final id = 1 / ((a * d) + (c * -b));
    out.x = (d * id * x) + (-c * id * y) + (((ty * c) - (tx * d)) * id);
    out.y = (a * id * y) + (-b * id * x) + (((-ty * a) + (tx * b)) * id);
    return out;
  }

  /// Transforms a [GPoint] object using the inverse of this [GMatrix] object
  /// and returns a new [GPoint] object containing the transformed point.
  ///
  /// If an [out] [GPoint] object is provided, the result will be stored in it
  /// instead of creating a new object.
  ///
  /// The transformed coordinates are calculated using the inverse of the matrix
  /// and the given [point] coordinates. The result is then stored in the [out]
  /// [GPoint] object and returned.
  GPoint transformInversePoint(GPoint point, [GPoint? out]) {
    return transformInverseCoords(point.x, point.y, out);
  }

  /// Returns the result of applying the geometric transformation
  /// represented by the Matrix object to the specified point.
  GPoint transformPoint(GPoint point, [GPoint? out]) {
    return transformCoords(point.x, point.y, out);
  }

  /// Translates the matrix along the x and y axes, as specified by the [dx] and
  /// [dy] parameters.
  GMatrix translate(double dx, double dy) {
    tx += dx;
    ty += dy;
    return this;
  }

  /// Simple utility to zoom by [zoomFactor] around the point [center] that
  /// returns the new matrix.
  GMatrix zoomAroundPoint(GPoint center, double zoomFactor) {
    var t1 = GMatrix();
    t1.translate(-center.x, -center.y);
    var sc = GMatrix();
    sc.scale(zoomFactor, zoomFactor);
    var t2 = GMatrix();
    t2.translate(center.x, center.y);
    var zoom = GMatrix();
    zoom.concat(t1).concat(sc).concat(t2);
    return concat(zoom);
  }

  /// Creates a new [GMatrix] object based on the [Matrix4] counterpart.
  static GMatrix fromNative(Matrix4 m) {
    return GMatrix(
      m.storage[0],
      m.storage[4],
      m.storage[1],
      m.storage[5],
      m.storage[12],
      m.storage[13],
    );
  }
}
