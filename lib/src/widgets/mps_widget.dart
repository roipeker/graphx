import 'package:flutter/widgets.dart';
import '../../graphx.dart';

/// typedef for [MPSBuilder.builder()].
typedef MPSFunctionBuilder<T> = Widget Function(
  BuildContext context,
  MPSEvent<T> event,
  Widget? child,
);

/// [MPSBuilder] allows you to subscribe to multiple MinPubSub topics.
/// GraphX has a global `mts` object that you can use to easily publish
/// data or events to topics.
/// This Widget listens the [topics] List and rebuilds when an event is
/// dispatched in any of them.
///
/// You can publish without params (`ems.emit(topic)`),
/// or 1 parameter[T] `ems.emit1(topic, value)`. Data is captured and sent as
/// 2nd parameter ([MPSEvent] event object) in the [build] function.
class MPSBuilder<T> extends StatefulWidget {
  final Widget? child;
  final MPS mps;
  final MPSFunctionBuilder<T> builder;
  final List<String> topics;

  const MPSBuilder({
    super.key,
    required this.builder,
    required this.topics,
    required this.mps,
    this.child,
  });

  @override
  createState() => MPSBuilderState<T>();
}

class MPSBuilderState<T> extends State<MPSBuilder<T>> {
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
 [MPSBuilder] doesnt support more than 1 argument. $paramStrings will not be reachable in the `builder`''');
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

/// Model object passed as 2nd argument in [MPSBuilder.builder].
class MPSEvent<T> {
  final String type;
  final T? data;

  factory MPSEvent.empty() => const MPSEvent('');

  const MPSEvent(
    this.type, [
    this.data,
  ]);

  @override
  String toString() {
    if (type == '') return 'MPSEvent [empty]';
    var str = 'MPSEvent "$type"';
    if (data != null) {
      str += ' data=$data';
    }
    return str;
  }
}
