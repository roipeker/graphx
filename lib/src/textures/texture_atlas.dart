import 'package:xml/xml.dart' as xml;

import '../../graphx.dart';

/// Represents a texture atlas, which is a collection of sub-textures that can
/// be used for rendering 2D graphics efficiently. A [GTextureAtlas] is composed
/// of a single image file and an optional data file that describes the
/// sub-texture regions and other properties to be rendered.
///
// TODO: add code example.
class GTextureAtlas {
  /// The atlas texture for this [GTextureAtlas]. It represents the texture
  /// image used by the atlas to draw sub-textures.
  /// If the texture is null, the atlas cannot be drawn.
  GTexture? _atlasTexture;

  /// A map of [GSubTexture] objects that represents the sub-texture regions
  /// within the atlas texture. Each sub-texture is identified by a unique
  /// [String] key.
  Map<String?, GSubTexture>? _subTextures;

  // A list of "names" for the sub-textures regions within the atlas texture.
  // The list is sorted alphabetically and is used to provide fast access to
  // sub-texture names that match a given prefix.
  List<String?>? _subTexturesNames;

  /// Scale ratio of the texture atlas.
  late double _atlasXmlRatio;

  /// Creates a new [GTextureAtlas] object with the provided [texture] and
  /// optional [data] and [adjustXmlSizesRatio] parameters.
  ///
  /// The [texture] parameter is required and represents the texture atlas image
  /// file.
  ///
  /// The [data] parameter is optional and represents the data file that
  /// describes the contents of the texture atlas.
  ///
  /// The [adjustXmlSizesRatio] parameter is optional and represents a scaling
  /// factor for the dimensions described in the data file, if one is provided.
  ///
  /// The [GTextureAtlas] object contains a map of sub-textures, each of which
  /// represents a region within the texture atlas image that can be drawn
  /// independently. If [data] is provided, this constructor will parse the data
  /// and populate the sub-texture map.
  GTextureAtlas(
    GTexture? texture, [
    Object? data,
    double adjustXmlSizesRatio = 1,
  ]) {
    _subTextures = {};
    _atlasTexture = texture;
    _atlasXmlRatio = adjustXmlSizesRatio;
    if (data != null) {
      parseAtlasData(data);
    }
  }

  /// Constructs a new instance of [GTextureAtlas] with the provided tile size
  /// and texture.
  ///
  /// The [tileWidth] and [tileHeight] arguments define the size of each tile
  /// in the atlas.
  ///
  /// The [tilePadding] argument sets the amount of padding to add around each
  /// tile.
  ///
  /// The [namePrefix] argument sets the prefix to use for the name of each
  /// tile.
  ///
  /// Throws an error if the [texture] is `null`.
  factory GTextureAtlas.fixedSizeTile(
    GTexture texture, {
    required double tileWidth,
    double? tileHeight,
    double tilePadding = 0,
    String namePrefix = '',
  }) {
    tileHeight ??= tileWidth;
    final atlas = GTextureAtlas(texture);
    final cols = texture.width! ~/ tileWidth;
    final rows = texture.height! ~/ tileHeight;
    final total = cols * rows;
    List.generate(total, (index) {
      var px = index % cols;
      var py = index ~/ cols;
      final name = '$namePrefix$index'.padLeft(2, '0');
      atlas.addRegion(
        name,
        GRect(
          px * tileWidth + tilePadding,
          py * tileHeight! + tilePadding,
          tileWidth - tilePadding,
          tileHeight - tilePadding,
        ),
      );
    });
    return atlas;
  }

  /// Gets the atlas texture.
  GTexture? get texture {
    return _atlasTexture;
  }

