import 'package:graphx/graphx.dart';

enum SnakeCommands { left, right, up, down, pause }

abstract class Keys {
  static const leftKey = LogicalKeyboardKey.arrowLeft;
  static const rightKey = LogicalKeyboardKey.arrowRight;
  static const upKey = LogicalKeyboardKey.arrowUp;
  static const downKey = LogicalKeyboardKey.arrowDown;
  static const escKey = LogicalKeyboardKey.escape;
  static const rKey = LogicalKeyboardKey.keyR;
}
