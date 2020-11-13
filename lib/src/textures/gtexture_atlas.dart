import 'package:xml/xml.dart' as xml;

import '../../graphx.dart';

class GTextureAtlas {
  GTexture _atlasTexture;
  Map<String, GSubTexture> _subTextures;
  List<String> _subTexturesNames;

  static final List<String> _names = <String>[];

  static bool attrBoolean(xml.XmlElement el, String name, {bool defaultValue}) {
    var val = el.getAttribute(name);
    if (val == null) return defaultValue;
    return StringUtils.parseBoolean(val) ?? defaultValue;
  }

  static double attrDouble(xml.XmlElement el, String name,
      {double defaultValue = 0.0}) {
    var val = el.getAttribute(name);
    if (val == null) return defaultValue;
    return double.tryParse(val) ?? defaultValue;
  }

  double _atlasXmlRatio;
  GTextureAtlas(
    GTexture texture, [
    Object data,
    double adjustXmlSizesRatio = 1,
  ]) {
    _subTextures = {};
    _atlasTexture = texture;
    _atlasXmlRatio = adjustXmlSizesRatio;
    if (data != null) {
      parseAtlasData(data);
    }
  }

  void parseAtlasData(Object data) {
    if (data is String) {
      /// parse json or xml.
      if ((data as String).contains('</TextureAtlas>')) {
        data = xml.XmlDocument.parse(data);
      }
    }

    if (data is xml.XmlDocument) {
      parseAtlasXml(data);
    } else {
      throw 'TextureAtlas only supports XML data.';
    }
  }

  void parseAtlasXml(xml.XmlDocument atlasXml) {
    var scale = _atlasTexture.scale;
    var region = GxRect();
    var frame = GxRect();
    final pivots = <String, GxPoint>{};
    final nodeList = atlasXml.firstChild.findElements('SubTexture');

    for (var subTexture in nodeList) {
      var name = subTexture.getAttribute('name');
      var x = attrDouble(subTexture, 'x') / scale * _atlasXmlRatio;
      var y = attrDouble(subTexture, 'y') / scale * _atlasXmlRatio;
      var width = attrDouble(subTexture, 'width') / scale * _atlasXmlRatio;
      var height = attrDouble(subTexture, 'height') / scale * _atlasXmlRatio;
      var frameX = attrDouble(subTexture, 'frameX') / scale * _atlasXmlRatio;
      var frameY = attrDouble(subTexture, 'frameY') / scale * _atlasXmlRatio;
      var frameWidth =
          attrDouble(subTexture, 'frameWidth') / scale * _atlasXmlRatio;
      var frameHeight =
          attrDouble(subTexture, 'frameHeight') / scale * _atlasXmlRatio;
      var pivotX = attrDouble(subTexture, 'pivotX',
          defaultValue: attrDouble(subTexture, 'anchorX'));
      var pivotY = attrDouble(subTexture, 'pivotY',
          defaultValue: attrDouble(subTexture, 'anchorY'));
      pivotX /= scale * _atlasXmlRatio;
      pivotY /= scale * _atlasXmlRatio;
      var rotated = attrBoolean(subTexture, 'rotated', defaultValue: false);
      region.setTo(x, y, width, height);
      frame.setTo(frameX, frameY, frameWidth, frameHeight);
      if (frameWidth > 0 && frameHeight > 0) {
        addRegion(name, region, frame, rotated);
      } else {
        addRegion(name, region, null, rotated);
      }
      if (pivotX != 0 || pivotY != 0) {
        /// image bind pivot point to texture!
        pivots[name] = GxPoint(pivotX, pivotY);
      }
    }

    /// adobe animate workaround.
  }

  void addRegion(String name, GxRect region,
      [GxRect frame, bool rotated = false]) {
    addSubTexture(
        name,
        GSubTexture(
          _atlasTexture,
          region: region,
          ownsParent: false,
          frame: frame,
          rotated: rotated,
        ));
  }

  void removeRegion(String name) {
    var subTexture = _subTextures[name];
    subTexture?.dispose();
    _subTextures.remove(name);
    _subTexturesNames = null;
  }

  GTexture get texture => _atlasTexture;

  bool getRotation(String name) {
    return _subTextures[name]?.rotated ?? false;
  }

  GxRect getFrame(String name) {
    return _subTextures[name]?.frame;
  }

  GSubTexture getTexture(String name) {
    return _subTextures[name];
  }

  GxRect getRegion(String name) {
    return _subTextures[name]?.region;
  }

  List<GTexture> getTextures({String prefix, List<GTexture> out}) {
    prefix ??= '';
    out ??= [];
    final list = getNames(prefix: prefix, out: _names);
    for (var name in list) {
      out.add(getTexture(name));
    }
    return out;
  }

  List<String> getNames({String prefix, List<String> out}) {
    prefix ??= '';
    out ??= [];
    if (_subTexturesNames == null) {
      _subTexturesNames = [];
      for (var name in _subTextures.keys) {
        _subTexturesNames.add(name);
      }
      _subTexturesNames.sort();
    }
    for (var name in _subTexturesNames) {
      if (name.indexOf(prefix) == 0) {
        out.add(name);
      }
    }
    return out;
  }

  void addSubTexture(String name, GSubTexture subTexture) {
    if (subTexture.root != _atlasTexture.root) {
      throw 'SubTexture\'s root must be an Atlas Texture.';
    }
    _subTextures[name] = subTexture;
    _subTexturesNames = null;
  }
}
