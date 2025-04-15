import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

import '../../graphx.dart';

/// A callback function to handle [NetworkImageEvent] events.
typedef NetworkEventCallback = Function(NetworkImageEvent);

/// Represents an event in the process of loading an image or SVG.
/// Warning: doesn't handle CORS on web.
class NetworkImageEvent {
  /// The number of bytes loaded so far.
  int bytesLoaded = 0;

  /// The SVG string data, if this event represents an SVG.
  String? svgString;

  /// The loaded image data, if this event represents an image.
  Image? image;

  /// The scale of the loaded image, which can be used to adjust its size.
  double scale = 1;

  /// The [GTexture] representing the loaded image, if it has been generated.
  GTexture? _texture;

  /// The HTTP response that triggered this event.
  final http.BaseResponse response;

  /// Creates a new [NetworkImageEvent] instance for the given [response].
  NetworkImageEvent(this.response);

  /// Returns the length of the response content, or null if it is unknown.
  int? get contentLength {
    return response.contentLength;
  }

  /// Returns the headers of the HTTP response.
  Map<String, String> get headers {
    return response.headers;
  }

  /// Returns true if this event represents an HTTP error.
  bool get isError {
    return statusCode > 300;
  }

  /// Returns true if this event represents an image.
  bool get isImage {
    return image != null;
  }

  /// Returns true if this event represents an SVG.
  bool get isSvg {
    return svgString != null;
  }

  /// The percentage of bytes loaded, as a decimal between 0 and 1.
  double get percentLoaded {
    return bytesLoaded / contentLength!;
  }

  /// Returns the reason phrase of the HTTP response.
  String? get reasonPhrase {
    return response.reasonPhrase;
  }

  /// Returns the HTTP request that triggered this event, if available.
  http.BaseRequest? get request {
    return response.request;
  }

  /// Returns the status code of the HTTP response.
  int get statusCode {
    return response.statusCode;
  }

  /// Returns the [GTexture] representing the loaded image, if it has been
  /// generated.
  GTexture? get texture {
    if (image == null) return null;
    _texture ??= GTexture.fromImage(image!, scale);
    return _texture;
  }

  /// Returns a string representation of this event.
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

/// This class provides methods for loading images and SVGs over the network
/// and returning the result as a `NetworkImageEvent`.
class NetworkImageLoader {
  /// The HTTP client to use for loading images and svgs.
  static final http.Client _client = http.Client();

  /// Loads an image from the specified [url] with the given [width], [height],
  /// and [scale], and returns a Completer that resolves the [NetworkImageEvent]
  /// upon completion.
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

  /// Loads an SVG from the specified [url] and returns a [NetworkImageEvent]
  /// upon completion.
  static Future<NetworkImageEvent> loadSvgString(
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
        final svgString = utf8.decode(Uint8List.fromList(loadedBytes));
        eventData.svgString = svgString;
        onComplete?.call(eventData);
        completer.complete(eventData);
      });
    });
    return completer.future;
  }
}