  /// Adds a new sub-texture region to the atlas using the provided name, region
  /// and optional frame and rotation values.
  ///
  /// The [name] parameter is a String representing the name of the sub-texture
  /// region.
  ///
  /// The [region] parameter is a [GRect] object representing the rectangular
  /// region of the sub-texture in the atlas texture.
  ///
  /// The [frame] parameter is an optional [GRect] object representing the
  /// rectangular region of the sub-texture frame, which is the area of the
  /// texture used in rendering. If not provided, the entire [region] area will
  /// be used as the frame.
  ///
  /// The [rotated] parameter is an optional boolean value representing whether
  /// the sub-texture region should be rotated. If set to true, the sub-texture
  /// will be rendered at a 90-degree angle from its original orientation.
  ///
  void addRegion(
    String? name,
    GRect region, [
    GRect? frame,
    bool rotated = false,
  ]) {
    addSubTexture(
        name,
        GSubTexture(
          _atlasTexture!,
          region: region,
          frame: frame,
          rotated: rotated,
        ));
  }

  /// Adds a [GSubTexture] with the given [name] to the atlas.
  ///
  /// The [subTexture] parameter is the [GSubTexture] to be added.
  ///
  /// Throws an exception if the root [GTexture] of the [subTexture] does not
  /// match the atlas [GTexture].
  void addSubTexture(String? name, GSubTexture subTexture) {
    if (subTexture.root != _atlasTexture!.root) {
      throw 'SubTexture\'s root must be an Atlas Texture.';
    }
    _subTextures![name] = subTexture;
    _subTexturesNames = null;
  }

  /// Disposes the atlas and all its sub-textures.
  void dispose() {
    _atlasTexture?.dispose();
    _subTextures?.clear();
    _subTexturesNames?.clear();
  }

  /// Returns the frame of the sub-texture with the given [name].
  GRect? getFrame(String name) {
    return _subTextures![name]?.frame;
  }

  /// Gets a list of texture names that match the given [prefix].
  ///
  /// The [prefix] parameter is used to filter the list of texture names to be
  /// returned.
  ///
  /// The [out] parameter is an optional list that will be filled with the
  /// matching texture names. If it's not provided, a new list will be created.
  ///
  /// Returns the list of matching texture names.
  ///
  List<String?> getNames({String? prefix, List<String?>? out}) {
    prefix ??= '';
    out ??= [];
    if (_subTexturesNames == null) {
      _subTexturesNames = [];
      for (var name in _subTextures!.keys) {
        _subTexturesNames!.add(name);
      }
      _subTexturesNames!.sort();
    }
    for (var name in _subTexturesNames!) {
      if (name!.indexOf(prefix) == 0) {
        out.add(name);
      }
    }
    return out;
  }

  /// Returns the region of the sub-texture with the given [name].
  GRect? getRegion(String name) {
    return _subTextures![name]?.region;
  }

  /// Returns `true` if the sub-texture with the given [name] is rotated.
  bool getRotation(String name) {
    return _subTextures![name]?.rotated ?? false;
  }

  /// Returns the [GSubTexture] instance with the given [name].
  GSubTexture? getTexture(String? name) {
    return _subTextures![name];
  }

  /// Gets a list of [GTexture]s that match the given [prefix].
  ///
  /// The [prefix] parameter is used to filter the list of textures to be
  /// returned by their name.
  ///
  /// The [out] parameter is an optional list that will be filled with the
  /// matching textures. If it's not provided, a new list will be created.
  ///
  /// Returns the list of matching [GTexture]s.
  ///
  List<GTexture?> getTextures({String? prefix, List<GTexture?>? out}) {
    prefix ??= '';
    out ??= [];
    final list = getNames(prefix: prefix);
    for (var name in list) {
      out.add(getTexture(name));
    }
    return out;
  }

