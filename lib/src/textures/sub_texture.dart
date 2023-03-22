import 'dart:ui' as ui;

import '../../graphx.dart';

/// Represents a sub-texture or a sub-region of a texture.
class GSubTexture extends GTexture {
  /// The parent [GTexture] of this sub-texture.
  GTexture? _parent;

  /// A flag indicating whether this sub-texture owns the parent [GTexture] or not.
  bool? _ownsParent;

  /// The region of the parent [GTexture] that this sub-texture represents.
  GRect? _region;

  /// The scaled region of the parent [GTexture] that this sub-texture represents.
  late GRect _sourceRegion;

  /// A flag indicating whether this sub-texture is rotated or not.
  bool? _rotated;

  /// The width of the sub-texture.
  double? _w;

  /// The height of the sub-texture.
  double? _h;

  /// The scale of the sub-texture.
  double? _scale;

  /// The cached native source region of the sub-texture.
  late ui.Rect _sourceRegionRect;

  /// The cached destination rect of the sub-texture.
  late ui.Rect _destRect;

  /// Creates a new sub-texture from a parent texture.
  ///
  /// The parent texture can be either a GTexture or another GSubTexture.
  /// The `region` defines the region of the parent texture that will be
  /// used for the sub-texture. The `frame` is an optional argument to specify
  /// the trimmed rectangle within the texture atlas, if not specified the
  /// sub-texture will use the same frame as the parent texture.
  ///
  /// The `rotated` parameter indicates if the sub-texture is rotated 90 degrees
  /// clockwise (true) or not (false).
  ///
  /// The `scaleModifier` argument allows to scale the sub-texture. This is useful
  /// for example to create high resolution textures, or to reduce the size
  /// of a texture for better performance.
  GSubTexture(
    GTexture parent, {
    GRect? region,
    bool ownsParent = false,
    GRect? frame,
    required bool rotated,
    double scaleModifier = 1,
  }) {
    $setTo(
      parent,
      region: region,
      ownsParent: ownsParent,
      frame: frame,
      rotated: rotated,
      scaleModifier: scaleModifier,
    );
  }

  /// Returns the height of this sub-texture.
  @override
  double? get height {
    return _h;
  }

  /// Returns the native height of this sub-texture, taking into account its
  /// scale.
  @override
  double get nativeHeight {
    return _h! * _scale!;
  }

  /// Returns the native width of this sub-texture, taking into account its
  /// scale.
  @override
  double get nativeWidth {
    return _w! * _scale!;
  }

  /// Returns whether this sub-texture owns its parent texture, meaning whether
  /// this sub-texture is responsible for disposing its parent texture.
  bool? get ownsParent {
    return _ownsParent;
  }

  /// Returns the parent texture of this sub-texture.
  GTexture? get parent {
    return _parent;
  }

  /// Returns the region of this sub-texture within its parent texture.
  GRect? get region {
    return _region;
  }

  /// Returns the root image of the parent texture of this sub-texture.
  @override
  ui.Image? get root {
    return _parent!.root;
  }

  /// Returns whether this sub-texture is rotated within its parent texture.
  bool? get rotated {
    return _rotated;
  }

  /// Returns the scale of this sub-texture, relative to its parent texture.
  @override
  double? get scale {
    return _scale;
  }

  /// Returns the width of this sub-texture.
  @override
  double? get width {
    return _w;
  }

  /// (Internal usage)
  ///
  /// Updates the sub-texture to use a new parent texture and region.
  ///
  /// This method can be used to update the sub-texture dynamically, for example
  /// to use a different frame from the parent texture.
  void $setTo(GTexture parent,
      {GRect? region,
      bool ownsParent = false,
      GRect? frame,
      required bool rotated,
      double scaleModifier = 1}) {
    _region ??= GRect();
    if (region != null) {
      _region!.copyFrom(region);
    } else {
      /// used (parent.width)
      _region!.setTo(0, 0, parent.nativeWidth, parent.nativeHeight);
    }
    if (frame != null) {
      if (this.frame != null) {
        this.frame!.copyFrom(frame);
      } else {
        this.frame = frame.clone();
      }
    } else {
      this.frame = null;
    }
    _parent = parent;
    _ownsParent = ownsParent;
    _rotated = rotated;
    _w = (rotated ? _region!.height : _region!.width) / scaleModifier;
    _h = (rotated ? _region!.width : _region!.height) / scaleModifier;
    _scale = parent.scale! * scaleModifier;
    _sourceRegion = _region!.clone() * scale!;

    /// cache.
    _sourceRegionRect = _sourceRegion.toNative();

    /// used width, height
    _destRect = ui.Rect.fromLTWH(0, 0, nativeWidth, nativeHeight);
    sourceRect = GRect(0, 0, nativeWidth, nativeHeight);
//    updateMatrices();
  }

  /// Disposes the sub-texture, and also disposes the parent texture if
  /// `ownsParent` was set to true.
  @override
  void dispose() {
    if (_ownsParent!) {
      _parent!.dispose();
    }
    super.dispose();
  }

  /// (Internal usage)
  ///
  /// Renders the texture in the given [canvas] using the optional [paint].
  /// By default, the texture is rendered with the [GTexture.$defaultPaint],
  /// which can be modified by passing a different Paint instance.
  ///
  /// If the texture is rotated, the sourceRegion is swapped for rendering.
  @override
  void render(ui.Canvas? canvas, [ui.Paint? paint]) {
    paint ??= GTexture.$defaultPaint;
    paint.isAntiAlias = true;
    canvas!.drawImageRect(root!, _sourceRegionRect, _destRect, paint);
//    final sub = texture as GSubTexture;
//    final dest = Rect.fromLTWH(
//      0,
//      0,
//      sub.region.width / texture.scale,
//      sub.region.height / texture.scale,
//    );
//    $canvas.drawImageRect(
//      sub.root,
//      sub.region.toNative(),
//      dest,
//      _paint,
//    );
  }
}
