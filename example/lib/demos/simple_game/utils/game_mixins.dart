import 'package:graphx/demos/simple_game/game_world.dart';

mixin GameObject {
  GameWorld get world => GameWorld.instance;
}
