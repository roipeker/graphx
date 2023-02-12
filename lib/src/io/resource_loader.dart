import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import '../../graphx.dart';
import 'network_image_loader.dart';

abstract class ResourceLoader {
  static Map<String, SvgData> svgCache = <String, SvgData>{};
  static Map<String, FragmentProgram> shaderCache = <String, FragmentProgram>{};
  static Map<String, GTexture> textureCache = <String, GTexture>{};
  static Map<String, GTextureAtlas> atlasCache = <String, GTextureAtlas>{};
  static Map<String, GifAtlas> gifCache = <String, GifAtlas>{};

  static void clearCache() {
    for (var vo in svgCache.values) {
      vo.dispose();
    }
    for (var vo in textureCache.values) {
      vo.dispose();
    }
    for (var vo in atlasCache.values) {
      vo.dispose();
    }
    for (var vo in gifCache.values) {
      vo.dispose();
    }
  }

  static FragmentProgram? getShader(String cacheId) {
    return shaderCache[cacheId];
  }

  static GTexture? getTexture(String cacheId) {
    return textureCache[cacheId];
  }

  static SvgData? getSvg(String cacheId) {
    return svgCache[cacheId];
  }

  static GTextureAtlas? getAtlas(String cacheId) {
    return atlasCache[cacheId];
  }

  static GifAtlas? getGif(String cacheId) {
    return gifCache[cacheId];
  }

  static Future<GifAtlas> loadGif(
    String path, {
    double resolution = 1.0,
    String? cacheId,
  }) async {
    if (cacheId != null && gifCache.containsKey(cacheId)) {
      return gifCache[cacheId]!;
    }
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);
    final codec = await ui.instantiateImageCodec(bytes, allowUpscaling: false);

    final atlas = GifAtlas();
    atlas.scale = resolution;
    atlas.numFrames = codec.frameCount;
    for (var i = 0; i < atlas.numFrames; ++i) {
      final frame = await codec.getNextFrame();
      final texture = GTexture.fromImage(frame.image, resolution);
      var gifFrame = GifFrame(frame.duration, texture);
      atlas.addFrame(gifFrame);
    }
    if (cacheId != null) {
      gifCache[cacheId] = atlas;
    }
    return atlas;
  }

  static Future<GTexture> loadNetworkTextureSimple(
    String url, {
    int? width,
    int? height,
    double resolution = 1.0,
    String? cacheId,
  }) async {
    if (cacheId != null && textureCache.containsKey(cacheId)) {
      return textureCache[cacheId]!;
    }
    Uint8List bytes;
    try {
      bytes = await httpGet(url);
      final codec = await ui.instantiateImageCodec(
        bytes,
        allowUpscaling: false,
        targetWidth: width,
        targetHeight: height,
      );
      final image = (await codec.getNextFrame()).image;
      final texture = GTexture.fromImage(image, resolution);
      if (cacheId != null) {
        textureCache[cacheId] = texture;
      }
      return texture;
    } finally {
      throw FlutterError('Unable to texture $url.');
    }
  }

  static Future<SvgData> loadNetworkSvg(
    String url, {
    String? cacheId,
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    final response = await NetworkImageLoader.loadSvg(
      url,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
    if (response.isError) {
      throw FlutterError(
          'Unable to load SVG $url.\nReason: ${response.reasonPhrase}');
    }
    if (response.isSvg && cacheId != null) {
      svgCache[cacheId] = response.svgData!;
    }
    return response.svgData!;
  }

  static Future<GTexture> loadNetworkTexture(
    String url, {
    int? width,
    int? height,
    double resolution = 1.0,
    String? cacheId,
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    if (cacheId != null && textureCache.containsKey(cacheId)) {
      return textureCache[cacheId]!;
    }
    final response = await NetworkImageLoader.load(
      url,
      width: width,
      height: height,
      scale: resolution,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
    if (response.isError) {
      throw FlutterError(
          'Unable to load network texture $url.\nReason: ${response.reasonPhrase}');
    }
    if (response.isImage && cacheId != null) {
      textureCache[cacheId] = response.texture!;
    }
    return response.texture!;
  }

  static Future<FragmentProgram> loadShader(String path,
      [String? cacheId]) async {
    if (shaderCache.containsKey(cacheId)) {
      return shaderCache[cacheId]!;
    }
    final program = await FragmentProgram.fromAsset(path);
    if (cacheId != null) shaderCache[cacheId] = program;
    return program;
  }

  static Future<GTexture> loadTexture(
    String path, [
    double resolution = 1.0,
    String? cacheId,
  ]) async {
    if (cacheId != null && textureCache.containsKey(cacheId)) {
      return textureCache[cacheId]!;
    }
    var texture = GTexture.fromImage(await loadImage(path), resolution);
    if (cacheId != null) {
      textureCache[cacheId] = texture;
    }
    return texture;
  }

  static Future<SvgData> loadSvg(
    String path, [
    String? cacheId,
  ]) async {
    cacheId ??= path;
    svgCache[cacheId] =
        await SvgUtils.svgDataFromString(await loadString(path));
    return svgCache[cacheId]!;
  }

  static Future<GTextureAtlas> loadTextureAtlas(
    String imagePath, {
    String? dataPath,
    double resolution = 1.0,
    String? cacheId,
  }) async {
    if (cacheId != null && atlasCache.containsKey(cacheId)) {
      return atlasCache[cacheId]!;
    }
    if (dataPath == null) {
      /// if no index at the end, guess it.
      var lastIndex = imagePath.lastIndexOf('.');
      if (lastIndex == -1) {
        lastIndex = imagePath.length;
      }
      var basePath = imagePath.substring(0, lastIndex);
      dataPath = '$basePath.xml';
      if (kDebugMode) {
        print('Warning: using default xml data: $dataPath');
      }
    }
    var texture = await ResourceLoader.loadTexture(imagePath, resolution);
    var xmlData = await ResourceLoader.loadString(dataPath);
    final atlas = GTextureAtlas(texture, xmlData);
    if (cacheId != null) {
      atlasCache[cacheId] = atlas;
    }
    return atlas;
  }

  static Future<ByteData> loadBinary(String path) async {
    return await rootBundle.load(path);
  }

  /// load local assets.
  static Future<ui.Image> loadImage(
    String path, {
    int? targetWidth,
    int? targetHeight,
  }) async {
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);
    final codec = await ui.instantiateImageCodec(
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
