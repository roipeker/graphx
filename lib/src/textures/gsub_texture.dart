import '../../graphx.dart';

class GSubTexture extends GTexture {
  GTexture _parent;
  bool _ownsParent;
  GxRect _region;
  GxRect _sourceRegion;
  bool _rotated;
  double _w;
  double _h;
  double _scale;

  /// cache rendering.
  Rect _sourceRegionRect;
  Rect _destRect;

  GSubTexture(GTexture parent,
      {GxRect region,
      bool ownsParent = false,
      GxRect frame,
      bool rotated,
      double scaleModifier = 1}) {
    $setTo(
      parent,
      region: region,
      ownsParent: ownsParent,
      frame: frame,
      rotated: rotated,
      scaleModifier: scaleModifier,
    );
  }

  void $setTo(GTexture parent,
      {GxRect region,
      bool ownsParent = false,
      GxRect frame,
      bool rotated,
      double scaleModifier = 1}) {
    _region ??= GxRect();
    if (region != null) {
      _region.copyFrom(region);
    } else {
      /// used (parent.width)
      _region.setTo(0, 0, parent.nativeWidth, parent.nativeHeight);
    }
    if (frame != null) {
      if (this.frame != null) {
        this.frame.copyFrom(frame);
      } else {
        this.frame = frame.clone();
      }
    } else {
      this.frame = null;
    }
    _parent = parent;
    _ownsParent = ownsParent;
    _rotated = rotated;
    _w = (rotated ? _region.height : _region.width) / scaleModifier;
    _h = (rotated ? _region.width : _region.height) / scaleModifier;
    _scale = parent.scale * scaleModifier;
    _sourceRegion = _region.clone() * scale;

    /// cache.
    _sourceRegionRect = _sourceRegion.toNative();

    /// used width, height
    _destRect = Rect.fromLTWH(0, 0, nativeWidth, nativeHeight);
    sourceRect = GxRect(0, 0, nativeWidth, nativeHeight);
//    updateMatrices();
  }

//  @override
//  GxRect getBounds() {
//    return _sourceRegion;
//  }

  @override
  void dispose() {
    if (_ownsParent) {
      _parent.dispose();
    }
    super.dispose();
  }

  GxRect get region => _region;

  bool get rotated => _rotated;

  bool get ownsParent => _ownsParent;

  GTexture get parent => _parent;

  @override
  Image get root => _parent.root;

  @override
  double get width => _w;

  @override
  double get height => _h;

  @override
  double get nativeWidth => _w * _scale;

  @override
  double get nativeHeight => _h * _scale;

  @override
  double get scale => _scale;

  /// no support
  void updateMatrices() {}

  @override
  void render(Canvas canvas, [Paint paint]) {
    paint ??= GTexture.sDefaultPaint;
    paint.isAntiAlias = true;
    canvas.drawImageRect(root, _sourceRegionRect, _destRect, paint);
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
