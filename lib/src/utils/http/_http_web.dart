// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// Fetches an HTTP resource from the specified
/// [url] using the specified [headers].
Future<Uint8List> httpGet(String url, {Map<String, String>? headers}) async {
  final request = await html.HttpRequest.request(url,
      requestHeaders: headers, responseType: 'arraybuffer');
  if (request.status != html.HttpStatus.ok) {
    throw 'Could not get network asset: "$url"';
  }
  return Uint8List.view(request.response);
}
