import 'dart:developer' as dev;

/// The path is defined by a start value and a list of segments.
/// Each segment is a linear or a curve.
/// Each segment starts at the end of the previous segment.
/// You can add segments to the path using the
/// line, quadraticBezier, and cubicBezier methods.
/// Use [transform( ratio )] to get the value at a given ratio (0-1).
class CurvePath {
  late double start;
  final _segments = <Segment>[];
  int _pathLength = 0;
  double _totalStrength = 0.0;

  CurvePath(this.start);

  /// Get the path data as a list of numbers, to be stored
  /// or serialized.
  List<num> get path {
    final out = <num>[start];
    for (var seg in _segments) {
      if (seg is LinearSegment) {
        out.addAll([1, seg.end, seg.strength]);
      } else if (seg is QuadraticBezierSegment) {
        out.addAll([2, seg.end, seg.strength, seg.control]);
      } else if (seg is CubicBezierSegment) {
        out.addAll([3, seg.end, seg.strength, seg.control1, seg.control2]);
      } else {
        dev.log("Segment not implemented.");
      }
    }
    return out;
  }

  /// Sets the path data from a list of numbers.
  set path(List<num> value) {
    clear();
    start = value[0].toDouble();
    var i = 1;
    while (i < value.length) {
      switch (value[i]) {
        case 1:
          _addSegment(LinearSegment(value[i + 1] + .0, value[i + 2] + .0));
          i += 3;
          break;
        case 2:
          _addSegment(
            QuadraticBezierSegment(
              value[i + 1] + .0,
              value[i + 2] + .0,
              value[i + 3] + .0,
            ),
          );
          i += 4;
          break;
        case 3:
          _addSegment(
            CubicBezierSegment(value[i + 1] + .0, value[i + 2] + .0,
                value[i + 3] + .0, value[i + 4] + .0),
          );
          i += 5;
          break;
        default:
          dev.log("Segment not implemented.");
      }
    }
  }

  /// is the path empty?
  bool isConstant() => _pathLength == 0;

  void _addSegment(Segment segment) {
    _segments.add(segment);
    _pathLength++;
    _totalStrength += segment.strength;
  }

  /// Starts a path at the given position creating a line to [end].
  /// [strength] defines a multiplier for the segment weight, used
  /// in transform() when the segments are not equally distributed.
  static CurvePath createLine(double end, [double strength = 1]) =>
      CurvePath(0).line(end, strength);

  /// Adds a linear segment to the path.
  CurvePath line(double end, [double strength = 1]) {
    _addSegment(LinearSegment(end, strength));
    return this;
  }

  /// Adds a quadratic bezier segment to the path.
  CurvePath quadraticBezier(double end, double control, [double strength = 1]) {
    _addSegment(QuadraticBezierSegment(end, strength, control));
    return this;
  }

  /// Adds a cubic bezier segment to the path.
  CurvePath cubicBezier(double end, double control1, double control2,
      [double strength = 1]) {
    _addSegment(CubicBezierSegment(end, strength, control1, control2));
    return this;
  }

  /// Get the last value of the path
  double getEnd() =>
      (_pathLength > 0) ? _segments[_pathLength - 1].end : double.nan;

  /// Get the value of the path at the given [rate] ratio.
  double transform(double rate) {
    double r = start;
    if (_pathLength == 1) {
      r = _segments[0].transform(start, rate);
    } else if (_pathLength > 1) {
      double ratio = rate * _totalStrength;
      double lastEnd = start;
      for (final path in _segments) {
        if (ratio > path.strength) {
          ratio -= path.strength;
          lastEnd = path.end;
        } else {
          r = path.transform(lastEnd, ratio / path.strength);
          break;
        }
      }
    }
    return r;
  }

  /// clears the segments in the path.
  void clear() {
    _pathLength = 0;
    _totalStrength = 0;
    _segments.clear();
  }
}

class Segment {
  final double end, strength;

  const Segment(this.end, this.strength);

  double transform(double start, double delta) => double.nan;
}

class LinearSegment extends Segment {
  const LinearSegment(super.end, super.strength);

  @override
  double transform(double start, double delta) => start + delta * (end - start);
}

class QuadraticBezierSegment extends Segment {
  final double control;

  const QuadraticBezierSegment(super.end, super.strength, this.control);

  @override
  double transform(double start, double delta) {
    final inv = 1 - delta;
    return inv * inv * start + 2 * inv * delta * control + delta * delta * end;
  }
}

class CubicBezierSegment extends Segment {
  final double control1, control2;

  const CubicBezierSegment(
    super.end,
    super.strength,
    this.control1,
    this.control2,
  );

  @override
  double transform(double start, double delta) {
    final inv = 1 - delta;
    final inv2 = inv * inv;
    final d2 = delta * delta;
    return inv2 * inv * start +
        3 * inv2 * delta * control1 +
        3 * inv * d2 * control2 +
        d2 * delta * end;
  }
}
