import 'package:flutter/widgets.dart';

import '../../graphx.dart';

/// Function builder used to build a widget with an [MPSEvent] event.
///
/// The `context` parameter is the build context passed from the [_MPSBuilderState] widget.
///
/// The `event` parameter is the event object that contains the type of the event and the data
/// associated with it. It is updated each time an event is dispatched in any of the subscribed
/// topics.
///
/// The `child` parameter is an optional child widget to be included in the builder.
///
/// Returns the built widget tree based on the provided [MPSEvent] object.
typedef MPSFunctionBuilder<T> = Widget Function(
  BuildContext context,
  MPSEvent<T> event,
  Widget? child,
);

/// [MPSBuilder] allows you to subscribe to multiple MinPubSub topics.
///
/// GraphX has a global `mts` object that you can use to easily publish data or events to topics.
///
/// This widget listens to the [topics] list and rebuilds when an event is dispatched in any of them.
///
/// You can publish without parameters (`ems.emit(topic)`) or with a single parameter `ems.emit1(topic, value)`.
/// The data is captured and sent as the second parameter ([MPSEvent] event object) in the [build] function.
///
/// Experimental! "MPS" is discouraged to use in GraphX. Use [ValueNotifier] or
/// other [Listenable] objects instead to create the communication.
///
class MPSBuilder<T> extends StatefulWidget {
  /// The optional child widget to be included in the builder.
  final Widget? child;

  /// The [MPS] object instance to be used for subscription.
  final MPS mps;

  /// The builder function to build the widget tree.
  final MPSFunctionBuilder<T> builder;

  /// The list of topics to be subscribed to.
  final List<String> topics;

  /// Creates a new [MPSBuilder] instance.
  const MPSBuilder({
    super.key,
    required this.builder,
    required this.topics,
    required this.mps,
    this.child,
  });

  @override
  _MPSBuilderState<T> createState() => _MPSBuilderState<T>();
}

class _MPSBuilderState<T> extends State<MPSBuilder<T>> {
  MPSEvent<T> _data = MPSEvent.empty();
  final _maps = <String, Function>{};

  @override
  void initState() {
    super.initState();
    for (var t in widget.topics) {
      _maps[t] = ([p1, p2, p3]) {
        if (p2 != null || p3 != null) {
          var paramStrings = '';
          if (p2 != null) {
            paramStrings = ', "$p2" ';
          }
          if (p3 != null) {
            paramStrings = ', "$p3" ';
          }
          trace('''WARNING:
 [MPSBuilder] doesn't support more than 1 argument. $paramStrings will not be reachable in the `builder`''');
        }
        setState(() {
          _data = MPSEvent(t, p1);
        });
      };
      widget.mps.on(t, _maps[t]);
    }
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _data, widget.child);

  @override
  void dispose() {
    for (var t in widget.topics) {
      widget.mps.off(t, _maps[t]);
    }
    super.dispose();
  }
}

/// Model object passed as the second argument in [MPSFunctionBuilder].
class MPSEvent<T> {
  /// The type of the event.
  final String type;

  /// The data associated with the event.
  final T? data;

  /// Creates an empty [MPSEvent] object with an empty type.
  factory MPSEvent.empty() => const MPSEvent('');

  /// Creates a new [MPSEvent] object with the given [type] and [data].
  const MPSEvent(
    this.type, [
    this.data,
  ]);

  @override
  String toString() {
    if (type == '') {
      return 'MPSEvent [empty]';
    }
    var str = 'MPSEvent "$type"';
    if (data != null) {
      str += ' data=$data';
    }
    return str;
  }
}
