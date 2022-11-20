import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import '../../graphx.dart';

typedef NetworkEventCallback = Function(NetworkImageEvent);

/// Utility class to load Network Images.
/// Doesn't handle CORS on web.
class NetworkImageEvent {
  int bytesLoaded = 0;

  /// only svg responses.
  String? svgString;
  SvgData? svgData;

  double get percentLoaded => bytesLoaded / contentLength!;
  Image? image;
  double scale = 1;

  GTexture? _texture;
  final http.BaseResponse response;

  GTexture? get texture {
    if (image == null) return null;
    _texture ??= GTexture.fromImage(image!, scale);
    return _texture;
  }

  NetworkImageEvent(this.response);

  bool get isImage => image != null;
  bool get isSvg => svgString != null;

  int? get contentLength => response.contentLength;
  int get statusCode => response.statusCode;
  String? get reasonPhrase => response.reasonPhrase;
  http.BaseRequest? get request => response.request;
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
    int? width,
    int? height,
    double scale = 1,
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    final completer = Completer<NetworkImageEvent>();
    var loadedBytes = <int>[];
    var bytesLoaded = 0;

    var request = http.Request('GET', Uri.parse(url));
    // _request.headers['Referrer Policy'] = 'no-referrer-when-downgrade';
    var response = _client.send(request);
    void dispatchError(NetworkImageEvent eventData) {
      if (onError != null) {
        onError.call(eventData);
        completer.complete(eventData);
      } else {
        completer.completeError(eventData);
      }
    }

    response.asStream().listen(
      (r) {
        var eventData = NetworkImageEvent(r);
        eventData.scale = scale;
        r.stream.listen(
          (chunk) {
            loadedBytes.addAll(chunk);
            bytesLoaded += chunk.length;
            eventData.bytesLoaded = bytesLoaded;
            onProgress?.call(eventData);
          },
          onError: (error) {
            dispatchError(eventData);
          },
          onDone: () async {
            if (eventData.isError) {
              dispatchError(eventData);
              return;
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
            //TODO fix this
            // return eventData;

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
          },
        );
      },
    );
    return completer.future;
  }

  static Future<NetworkImageEvent> loadSvg(
    String url, {
    NetworkEventCallback? onComplete,
    NetworkEventCallback? onProgress,
    NetworkEventCallback? onError,
  }) async {
    final completer = Completer<NetworkImageEvent>();
    var loadedBytes = <int>[];
    var bytesLoaded = 0;
    var request = http.Request('GET', Uri.parse(url));
    var response = _client.send(request);
    void dispatchError(NetworkImageEvent eventData) {
      if (onError != null) {
        onError.call(eventData);
        completer.complete(eventData);
      } else {
        completer.completeError(eventData);
      }
    }

    response.asStream().listen((r) {
      var eventData = NetworkImageEvent(r);
      eventData.scale = 1.0;
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
          return;
        }
        var svgString = utf8.decode(Uint8List.fromList(loadedBytes));
        eventData.svgString = svgString;
        eventData.svgData = await SvgUtils.svgDataFromString(svgString);
        onComplete?.call(eventData);
        completer.complete(eventData);
      });
    });
    return completer.future;
  }
}
