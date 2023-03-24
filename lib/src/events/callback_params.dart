/// An object that encapsulates the arguments passed to a callback function.
///
/// A [CallbackParams] object can contain both positional and named parameters.
/// The positional parameters are stored in a list, while the named parameters
/// are stored in a map, with the symbol as the key.
class CallbackParams {
  /// The list of positional parameters.
  List<dynamic>? positional;

  /// The map of named parameters.
  ///
  /// Symbols are represented by the literal # in Dart. So, if you need
  /// `({String name, int count})` in named parameters, you'd use
  /// `{#name: 'roi', #count: 10}`.
  Map<Symbol, dynamic>? named;

  /// Creates a new [CallbackParams] object.
  ///
  /// The [positional] parameter is optional and contains the list of positional
  /// parameters. The [named] parameter is also optional and contains the named
  /// parameters.
  CallbackParams([this.positional, this.named]);

  /// Parses the arguments passed to a callback function.
  ///
  /// The [args] parameter is the argument list that is passed to the function.
  /// It can be of type [CallbackParams], [List], [Map], or `null`. If [args]
  /// is [CallbackParams], it is returned as is. If it is a [List], a new
  /// [CallbackParams] object is created with the [List] as its [positional]
  /// parameter. If [args] is a [Map], a new [CallbackParams] object is created
  /// with the [Map] as its [named] parameter.
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
