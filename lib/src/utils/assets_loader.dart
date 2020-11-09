import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../../graphx.dart';

abstract class AssetLoader {
  static var textures = <String, GTexture>{};
  static var atlases = <String, GTextureAtlas>{};
  static var gifs = <String, GifAtlas>{};

  static GTexture getTexture(String cacheId) {
    return textures[cacheId];
  }

  static GTextureAtlas getAtlas(String cacheId) {
    return atlases[cacheId];
  }

  static GifAtlas getGif(String cacheId) {
    return gifs[cacheId];
  }

  static Future<GxTexture> loadImageTexture(
    String path, [
    double resolution,
  ]) async {
    final img = await loadImage(path);
    return GxTexture(img, null, false, resolution ?? TextureUtils.resolution);
  }

  static Future<GifAtlas> loadGif(
    String path, [
    double resolution = 1.0,
    String cacheId,
  ]) async {
    cacheId ??= path;

    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);
    final codec = await instantiateImageCodec(bytes, allowUpscaling: false);
    resolution ??= TextureUtils.resolution;

    final atlas = GifAtlas();
    atlas.scale = resolution;
    atlas.numFrames = codec.frameCount;
    for (var i = 0; i < atlas.numFrames; ++i) {
      final frame = await codec.getNextFrame();
      final texture = GTexture.fromImage(frame.image, resolution);
      var gifFrame = GifFrame(frame.duration, texture);
      atlas.addFrame(gifFrame);
    }
    gifs[cacheId] = textures[cacheId] = atlas;
    return atlas;
  }

  static Future<GTexture> loadTexture(
    String path, [
    double resolution = 1.0,
    String cacheId,
  ]) async {
    cacheId ??= path;
    textures[cacheId] = GTexture.fromImage(await loadImage(path), resolution);
    return textures[cacheId];
  }

  static Future<GTextureAtlas> loadTextureAtlas(String imagePath,
      [String dataPath, double resolution = 1.0, String cacheId]) async {
    if (dataPath == null) {
      /// if no index at the end, guess it.
      var lastIndex = imagePath.lastIndexOf('.');
      if (lastIndex == -1) {
        lastIndex = imagePath.length;
      }
      var basePath = imagePath.substring(0, lastIndex);
      dataPath = '$basePath.xml';
      print('Warning: using default xml data: $dataPath');
    }
    var texture = await AssetLoader.loadTexture(imagePath, resolution);
    var xmlData = await AssetLoader.loadString(dataPath);
    cacheId ??= imagePath;
    atlases[cacheId] = GTextureAtlas(texture, xmlData);
    return atlases[cacheId];
  }

  static Future<ByteData> loadBinary(String path) async {
    return await rootBundle.load(path);
  }

  /// load local assets.
  static Future<Image> loadImage(String path,
      {int targetWidth, int targetHeight}) async {
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);
    final codec = await instantiateImageCodec(
      bytes,
      allowUpscaling: false,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
    return (await codec.getNextFrame()).image;
  }

  static Future<String> loadString(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<dynamic> loadJson(String path) async {
    final str = await loadString(path);
    return jsonDecode(str);
  }
}
