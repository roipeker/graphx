import 'package:graphx/graphx.dart';

class _BezierControlPoint {
  GPoint prev;
  GPoint next;

  _BezierControlPoint([this.prev, this.next]) {
    prev ??= GPoint();
    next ??= GPoint();
  }
}

double _dist(double x, double y) => Math.sqrt(x * x + y * y);

void bezierCurveThrough(
  Graphics g,
  List<GPoint> points, [
  double tension = .25,
  List<GPoint> output,
]) {
  tension ??= .25;
  var len = points.length;
  if (len == 2) {
    output?.addAll([points[0], points[1]]);
    g?.moveTo(points[0].x, points[0].y);
    g?.lineTo(points[1].x, points[1].y);
    return;
  }

  final cpoints = <_BezierControlPoint>[];
  for (final _ in points) {
    cpoints.add(_BezierControlPoint());
  }

  for (var i = 1; i < len - 1; ++i) {
    final pi = points[i];
    final pp = points[i - 1];
    final pn = points[i + 1];
    var rdx = pn.x - pp.x;
    var rdy = pn.y - pp.y;
    var rd = _dist(rdx, rdy);
    var dx = rdx / rd;
    var dy = rdy / rd;

    var dp = _dist(pi.x - pp.x, pi.y - pp.y);
    var dn = _dist(pi.x - pn.x, pi.y - pn.y);

    var cpx = pi.x - dx * dp * tension;
    var cpy = pi.y - dy * dp * tension;
    var cnx = pi.x + dx * dn * tension;
    var cny = pi.y + dy * dn * tension;

    cpoints[i].prev.setTo(cpx, cpy);
    cpoints[i].next.setTo(cnx, cny);
  }

  /// end points
  cpoints[0].next = GPoint(
    (points[0].x + cpoints[1].prev.x) / 2,
    (points[0].y + cpoints[1].prev.y) / 2,
  );

  cpoints[len - 1].prev = GPoint(
    (points[len - 1].x + cpoints[len - 2].next.x) / 2,
    (points[len - 1].y + cpoints[len - 2].next.y) / 2,
  );

  /// draw?
  g?.moveTo(points[0].x, points[0].y);
  output?.add(points[0]);
  for (var i = 1; i < len; ++i) {
    var p = points[i];
    var cp = cpoints[i];
    var cpp = cpoints[i - 1];
    g?.cubicCurveTo(cpp.next.x, cpp.next.y, cp.prev.x, cp.prev.y, p.x, p.y);
    output?.addAll([cpp.next, cp.prev, p]);
  }
  cpoints.clear();
}

void bezierCurveThroughDraw(Graphics g, List<GPoint> points) {
  g.moveTo(points[0].x, points[0].y);
  final len = points.length;
  for (var i = 1; i < len; i += 3) {
    final p0 = points[i];
    final p1 = points[i + 1];
    final p2 = points[i + 2];
    g.cubicCurveTo(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y);
  }
}
