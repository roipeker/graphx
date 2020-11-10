part of gtween;

class PropTween {
  /// target or dynamic
  GTweenable t;

  /// property "name" (commonly a String), or value!
  Object p;

  /// start value
  double s;

  /// amount to change, diff between end and start.
  double c;

  /// original target object.
  Object cObj;

  /// is function
  bool f;

  /// priority in render queue.
  int pr;

  /// target is tween plugin?
  bool pg;

  // name of original target property. Typically same as `t`
  String n;

  /// rounded
  bool r;

  /// linked list next.
  PropTween _next, _prev;
  PropTween({
    GTweenable target,
    Object property,
    double start,
    double change,
    String name,
    PropTween next,
    int priority = 0,
  }) {
    t = target;
    p = property;
    s = start;
    c = change;
    n = name;
//    this.f = this.t[p] is Function;
    if (next != null) {
      next._prev = this;
      _next = next;
    }
    pr = priority;
  }
}
