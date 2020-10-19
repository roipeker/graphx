import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class GxMatrix {
  double a, b, c, d, tx, ty;

  Matrix4 _native;

  Matrix4 toNative() {
    _native ??= Matrix4.identity();
    _native.setValues(a, c, 0, 0, b, d, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1);
    return _native;
  }

  static GxMatrix fromNative(Matrix4 m) {
    return GxMatrix(
      m.storage[0],
      m.storage[4],
      m.storage[1],
      m.storage[5],
      m.storage[12],
      m.storage[13],
    );
  }

  GxMatrix([
    this.a = 1,
    this.b = 0,
    this.c = 0,
    this.d = 1,
    this.tx = 0,
    this.ty = 0,
  ]);

  void copyFrom(GxMatrix from) {
    a = from.a;
    b = from.b;
    c = from.c;
    d = from.d;
    tx = from.tx;
    ty = from.ty;
  }

  void setTo(double a, double b, double c, double d, double tx, double ty) {
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.tx = tx;
    this.ty = ty;
  }

  void identity() {
    a = 1;
    b = 0;
    c = 0;
    d = 0;
    tx = 0;
    ty = 0;
  }

  void concat(GxMatrix matrix) {
    double a1 = a * matrix.a + b * matrix.c;
    b = a * matrix.b + b * matrix.d;
    a = a1;
    double c1 = c * matrix.a + d * matrix.c;
    d = c * matrix.b + d * matrix.d;
    c = c1;
    double tx1 = tx * matrix.a + ty * matrix.c + matrix.tx;
    ty = tx * matrix.b + ty * matrix.d + matrix.ty;
    tx = tx1;
  }

  GxMatrix invert() {
    double n = a * d - b * c;
    if (n == 0) {
      a = b = c = d = 0;
      tx = -tx;
      ty = -ty;
    } else {
      n = 1 / n;
      double a1 = d * n;
      d = a * n;
      a = a1;
      b *= -n;
      c *= -n;
      double tx1 = -a * tx - c * ty;
      ty = -b * tx - d * ty;
      tx = tx1;
    }
    return this;
  }

  void scale(double scaleX, [double scaleY]) {
    scaleY ??= scaleX;
    a *= scaleX;
    b *= scaleY;
    c *= scaleX;
    d *= scaleY;
    tx *= scaleX;
    ty *= scaleY;
  }

  void skew(double skewX, double skewY) {
    c = math.tan(skewX);
    b = math.tan(skewY);
  }

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

  void translate(double x, double y) {
    tx += x;
    ty += y;
  }
}
