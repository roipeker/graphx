import 'package:graphx/graphx.dart';

class PadPoint {
  double x, y;
  int? time;
  PadPoint(this.x, this.y, [int? time]) {
    this.time = time ?? getTimer();
  }

  double distanceTo(PadPoint p) {
    var dist = this - p;
    return Math.sqrt(dist.x * dist.x + dist.y * dist.y);
  }

  double velocityForm(PadPoint start) =>
      time != start.time ? distanceTo(start) / (time! - start.time!) : 0.0;

  PadPoint operator -(PadPoint other) => PadPoint(x - other.x, y - other.y);
  PadPoint operator +(PadPoint other) => PadPoint(x + other.x, y + other.y);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    return other is PadPoint &&
        other.time == time &&
        other.x == x &&
        other.y == y;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(x, y, time);
}
