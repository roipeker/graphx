import 'dart:developer' as dev;

// The tag for anonymous methods in stack traces.
const _anonymousMethodTag = '<anonymous closure>';

/// Configuration options for [trace].
String _customTag = 'graphx™🌀';
String _separator = ', ';
bool _showClassname = false;
bool _showFilename = false;
bool _showLinenumber = false;
bool _showMethodname = false;
bool _showOutsideTag = false;
String _tagPaddingChar = ', ';
int _tagPaddingCount = 0;

/// Counter to keep track of the number of traces logged.
int _traceCount = 0;

// Determines whether to show the stack trace in the log output.
bool _useStack = false;

/// Global callback that replaces [print] in a similar way ActionScript
/// `trace()` works.
///
/// It has up to 10 arguments slots so you can pass any type of object to be
/// printed.
///
/// The way `trace()` shows output in the console can be defined with
/// [traceConfig].
void trace(
  dynamic arg1, [
  dynamic arg2,
  dynamic arg3,
  dynamic arg4,
  dynamic arg5,
  dynamic arg6,
  dynamic arg7,
  dynamic arg8,
  dynamic arg9,
  dynamic arg10,
]) {
  ++_traceCount;
  final outputList = <String>[
    '$arg1',
    if (arg2 != null) '$arg2',
    if (arg3 != null) '$arg3',
    if (arg4 != null) '$arg4',
    if (arg5 != null) '$arg5',
    if (arg6 != null) '$arg6',
    if (arg7 != null) '$arg7',
    if (arg8 != null) '$arg8',
    if (arg9 != null) '$arg9',
    if (arg10 != null) '$arg10',
  ];
  // •·
  var msg = outputList.join(_separator);
  var name = _customTag;
  if (_useStack) {
    var stack = _getStack();
    if (_tagPaddingCount > 0) {
      stack = stack.padRight(_tagPaddingCount, _tagPaddingChar);
    }
    if (_showOutsideTag) {
      msg = '$stack◉ $msg';
    } else {
      name += ' $stack';
    }
  }
  dev.log(
    msg,
    name: name,
    time: DateTime.now(),
    sequenceNumber: _traceCount,
  );
}

/// Configure [trace] outputs for debug console. [showLinenumber] only works if
/// [showFilename] is true. [tagPaddingCount] should be applied manually if you
/// wanna have a cleaner tabulated view.
void traceConfig({
  String? customTag,
  int tagPaddingCount = 0,
  String tagPaddingChar = ' ',
  bool showFilename = false,
  bool showLinenumber = false,
  bool showClassname = false,
  bool showMethodname = false,
  bool showOutsideTag = false,
  String argsSeparator = ', ',
}) {
  _tagPaddingCount = tagPaddingCount;
  _tagPaddingChar = tagPaddingChar;
  _customTag = customTag ?? 'graphx™🌀';
  _showFilename = showFilename;
  _showLinenumber = showLinenumber;
  _showClassname = showClassname;
  _showMethodname = showMethodname;
  _showOutsideTag = showOutsideTag;
  _separator = argsSeparator;
  _useStack = _showFilename || _showClassname || _showMethodname;
}

// Retrieves a stack trace and returns the corresponding output string.
String _getStack() {
  var curr = StackTrace.current.toString();
  if (curr.startsWith('#0')) {
    return _stackCommon(curr);
  }
  return _stackWeb(curr);
}

/// Returns a formatted string with the method call stack trace.
///
/// The resulting string will include the file name and line number where the
/// method was called, as well as the method name and class name (if available).
/// This method is used internally by the `trace` method to generate the log
/// tag.
///
/// If the `_showFilename` option is enabled, the resulting string will start
/// with the file name (without the extension) and line number separated by a
/// `↪` character.
///
/// If the `_showClassname` option is enabled, the resulting string will
/// include the class name and method name separated by a `‣` character.
///
/// If the `_showMethodname` option is enabled, only the method name will be
/// included in the resulting string.
///
/// Example output when `_showFilename`, `_showClassname`, and `_showMethodname`
/// are all enabled:
///
/// ```
/// my_file.dart ↪ 23 ‣ MyClass ‣ myMethod()
/// ```
///
/// Returns an empty string if `_useStack` is false.
String _stackCommon(String stack) {
  stack = stack.split('\n')[2];
  stack = stack.replaceAll('#2      ', '');
  var elements = stack.split(' (');
  var classnameMethod = elements[0];
  var filenameLine = elements[1];
  elements = classnameMethod.split('.');
  filenameLine = filenameLine.replaceAll('package:', '');
  var locationParts = filenameLine.split(':');
  var filePath = locationParts[0];
  var callLine = locationParts[1];
  var filename = filePath.substring(
      filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));
  String methodName, className = '';
  var output = ''; //ˇ
  if (_showFilename) {
    output += '$filename ';
    if (_showLinenumber) {
      output += '↪ $callLine ';
    }
  }
  const suffixCall = '()';
  if (elements.length == 1) {
    /// global method.
    methodName = '${elements[0]}$suffixCall';
    if (_showMethodname) {
      output += '‣ $methodName ';
    }
  } else {
    className = elements.removeAt(0);
    methodName = elements.join('.');
    methodName =
        '${methodName.replaceAll(_anonymousMethodTag, '<⁕>')}$suffixCall';
    if (_showClassname) {
      output += '‣ $className ';
    }
    if (_showMethodname) {
      output += '‣ $methodName ';
    }
  }
  return output;
}

/// Retrieves the output string for a stack trace in a web environment.
String _stackWeb(String stack) {
  // TODO: add parsing of stack trace for web.
  return '';
}
