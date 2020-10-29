import '../../graphx.dart';

class Graphx {
  static Graphx instance = Graphx();
  static Juggler _juggler;
  static Juggler get juggler => _juggler ??= Juggler();

  static void init() {}
}
