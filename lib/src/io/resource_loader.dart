import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import '../../graphx.dart';
import 'network_image_loader.dart';

/// This class is used to load and cache different types of resources, including
/// SVG files, images, shaders, and texture atlases. It also provides a method
/// to clear the cache of all loaded resources.
abstract class ResourceLoader {
  /// A static cache of SVG data. The cache is a map, where the key is a unique
  /// identifier for the SVG, and the value is an instance of the [SvgData]
  /// class.
  static Map<String, SvgData> svgCache = <String, SvgData>{};

  /// A static cache of fragment shaders. The cache is a map, where the key is a
  /// unique identifier for the shader, and the value is an instance of the
  /// [FragmentProgram] class.
  static Map<String, FragmentProgram> shaderCache = <String, FragmentProgram>{};

  /// A static cache of texture data. The cache is a map, where the key is a
  /// unique identifier for the texture, and the value is an instance of the
  /// [GTexture] class.
  static Map<String, GTexture> textureCache = <String, GTexture>{};

  /// A static cache of texture atlases. The cache is a map, where the key is a
  /// unique identifier for the atlas, and the value is an instance of the
  /// [GTextureAtlas] class.
  static Map<String, GTextureAtlas> atlasCache = <String, GTextureAtlas>{};

  /// A static cache of GIF images. The cache is a map, where the key is a
  /// unique identifier for the GIF, and the value is an instance of the
  /// [GifAtlas] class.
  static Map<String, GifAtlas> gifCache = <String, GifAtlas>{};

  /// Clears all loaded resource caches.
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

  /// Retrieves a cached [GTextureAtlas] instance associated with the given
  /// [cacheId]. Returns null if no [GTextureAtlas] is found.
  static GTextureAtlas? getAtlas(String cacheId) {
    return atlasCache[cacheId];
  }

  /// Retrieves a cached [GifAtlas] instance associated with the given
  /// [cacheId]. Returns null if no [GifAtlas] is found.
  static GifAtlas? getGif(String cacheId) {
    return gifCache[cacheId];
  }

  /// Returns the loaded fragment shader program corresponding to the given
  /// [cacheId]. If the [cacheId] is not present in the [shaderCache], null is
  /// returned.
  static FragmentProgram? getShader(String cacheId) {
    return shaderCache[cacheId];
  }

  /// This method returns an [SvgData] instance for a given cacheId, or null if
  /// the cacheId is not present in the [svgCache] cache.
  static SvgData? getSvg(String cacheId) {
    return svgCache[cacheId];
  }

  /// This method returns a [GTexture] instance for a given cacheId, or null if
  /// the cacheId is not present in the [textureCache] cache.
  static GTexture? getTexture(String cacheId) {
    return textureCache[cacheId];
  }

  /// Loads a binary file from local assets.
  ///
  /// The [path] argument is the path to the binary file to be loaded.
  ///
  /// Returns a [Future] that completes with a [ByteData] object.
  static Future<ByteData> loadBinary(String path) async {
    return await rootBundle.load(path);
  }

  /// Loads a [GifAtlas] instance from the given asset [path]. If a [cacheId] is
  /// provided, the resulting [GifAtlas] is stored in the cache with the given
  /// ID. If the [cacheId] already exists in the cache, the cached [GifAtlas] is
  /// returned. The [resolution] parameter controls the scaling of the gif's
  /// frames.
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

  /// Loads an image from local assets.
  ///
  /// The [path] argument is the path to the image file to be loaded. The
  /// optional [targetWidth] and [targetHeight] arguments can be used to specify
  /// the maximum width and height of the loaded image.
  ///
  /// Returns a [Future] that completes with a [ui.Image] object.
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

  /// Loads a JSON file from local assets.
  ///
  /// The [path] argument is the path to the JSON file to be loaded.
  ///
  /// Returns a [Future] that completes with a parsed JSON object.
  static Future<dynamic> loadJson(String path) async {
    final str = await loadString(path);
    return jsonDecode(str);
  }

