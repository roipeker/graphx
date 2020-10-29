import '../game_world.dart';

mixin GameObject {
  GameWorld get world => GameWorld.instance;
}
