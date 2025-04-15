import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:ui';

import '../../graphx.dart';

/// A callback function that parses SVG string data into an [SvgData] object.
///
/// Used by [ResourceLoader] to convert raw SVG strings into renderable [SvgData] objects.
///
/// Parameters:
///   [svgData] - The raw SVG string to parse
/// Returns:
///   [SvgData] if parsing succeeds, null if parsing fails
typedef SvgStringToDataCallback = Future<SvgData?> Function(String svgData);

/// Manages loading and caching of various resource types including SVGs, images, shaders,
/// and texture atlases.
///
/// Key features:
/// - Caches resources to avoid reloading
/// - Supports local assets and network resources
/// - Handles SVG parsing and rendering
/// - Manages texture atlases and GIF animations
/// - Provides shader loading capabilities
///
/// Usage:
/// ```dart
/// // Load a texture from assets
/// final texture = await ResourceLoader.loadTexture('assets/image.png');
///
/// // Load and cache a network image
/// final networkTexture = await ResourceLoader.loadNetworkTexture(
///   'https://example.com/image.png',
///   cacheId: 'unique-id'
/// );
///
/// // Clear all cached resources
/// ResourceLoader.clearCache();
/// ```
abstract class ResourceLoader {
  /// Cache for raw SVG string data.
  /// Keys are unique identifiers, values are the SVG strings.
  static Map<String, String> svgStringCache = <String, String>{};

  /// Cache for parsed SVG data.
  /// Keys are unique identifiers, values are parsed [SvgData] objects.
  static final svgDataCache = <String, SvgData>{};

  /// Cache for fragment shader programs.
  /// Keys are unique identifiers, values are compiled [FragmentProgram] objects.
  static Map<String, FragmentProgram> shaderCache = <String, FragmentProgram>{};

  /// Cache for texture data.
  /// Keys are unique identifiers, values are [GTexture] instances.
  static Map<String, GTexture> textureCache = <String, GTexture>{};

  /// Cache for texture atlases.
  /// Keys are unique identifiers, values are [GTextureAtlas] instances.
  static Map<String, GTextureAtlas> atlasCache = <String, GTextureAtlas>{};

  /// Cache for GIF animations.
  /// Keys are unique identifiers, values are [GifAtlas] instances.
  static Map<String, GifAtlas> gifCache = <String, GifAtlas>{};

  /// Parser function for converting SVG strings to [SvgData].
  /// Must be set via [setSvgDataParser] before loading SVGs.
  /// Relies on the [graphx_svg_utils] package.
  static SvgStringToDataCallback? _svgDataParser;

  /// Sets the parser function used to convert SVG strings into [SvgData] objects.
  ///
  /// Must be called before attempting to load or parse any SVG resources.
  ///
  /// Parameters:
  ///   [callback] - The parsing function to use
  static void setSvgDataParser(SvgStringToDataCallback callback) {
    _svgDataParser = callback;
  }

