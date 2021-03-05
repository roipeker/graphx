class CallbackParams {
  List<dynamic>? positional;

  /// Symbol is represented by the literal # in Dart.
  /// So, if u need `({String name, int count})` in named parameters.
  /// You'd use {#name: 'roi', #count: 10}.
  Map<Symbol, dynamic>? named;

  CallbackParams([this.positional, this.named]);

  static CallbackParams? parse(Object? args) {
    if (args == null) return null;

    if (args is CallbackParams) return args;

    if (args is List) {
      return CallbackParams(args);
    } else if (args is Map) {
      return CallbackParams(null, args as Map<Symbol, dynamic>?);
    }

    return CallbackParams([args]);
  }
}
