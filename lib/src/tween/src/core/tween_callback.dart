part of gtween;

class CallbackParams {
  List<dynamic> positional;

  /// Symbol is represented by the literal # in Dart.
  /// So, if u need `({String name, int count})` in named parameters.
  /// You'd use {#name: 'roi', #count: 10}.
  Map<Symbol, dynamic> named;

  CallbackParams([this.positional, this.named]);

  static CallbackParams parse(Object args) {
    if (args == null) return null;
    if (args is CallbackParams) return args;
    if (args is List) {
      return CallbackParams(args);
    } else if (args is Map) {
      return CallbackParams(null, args);
    }
    return CallbackParams([args]);
  }

  static const String selfTweenKey = '{self}';

  void _setTween(GTween twn) {
    if (named != null) {
      if (named.containsValue(selfTweenKey)) {
        for (var e in named.entries) {
          if (e.value == selfTweenKey) {
            named[e.key] = twn;
          }
        }
      }
    }
    if (positional != null) {
      if (positional.contains(selfTweenKey)) {
        positional = positional.map((e) {
          if (e == selfTweenKey) {
            return twn;
          }
          return e;
        }).toList();
      }
    }
  }
}