  /// Loads an SVG from a network URL and returns a [SvgData] object. The SVG is
  /// loaded asynchronously, and the returned [Future] is completed with the
  /// [SvgData] object when the SVG is fully loaded. If [cacheId] is provided,
  /// the loaded SVG will be added to the SVG cache using [cacheId] as the key.
  ///
  /// Throws a [FlutterError] if the SVG cannot be loaded.
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

  /// Loads a network texture from the given URL with optional [width], [height],
  /// [resolution], and [cacheId]. If the texture is already in the cache, it is
  /// returned directly. Otherwise, the texture is downloaded and converted into
  /// a [GTexture] instance.
  ///
  /// Throws a [FlutterError] if the texture can't be loaded.
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
        'Unable to load network texture $url.\nReason: ${response.reasonPhrase}',
      );
    }
    if (response.isImage && cacheId != null) {
      textureCache[cacheId] = response.texture!;
    }
    return response.texture!;
  }

  /// Loads an image from a network URL and returns a [GTexture] object. The
  /// image is loaded asynchronously, and the returned [Future] is completed
  /// with the [GTexture] object when the image is fully loaded. The [width] and
  /// [height] parameters can be used to resize the image. The [resolution]
  /// parameter can be used to scale the image. If [cacheId] is provided, the
  /// loaded texture will be added to the texture cache using [cacheId] as the
  /// key. If the [cacheId] already exists in the cache, the cached texture will
  /// be returned instead.
  ///
  /// Throws a [FlutterError] if the image cannot be loaded.
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

  /// Loads a shader program from the given [path]. If the program is already in
  /// the cache, it is returned directly. Otherwise, the program is loaded from
  /// the given path and stored in the cache (with the optional [cacheId]) for
  /// future use.
  static Future<FragmentProgram> loadShader(String path,
      [String? cacheId]) async {
    if (shaderCache.containsKey(cacheId)) {
      return shaderCache[cacheId]!;
    }
    final program = await FragmentProgram.fromAsset(path);
    if (cacheId != null) shaderCache[cacheId] = program;
    return program;
  }

  /// Loads a string (plain text) file from local assets.
  ///
  /// The [path] argument is the path to the string file to be loaded.
  ///
  /// Returns a [Future] that completes with a [String] object.
  static Future<String> loadString(String path) async {
    return await rootBundle.loadString(path);
  }

  /// A static method to load an SVG image from a file.
  ///
  /// This method takes the [path] to the SVG file and an optional [cacheId]. If
  /// the [cacheId] is not null it will return the cached SVG data. Otherwise,
  /// it will load the SVG.
  static Future<SvgData> loadSvg(
    String path, [
    String? cacheId,
  ]) async {
    cacheId ??= path;
    svgCache[cacheId] =
        await SvgUtils.svgDataFromString(await loadString(path));
    return svgCache[cacheId]!;
  }

  /// Loads a texture from the given [path] with optional [resolution] and
  /// [cacheId].
  /// If the texture is already in the cache, it is returned directly.
  /// Otherwise, the image at the given path is loaded and converted into a
  /// [GTexture] instance.
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

  /// Loads a texture atlas from an image and XML/JSON data file.
  ///
  /// The [imagePath] argument is the path to the image file, while the optional
  /// [dataPath] argument is the path to the XML data file. The [resolution]
  /// argument sets the resolution of the texture. The [cacheId] argument sets
  /// the ID to be used to cache the texture atlas in memory.
  ///
  /// If the [cacheId] argument is not `null`, and there is a texture atlas
  /// already cached with the same ID, this method will return the cached atlas
  /// instead of loading a new one.
  ///
  /// If the [dataPath] argument is not provided, this method will attempt to
  /// guess the path to the XML data file based on the [imagePath] argument.
  ///
  /// Returns a [Future] that completes with a [GTextureAtlas] object.
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
}
