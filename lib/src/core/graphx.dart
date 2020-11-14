import '../../graphx.dart';

/// Dummy class
/// might be a central access points to Tickers, Pointers, Keyboards, and
/// SceneControllers in the future.
// ignore: avoid_classes_with_only_static_members
class Graphx {
  static Graphx instance = Graphx();

  /// currently only used to access the Juggler.
  static Juggler _juggler;
  static Juggler get juggler => _juggler ??= Juggler();
}
