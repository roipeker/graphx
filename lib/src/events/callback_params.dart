class CallBackParams {
  List<dynamic> positional;

  /// Symbol is represented by the literal # in Dart.
  /// So, if u need `({String name, int count})` in named parameters.
  /// You'd use {#name: 'roi', #count: 10}.
  Map<Symbol, dynamic> named;

  CallBackParams([this.positional, this.named]);

  static CallBackParams parse(Object args) {
    if (args == null) return null;

    if (args is CallBackParams) return args;

    if (args is List) {
      return CallBackParams(args);
    } else if (args is Map) {
      return CallBackParams(null, args);
    }

    return CallBackParams([args]);
  }
}
