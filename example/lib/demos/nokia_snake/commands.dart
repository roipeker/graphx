import 'package:graphx/graphx.dart';

enum SnakeCommands { left, right, up, down, pause }

abstract class Keys {
  static const LEFT_KEY = LogicalKeyboardKey.arrowLeft;
  static const RIGHT_KEY = LogicalKeyboardKey.arrowRight;
  static const UP_KEY = LogicalKeyboardKey.arrowUp;
  static const DOWN_KEY = LogicalKeyboardKey.arrowDown;
  static const ESC_KEY = LogicalKeyboardKey.escape;
  static const R_KEY = LogicalKeyboardKey.keyR;
}
