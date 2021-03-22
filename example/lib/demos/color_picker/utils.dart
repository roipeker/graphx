import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

/// we could just use global mps emitter from graphx.
final pickerMPS = ColorPickerEmitter();

/// still not widget builder for MPS... so we need a notifier to interact
/// with the Widgets.
final pickerNotifier = ValueNotifier(Colors.black);

class ColorPickerEmitter extends MPS {
  static const changeHue = 'changeHue';
  static const changeValue = 'changeValue';
}

Color getPixelColor(
  ByteData rgbaImageData,
  int imageWidth,
  int imageHeight,
  int x,
  int y,
) {
  final byteOffset = x * 4 + y * imageWidth * 4;
  final r = rgbaImageData.getUint8(byteOffset);
  final g = rgbaImageData.getUint8(byteOffset + 1);
  final b = rgbaImageData.getUint8(byteOffset + 2);
  final a = rgbaImageData.getUint8(byteOffset + 3);
  return Color.fromARGB(a, r, g, b);
}

Future<ByteData?> getImageBytes(GDisplayObject object) async {
  var texture = await object.createImageTexture(true, 1);
  var data = texture.root!.toByteData(format: ImageByteFormat.rawRgba);
  // texture?.dispose();
  // texture = null;
  return data;
}
