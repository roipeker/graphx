import 'dart:math';

class GameUtils {
  static Random rnd = Random();

  static bool rndBool() {
    return rnd.nextBool();
  }

  static double rndDouble() {
    return rnd.nextDouble();
  }

  static E rndFromList<E>(List<E> list) {
    final idx = rndRangeInt(0, list.length - 1);
    return list[idx];
  }

  static double rndRange(double min, double max) {
    return min + rndDouble() * (max - min);
  }

  static int rndRangeInt(int min, int max) {
    return min + rnd.nextInt(max - min);
  }
}