  /// Clears all cached resources and disposes of any allocated memory.
  ///
  /// This includes:
  /// - SVG data and strings
  /// - Textures
  /// - Texture atlases
  /// - GIF animations
  static void clearCache() {
    for (var vo in svgDataCache.values) {
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
    svgDataCache.clear();
    svgStringCache.clear();
    textureCache.clear();
    gifCache.clear();
  }

  /// Retrieves a cached texture atlas by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the atlas
  /// Returns:
  ///   The [GTextureAtlas] if found, null otherwise
  static GTextureAtlas? getAtlas(String cacheId) {
    return atlasCache[cacheId];
  }

  /// Retrieves a cached GIF animation by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the GIF
  /// Returns:
  ///   The [GifAtlas] if found, null otherwise
  static GifAtlas? getGif(String cacheId) {
    return gifCache[cacheId];
  }

  /// Retrieves a cached shader program by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the shader
  /// Returns:
  ///   The [FragmentProgram] if found, null otherwise
  static FragmentProgram? getShader(String cacheId) {
    return shaderCache[cacheId];
  }

  /// Retrieves a cached SVG string by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the SVG string
  /// Returns:
  ///   The SVG string if found, null otherwise
  static String? getSvgString(String cacheId) {
    return svgStringCache[cacheId];
  }

  /// Retrieves cached SVG data by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the SVG data
  /// Returns:
  ///   The [SvgData] if found, null otherwise
  static SvgData? getSvgData(String cacheId) {
    return svgDataCache[cacheId];
  }

  /// Retrieves a cached texture by its ID.
  ///
  /// Parameters:
  ///   [cacheId] - The unique identifier for the texture
  /// Returns:
  ///   The [GTexture] if found, null otherwise
  static GTexture? getTexture(String cacheId) {
    return textureCache[cacheId];
  }

  /// Loads binary data from a local asset file.
  ///
  /// Parameters:
  ///   [path] - The asset path to load from
  /// Returns:
  ///   A [Future] completing with the loaded [ByteData]
  static Future<ByteData> loadBinary(String path) async {
    return await rootBundle.load(path);
  }

  /// Loads and caches a GIF animation from a local asset file.
  ///
  /// Parameters:
  ///   [path] - The asset path to the GIF file
  ///   [resolution] - Scale factor for the GIF frames (default: 1.0)
  ///   [cacheId] - Optional ID to cache the loaded GIF
  /// Returns:
  ///   A [Future] completing with the loaded [GifAtlas]
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

  /// Loads an image from a local asset file with optional resizing.
  ///
  /// Parameters:
  ///   [path] - The asset path to the image file
  ///   [targetWidth] - Optional maximum width for the loaded image
  ///   [targetHeight] - Optional maximum height for the loaded image
  /// Returns:
  ///   A [Future] completing with the loaded [ui.Image]
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

  /// Loads and parses a JSON file from a local asset.
  ///
  /// Parameters:
  ///   [path] - The asset path to the JSON file
  /// Returns:
  ///   A [Future] completing with the parsed JSON data
  static Future<dynamic> loadJson(String path) async {
    final str = await loadString(path);
    return jsonDecode(str);
  }

  /// Loads and optionally caches a texture from a network URL.
  ///
  /// Features:
  /// - Supports image resizing via [width] and [height]
  /// - Configurable resolution scaling
  /// - Progress tracking via callbacks
  /// - Automatic caching with [cacheId]
  ///
  /// Parameters:
  ///   [url] - The URL to load the image from
  ///   [width] - Optional target width
  ///   [height] - Optional target height
  ///   [resolution] - Scale factor for the texture (default: 1.0)
  ///   [cacheId] - Optional ID to cache the texture
  ///   [onComplete] - Called when loading completes
  ///   [onProgress] - Called with loading progress updates
  ///   [onError] - Called if loading fails
  /// Returns:
  ///   A [Future] completing with the loaded [GTexture]
  /// Throws:
  ///   [FlutterError] if loading fails
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

  /// Loads and parses an SVG from a network URL into [SvgData].
  ///
  /// Features:
  /// - Automatic caching with [cacheId]
  /// - Progress tracking via callbacks
  /// - Built-in SVG parsing
  ///
  /// Parameters:
  ///   [url] - The URL to load the SVG from
  ///   [cacheId] - Optional ID to cache the parsed SVG
  ///   [onComplete] - Called when loading completes
  ///   [onProgress] - Called with loading progress updates
  ///   [onError] - Called if loading fails
  /// Returns:
  ///   A [Future] completing with the parsed [SvgData]
  /// Throws:
  ///   [FlutterError] if loading fails or parser is not initialized
  static Future<SvgData> loadNetworkSvgData(
    String url, {
    String? cacheId,
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    if (svgDataCache.containsKey(cacheId)) {
      return svgDataCache[cacheId]!;
    }
    if (_svgDataParser == null) {
      throw FlutterError('You need to initialize the parser with '
          '[ResourceLoader.setSvgDataParser] callback first');
    }
    final svgString = await loadNetworkSvgString(
      url,
      cacheId: cacheId,
      onComplete: onComplete,
      onProgress: onProgress,
      onError: onError,
    );
    final svgData = await _svgDataParser!(svgString);
    if (svgData == null) {
      throw FlutterError(
        'Unable to parse SVG.\nstring data: $svgString',
      );
    }
    if (cacheId != null) {
      // only track valid svg strings.
      svgDataCache[cacheId] = svgData;
    }
    return svgData;
  }

  /// Loads an SVG string from a network URL.
  ///
  /// Features:
  /// - Automatic caching with [cacheId]
  /// - Progress tracking via callbacks
  ///
  /// Parameters:
  ///   [url] - The URL to load the SVG from
  ///   [cacheId] - Optional ID to cache the SVG string
  ///   [onComplete] - Called when loading completes
  ///   [onProgress] - Called with loading progress updates
  ///   [onError] - Called if loading fails
  /// Returns:
  ///   A [Future] completing with the SVG string
  /// Throws:
  ///   [FlutterError] if loading fails
  static Future<String> loadNetworkSvgString(
    String url, {
    String? cacheId,
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    if (cacheId != null && svgStringCache.containsKey(cacheId)) {
      return svgStringCache[cacheId]!;
    }
    final response = await NetworkImageLoader.loadSvgString(
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
      svgStringCache[cacheId] = response.svgString!;
    }
    return response.svgString!;
  }

  /// Simplified version of [loadNetworkTexture] without progress tracking.
  ///
  /// Features:
  /// - Supports image resizing
  /// - Configurable resolution scaling
  /// - Optional caching
  ///
  /// Parameters:
  ///   [url] - The URL to load the image from
  ///   [width] - Optional target width
  ///   [height] - Optional target height
  ///   [resolution] - Scale factor for the texture (default: 1.0)
  ///   [cacheId] - Optional ID to cache the texture
  /// Returns:
  ///   A [Future] completing with the loaded [GTexture]
  /// Throws:
  ///   [FlutterError] if loading fails
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
    // try {
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
    // } finally {
    //   throw FlutterError('Unable to texture $url.');
    // }
  }

  /// Loads and optionally caches a shader program from a local asset.
  ///
  /// Parameters:
  ///   [path] - The asset path to the shader file
  ///   [cacheId] - Optional ID to cache the shader program
  /// Returns:
  ///   A [Future] completing with the loaded [FragmentProgram]
  static Future<FragmentProgram> loadShader(String path,
      [String? cacheId]) async {
    if (shaderCache.containsKey(cacheId)) {
      return shaderCache[cacheId]!;
    }
    final program = await FragmentProgram.fromAsset(path);
    if (cacheId != null) shaderCache[cacheId] = program;
    return program;
  }

  /// Loads a text file from a local asset.
  ///
  /// Parameters:
  ///   [path] - The asset path to the text file
  /// Returns:
  ///   A [Future] completing with the loaded string
  static Future<String> loadString(String path) async {
    return await rootBundle.loadString(path);
  }

  /// Loads and optionally caches a texture from a local asset.
  ///
  /// Parameters:
  ///   [path] - The asset path to the image file
  ///   [resolution] - Scale factor for the texture (default: 1.0)
  ///   [cacheId] - Optional ID to cache the texture
  /// Returns:
  ///   A [Future] completing with the loaded [GTexture]
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

  /// Loads and optionally caches a texture atlas from image and data files.
  ///
  /// Features:
  /// - Supports XML and JSON data formats
  /// - Automatic data file path inference
  /// - Configurable resolution scaling
  /// - Optional caching
  ///
  /// Parameters:
  ///   [imagePath] - The asset path to the atlas image
  ///   [dataPath] - Optional path to the atlas data file (XML/JSON)
  ///   [resolution] - Scale factor for the atlas (default: 1.0)
  ///   [cacheId] - Optional ID to cache the atlas
  /// Returns:
  ///   A [Future] completing with the loaded [GTextureAtlas]
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
