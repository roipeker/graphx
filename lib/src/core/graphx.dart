import '../../graphx/animations/juggler.dart';
import '../input/input_converter.dart';

export '../display/bitmap.dart';
export '../display/display_object.dart';
export '../display/display_object_container.dart';
export '../display/shape.dart';
export '../display/sprite.dart';
export '../display/stage.dart';
export '../display/static_text.dart';
export '../events/keyboard_data.dart';
export '../events/pointer_data.dart';
export '../geom/gxmatrix.dart';
export '../geom/gxpoint.dart';
export '../geom/gxrect.dart';
export '../utils/assets_loader.dart';
export 'scene_controller.dart';
export 'scene_painter.dart';

class Graphx {
  static Graphx instance = Graphx();
  static Juggler _juggler;
  static Juggler get juggler => _juggler ??= Juggler();

  static init() {}
}
