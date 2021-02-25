import 'package:graphx/graphx.dart';

import 'point.dart';

class BezierDraw {
  static BezierDraw fromPoints(List<PadPoint> points, double w1, double w2) {
    var c2 =
        BezierDraw.controlPoints(points[0], points[1], points[2])[1];
    var c3 =
        BezierDraw.controlPoints(points[1], points[2], points[3])[0];
    return BezierDraw(points[1], c2, c3, points[2], w1, w2);
  }

  static List<PadPoint> controlPoints(
      PadPoint s1, PadPoint s2, PadPoint s3) {
    final dx1 = s1.x - s2.x;
    final dy1 = s1.y - s2.y;
    final dx2 = s2.x - s3.x;
    final dy2 = s2.y - s3.y;
    final m1 = PadPoint((s1.x + s2.x) / 2, (s1.y + s2.y) / 2);
    final m2 = PadPoint((s2.x + s3.x) / 2, (s2.y + s3.y) / 2);
    final l1 = Math.sqrt(dx1 * dx1 + dy1 * dy1);
    final l2 = Math.sqrt(dx2 * dx2 + dy2 * dy2);
    final dxm = m1.x - m2.x;
    final dym = m1.y - m2.y;
    final k = l2 / (l1 + l2);
    final cm = PadPoint(m2.x + dxm * k, m2.y + dym * k);
    final tx = s2.x - cm.x;
    final ty = s2.y - cm.y;
    return [
      PadPoint(m1.x + tx, m1.y + ty),
      PadPoint(m2.x + tx, m2.y + ty),
    ];
  }

  PadPoint startPoint, control1, control2, endPoint;
  double startW, endW;

  BezierDraw(
    this.startPoint,
    this.control1,
    this.control2,
    this.endPoint,
    this.startW,
    this.endW,
  );

  double length() {
    final steps = 10;
    var len = 0.0;
    var px = 0.0, py = 0.0;
    for (var i = 0; i <= steps; ++i) {
      var t = i / steps;
      var cx = _point(t, startPoint.x, control1.x, control2.x, endPoint.x);
      var cy = _point(t, startPoint.y, control1.y, control2.y, endPoint.y);
      if (i > 0) {
        double dx = cx - px;
        double dy = cy - py;
        len += Math.sqrt(dx * dx + dy * dy);
      }
      px = cx;
      py = cy;
    }
    return len;
  }

  double _point(double t, double start, double c1, double c2, double end) {
    return (start * (1.0 - t) * (1.0 - t) * (1.0 - t)) +
        (3.0 * c1 * (1.0 - t) * (1.0 - t) * t) +
        (3.0 * c2 * (1.0 - t) * t * t) +
        (end * t * t * t);
  }
}
