// To parse this JSON data, do
//
//     final waveformData = waveformDataFromJson(jsonString);

import 'dart:math';

class WaveformData {
  double framesPerSecond;

  WaveformData({
    this.version,
    this.channels,
    this.sampleRate,
    this.samplesPerPixel,
    this.bits,
    this.length,
    this.data,
  });

  int version;
  int channels;
  int sampleRate;
  int samplesPerPixel;
  int bits;
  int length;
  List<int> data;

  factory WaveformData.fromJson(Map<String, dynamic> json) => WaveformData(
        version: json["version"],
        channels: json["channels"],
        sampleRate: json["sample_rate"],
        samplesPerPixel: json["samples_per_pixel"],
        bits: json["bits"],
        length: json["length"],
        data: List<int>.from(json["data"]),
      );

  List<double> _normalizedData;
  List<double> _up = [];
  List<double> _down = [];

  //36658
  //146632
  //44100/256=172.265625x sec
  // 213.127906977

  void scaleData() {
    framesPerSecond = sampleRate / samplesPerPixel; // 172
//    var dd = (length / 2) ~/ framesPerSecond;
    var dd = length ~/ framesPerSecond;
    print('length:: $length // ${data.length}');
    print('my data::: ${Duration(seconds: dd)}');
    double maxValue = pow(2, bits - 1).toDouble();

    /// 2 channels?
    final len = data.length;
    _normalizedData = List(len);
    for (var i = 0; i < len; ++i) {
      double ratio = data[i].toDouble() / maxValue;
      _normalizedData[i] = ratio.clamp(-1.0, 1.0);
      if (i % 2 == 0) {
        _up.add(_normalizedData[i]);
      } else {
        _down.add(_normalizedData[i]);
      }
    }

    if (channels == 2) {
      final d = _normalizedData;
      for (var i = 0; i < len; i += 4) {
        chan1_min.add(d[i]);
        chan1_max.add(d[i + 1]);
        chan2_min.add(d[i + 2]);
        chan2_max.add(d[i + 3]);
      }
    }
  }

  List<double> chan1_min = [];
  List<double> chan1_max = [];
  List<double> chan2_min = [];
  List<double> chan2_max = [];

//  List<double> getTimes({double from, double to}) {}

  List<double> getFrames({int startFrame, int endFrame}) {
    final d = _normalizedData;
    final from = startFrame * 2;
    final end = endFrame * 2;
    return d.sublist(from, end);
  }

  int getIndex(double percent) {
    return (chan1_min.length * percent).round();
  }

  double getPositionDown(double percent) {
    var total = _down.length;
    var idx = (total * percent).round();
    return _down[idx];
  }

  double getPositionUp(double percent) {
//    var total = length / 2;
    var total = _up.length;
    var idx = (total * percent).round();
//    print(idx);
//    return _normalizedData.sublist(idx, idx + 2);
    return _up[idx];
//    _normalizedData[idx];
//    var idx = framesPerSecond
//    double second = 30.0;
//    List<double> sub = model.getFrames(
//      startFrame: 0,
//      endFrame: (model.framesPerSecond * (second)).toInt(),
//    );
//    var dat = (sub.length / 2) / model.framesPerSecond;
  }
}
