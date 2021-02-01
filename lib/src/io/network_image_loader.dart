import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import '../../graphx.dart';
// import '../utils/svg_utils.dart';

/// Utility class to load Network Images.
/// Doesn't handle CORS on web.
class NetworkImageEvent {
  int bytesLoaded = 0;

  /// only svg responses.
  String svgString;
  SvgData svgData;

  double get percentLoaded => bytesLoaded / contentLength;
  Image image;
  double scale = 1;

  GTexture _texture;
  final http.BaseResponse response;

  GTexture get texture {
    if (image == null) return null;
    _texture ??= GTexture.fromImage(image, scale);
    return _texture;
  }

  NetworkImageEvent(this.response);

  bool get isImage => image != null;
  bool get isSvg => svgString != null;

  int get contentLength => response.contentLength;
  int get statusCode => response.statusCode;
  String get reasonPhrase => response.reasonPhrase;
  http.BaseRequest get request => response.request;
  Map<String, String> get headers => response.headers;
  bool get isError => statusCode > 300;

  @override
  String toString() {
    if (isError) {
      return 'ResponseData ERROR { statusCode: $statusCode, '
          'contentLength: $contentLength, bytesLoaded: $bytesLoaded, '
          'reasonPhrase: $reasonPhrase}';
    }
    return 'ResponseData { statusCode: $statusCode, '
        'contentLength: $contentLength, bytesLoaded: $bytesLoaded, '
        'reasonPhrase: $reasonPhrase, image: $image, scale: $scale}';
  }
}

class NetworkImageLoader {
  static final http.Client _client = http.Client();

  static Future<NetworkImageEvent> load(
    String url, {
    int width,
    int height,
    double scale = 1,
    Function(NetworkImageEvent) onComplete,
    Function(NetworkImageEvent) onProgress,
    Function(NetworkImageEvent) onError,
  }) async {
    Completer completer = Completer<NetworkImageEvent>();
    var loadedBytes = <int>[];
    var bytesLoaded = 0;

    var _request = http.Request('GET', Uri.parse(url));
    // _request.headers['Referrer Policy'] = 'no-referrer-when-downgrade';
    var response = _client.send(_request);
    void dispatchError(NetworkImageEvent eventData) {
      if (onError != null) {
        onError?.call(eventData);
        completer.complete(eventData);
      } else {
        completer.completeError(eventData);
      }
    }

    response.asStream().listen((r) {
      var eventData = NetworkImageEvent(r);
      eventData.scale = scale;
      r.stream.listen((chunk) {
        loadedBytes.addAll(chunk);
        bytesLoaded += chunk.length;
        eventData.bytesLoaded = bytesLoaded;
        onProgress?.call(eventData);
      }, onError: (error) {
        dispatchError(eventData);
      }, onDone: () async {
        if (eventData.isError) {
          dispatchError(eventData);
          return null;
        }
        var bytes = Uint8List.fromList(loadedBytes);
        final codec = await instantiateImageCodec(
          bytes,
          allowUpscaling: false,
          targetWidth: width,
          targetHeight: height,
        );
        eventData.image = (await codec.getNextFrame()).image;
        onComplete?.call(eventData);
        completer.complete(eventData);
        return eventData;
        // Save the file
        // File file = new File('$dir/$filename');
        // final Uint8List bytes = Uint8List(r.contentLength);
        // int offset = 0;
        // for (List<int> chunk in chunks) {
        //   bytes.setRange(offset, offset + chunk.length, chunk);
        //   offset += chunk.length;
        // }
        // await file.writeAsBytes(bytes);
        // return;
      });
    });
    return completer.future;
    // var result = await client.get(url);
    // var bytes = result.bodyBytes;
    // final codec = await instantiateImageCodec(
    //   bytes,
    //   allowUpscaling: false,
    //   targetWidth: width,
    //   targetHeight: height,
    // );
    // var img = (await codec.getNextFrame()).image;
    // callback?.call(img);
    // return img;
  }

  // static Future<NetworkImageEvent> loadSvg(
  //   String url, {
  //   Function(NetworkImageEvent) onComplete,
  //   Function(NetworkImageEvent) onProgress,
  //   Function(NetworkImageEvent) onError,
  // }) async {
  //   Completer completer = Completer<NetworkImageEvent>();
  //   var loadedBytes = <int>[];
  //   var bytesLoaded = 0;
  //   var _request = http.Request('GET', Uri.parse(url));
  //   var response = _client.send(_request);
  //   void dispatchError(NetworkImageEvent eventData) {
  //     if (onError != null) {
  //       onError?.call(eventData);
  //       completer.complete(eventData);
  //     } else {
  //       completer.completeError(eventData);
  //     }
  //   }
  //   response.asStream().listen((r) {
  //     var eventData = NetworkImageEvent(r);
  //     eventData.scale = 1.0;
  //     r.stream.listen((chunk) {
  //       loadedBytes.addAll(chunk);
  //       bytesLoaded += chunk.length;
  //       eventData.bytesLoaded = bytesLoaded;
  //       onProgress?.call(eventData);
  //     }, onError: (error) {
  //       dispatchError(eventData);
  //     }, onDone: () async {
  //       if (eventData.isError) {
  //         dispatchError(eventData);
  //         return null;
  //       }
  //       var bytes = Uint8List.fromList(loadedBytes);
  //       var svgString = utf8.decode(bytes);
  //       eventData.svgString = svgString;
  //       eventData.svgData = await SvgUtils.svgDataFromString(svgString);
  //       onComplete?.call(eventData);
  //       completer.complete(eventData);
  //       return eventData;
  //     });
  //   });
  //   return completer.future;
  // }
}