  /// Parses the given [data] to create the texture atlas. The method tries to
  /// determine the format of the data by checking if it contains a closing tag
  /// for the TextureAtlas element, and if it is not an XML document, an error
  /// is thrown. If the data is XML, the [parseAtlasXml] method is called with
  /// the parsed XML document, otherwise an error is thrown.
  ///
  /// If [data] is a string, it can be either an XML document or a JSON object
  /// representing the texture atlas. If it is JSON, you can use the
  /// dart:convert library to convert it to a Map<String, dynamic> object first
  /// before passing it to this method.
  ///
  /// Throws an error if the data is not XML or JSON format.
  void parseAtlasData(Object data) {
    if (data is String) {
      /// parse json or xml.
      if (data.contains('</TextureAtlas>')) {
        data = xml.XmlDocument.parse(data);
      }
    }

    if (data is xml.XmlDocument) {
      parseAtlasXml(data);
    } else {
      throw 'TextureAtlas only supports XML data.';
    }
  }

  /// Parses the provided [XmlDocument] and constructs the atlas.
  void parseAtlasXml(xml.XmlDocument atlasXml) {
    var scale = _atlasTexture!.scale;
    var region = GRect();
    var frame = GRect();
    final pivots = <String?, GPoint>{};
    final nodeList = atlasXml.findAllElements('SubTexture');
    for (var subTexture in nodeList) {
      var name = subTexture.getAttribute('name');
      var x = _attrDouble(subTexture, 'x') / scale! * _atlasXmlRatio;
      var y = _attrDouble(subTexture, 'y') / scale * _atlasXmlRatio;
      var width = _attrDouble(subTexture, 'width') / scale * _atlasXmlRatio;
      var height = _attrDouble(subTexture, 'height') / scale * _atlasXmlRatio;
      var frameX = _attrDouble(subTexture, 'frameX') / scale * _atlasXmlRatio;
      var frameY = _attrDouble(subTexture, 'frameY') / scale * _atlasXmlRatio;
      var frameWidth =
          _attrDouble(subTexture, 'frameWidth') / scale * _atlasXmlRatio;
      var frameHeight =
          _attrDouble(subTexture, 'frameHeight') / scale * _atlasXmlRatio;
      var pivotX = _attrDouble(subTexture, 'pivotX',
          defaultValue: _attrDouble(subTexture, 'anchorX'));
      var pivotY = _attrDouble(subTexture, 'pivotY',
          defaultValue: _attrDouble(subTexture, 'anchorY'));
      pivotX /= scale * _atlasXmlRatio;
      pivotY /= scale * _atlasXmlRatio;
      var rotated = _attrBoolean(subTexture, 'rotated', defaultValue: false);
      region.setTo(x, y, width, height);
      frame.setTo(frameX, frameY, frameWidth, frameHeight);
      if (frameWidth > 0 && frameHeight > 0) {
        addRegion(name, region, frame, rotated!);
      } else {
        addRegion(name, region, null, rotated!);
      }
      if (pivotX != 0 || pivotY != 0) {
        /// image bind pivot point to texture!
        pivots[name] = GPoint(pivotX, pivotY);
      }
    }
  }

  /// Removes the sub-texture reference with the specified [name] from the
  /// texture atlas. If the region exists, its corresponding [GSubTexture]
  /// object will be disposed and removed from the atlas. If the region doesn't
  /// exist, nothing happens.
  ///
  void removeRegion(String name) {
    var subTexture = _subTextures![name];
    subTexture?.dispose();
    _subTextures!.remove(name);
    _subTexturesNames = null;
  }

  /// Helper method to extract boolean attribute values from XML elements.
  static bool? _attrBoolean(
    xml.XmlElement element,
    String name, {
    bool? defaultValue,
  }) {
    final val = element.getAttribute(name);
    if (val == null) {
      return defaultValue;
    }
    return StringUtils.parseBoolean(val);
  }

  /// Helper method to extract double attribute values from XML elements.
  static double _attrDouble(
    xml.XmlElement element,
    String name, {
    double defaultValue = 0.0,
  }) {
    final val = element.getAttribute(name);
    if (val == null) {
      return defaultValue;
    }
    return double.tryParse(val) ?? defaultValue;
  }
}
