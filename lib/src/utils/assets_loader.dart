import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../../graphx.dart';

abstract class AssetLoader {
  static Future<GxTexture> loadImageTexture(
    String path, [
    double resolution,
  ]) async {
    final img = await loadImage(path);
    return GxTexture(img, null, false, resolution ?? TextureUtils.resolution);
  }

  static Future<GTexture> loadTexture(
    String path, [
    double resolution = 1.0,
  ]) async {
    return GTexture.fromImage(await loadImage(path), resolution);
  }

  static Future<GTextureAtlas> loadTextureAtlas(String imagePath,
      [String dataPath, double resolution = 1.0]) async {
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
    return GTextureAtlas(texture, xmlData);
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
