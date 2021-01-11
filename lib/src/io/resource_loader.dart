import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../../graphx.dart';
import 'network_image_loader.dart';

abstract class ResourceLoader {
  static Map<String, SvgData> svgs = <String, SvgData>{};
  static Map<String, GTexture> textures = <String, GTexture>{};
  static Map<String, GTextureAtlas> atlases = <String, GTextureAtlas>{};
  static Map<String, GifAtlas> gifs = <String, GifAtlas>{};

  static GTexture getTexture(String cacheId) {
    return textures[cacheId];
  }

  static SvgData getSvg(String cacheId) {
    return svgs[cacheId];
  }

  static GTextureAtlas getAtlas(String cacheId) {
    return atlases[cacheId];
  }

  static GifAtlas getGif(String cacheId) {
    return gifs[cacheId];
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

  static Future<SvgData> loadNetworkSvg(
    String url, {
    String cacheId,
    Function(NetworkImageEvent) onComplete,
    Function(NetworkImageEvent) onProgress,
    Function(NetworkImageEvent) onError,
  }) async {
    final response = await NetworkImageLoader.loadSvg(
      url,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
    if (response.isSvg) {
      svgs[cacheId] = response.svgData;
    }
    return response.svgData;
  }

  static Future<GTexture> loadNetworkTexture(
    String url, {
    int width,
    int height,
    double resolution = 1.0,
    String cacheId,
    Function(NetworkImageEvent) onComplete,
    Function(NetworkImageEvent) onProgress,
    Function(NetworkImageEvent) onError,
  }) async {
    final response = await NetworkImageLoader.load(
      url,
      width: width,
      height: height,
      scale: resolution,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
    if (response.isImage) {
      textures[cacheId] = response.texture;
    }
    return response.texture;
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

  static Future<SvgData> loadSvg(
    String path, [
    String cacheId,
  ]) async {
    cacheId ??= path;
    svgs[cacheId] = await SvgUtils.svgDataFromString(await loadString(path));
    return svgs[cacheId];
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
    var texture = await ResourceLoader.loadTexture(imagePath, resolution);
    var xmlData = await ResourceLoader.loadString(dataPath);
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
