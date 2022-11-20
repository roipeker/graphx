import 'dart:math' as math;

/// Port of AS3, grant skinner class.
/// https://blog.gskinner.com/archives/2007/12/colormatrix_cla.html

/// TODO: implement full usage.
/// sample (can be used in a custom Color Filter, check BlurFilter
/// implementation):
/// ```
/// final colorMatrix = ColorMatrix();
/// colorMatrix.adjustSaturation(1.0);
/// Paint()..colorFilter = ColorFilter.matrix( colorMatrix.storage );
/// ```
class ColorMatrix {
  static const List<double> kDeltaIndex = <double>[
    //
    0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11,
    //
    0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
    //
    0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
    //
    0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
    //
    0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
    //
    1.0, 1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
    //
    1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0, 2.12, 2.25,
    //
    2.37, 2.50, 2.62, 2.75, 2.87, 3.0, 3.2, 3.4, 3.6, 3.8,
    //
    4.0, 4.3, 4.7, 4.9, 5.0, 5.5, 6.0, 6.5, 6.8, 7.0,
    //
    7.3, 7.5, 7.8, 8.0, 8.4, 8.7, 9.0, 9.4, 9.6, 9.8,
    //
    10.0
  ];
  static const List<double> kIdentityMatrix = <double>[
    1, 0, 0, 0, 0,
    //
    0, 1, 0, 0, 0,
    //
    0, 0, 1, 0, 0,
    //
    0, 0, 0, 1, 0,
    //
    0, 0, 0, 0, 1,
  ];

  // ignore: non_constant_identifier_names
  static final int LENGTH = kIdentityMatrix.length;
  final _storage = List<double>.filled(25, 0);

  ColorMatrix([List<double> matrix = kIdentityMatrix]) {
    matrix = _fixMatrix(matrix);
    copyMatrix(((matrix.length == LENGTH) ? matrix : kIdentityMatrix));
  }

  // public methods:
  void reset() {
    for (var i = 0; i < LENGTH; i++) {
      _storage[i] = kIdentityMatrix[i];
    }
  }

  void adjustColor(
    double pBrightness,
    double pContrast,
    double pSaturation,
    double pHue,
  ) {
    adjustHue(pHue);
    adjustContrast(pContrast);
    adjustBrightness(pBrightness);
    adjustSaturation(pSaturation);
  }

  void adjustBrightness(double percent) {
    if (percent == 0 || percent.isNaN) return;
    if (percent >= -1 && percent <= 1) {
      percent *= 100;
    }
    percent = _cleanValue(percent, 100);
    multiplyMatrix([
      1, 0, 0, 0, percent,
      //
      0, 1, 0, 0, percent,
      //
      0, 0, 1, 0, percent,
      //
      0, 0, 0, 1, 0,
      //
      0, 0, 0, 0, 1,
    ]);
  }

  void adjustContrast(double percent) {
    if (percent == 0 || percent.isNaN) return;
    if (percent >= -1 && percent <= 1) {
      percent *= 100;
    }
    percent = _cleanValue(percent, 100);
    double x;
    final idx = percent.toInt();
    if (percent < 0) {
      x = 127 + percent / 100 * 127;
    } else {
      x = percent % 1;
      if (x == 0) {
        x = kDeltaIndex[idx];
      } else {
        //x = DELTA_INDEX[(p_val<<0)]; // this is how the IDE does it.
        x = kDeltaIndex[(idx << 0)] * (1 - x) +
            kDeltaIndex[(idx << 0) + 1] *
                x; // use linear interpolation for more granularity.
      }
      x = x * 127 + 127;
    }
    multiplyMatrix([
      //
      x / 127, 0, 0, 0, 0.5 * (127 - x),
      //
      0, x / 127, 0, 0, 0.5 * (127 - x),
      //
      0, 0, x / 127, 0, 0.5 * (127 - x),
      //
      0, 0, 0, 1, 0,
      //
      0, 0, 0, 0, 1,
    ]);
  }

  void adjustSaturation(double percent) {
    if (percent == 0 || percent.isNaN) return;
    if (percent >= -1 && percent <= 1) {
      percent *= 100;
    }
    percent = _cleanValue(percent, 100);
    var x = 1.0 + ((percent > 0) ? 3 * percent / 100 : percent / 100);
    const lumR = 0.3086;
    const lumG = 0.6094;
    const lumB = 0.0820;
    multiplyMatrix([
      //
      lumR * (1 - x) + x, lumG * (1 - x), lumB * (1 - x), 0, 0,
      //
      lumR * (1 - x), lumG * (1 - x) + x, lumB * (1 - x), 0, 0,
      //
      lumR * (1 - x), lumG * (1 - x), lumB * (1 - x) + x, 0, 0,
      //
      0, 0, 0, 1, 0,
      //
      0, 0, 0, 0, 1,
    ]);
  }

  void adjustHue(double percent) {
    if (percent == 0 || percent.isNaN) return;
    if (percent >= -1 && percent <= 1) {
      percent *= 180;
    }
    percent = _cleanValue(percent, 180) / 180 * math.pi;
    var cosVal = math.cos(percent);
    var sinVal = math.sin(percent);
    const lumR = 0.213;
    const lumG = 0.715;
    const lumB = 0.072;
    multiplyMatrix([
      //
      lumR + cosVal * (1 - lumR) + sinVal * -lumR,
      lumG + cosVal * -lumG + sinVal * -lumG,
      lumB + cosVal * -lumB + sinVal * (1 - lumB),
      0,
      0,
      //
      lumR + cosVal * -lumR + sinVal * 0.143,
      lumG + cosVal * (1 - lumG) + sinVal * 0.140,
      lumB + cosVal * -lumB + sinVal * -0.283,
      0,
      0,
      //
      lumR + cosVal * -lumR + sinVal * -(1 - lumR),
      lumG + cosVal * -lumG + sinVal * lumG,
      lumB + cosVal * (1 - lumB) + sinVal * lumB,
      0,
      0,
      //
      0, 0, 0, 1, 0,
      //
      0, 0, 0, 0, 1,
    ]);
  }

  void concat(List<double> pMatrix) {
    pMatrix = _fixMatrix(pMatrix);
    if (pMatrix.length != LENGTH) return;
    multiplyMatrix(pMatrix);
  }

  ColorMatrix clone() => ColorMatrix(_storage);

  @override
  String toString() => "ColorMatrix [ ${_storage.join(" , ")} ]";

  /// return a length 20 array (5x4):
  List<double?> get storage =>
      _storage.sublist(0, math.min(_storage.length, 20)).toList();

  /// private methods:
  /// copy the specified matrix's values to this matrix:
  void copyMatrix(List<double> pMatrix) {
    for (var i = 0; i < LENGTH; i++) {
      _storage[i] = pMatrix[i];
    }
  }

  /// multiplies one matrix against another:
  void multiplyMatrix(List<double> pMatrix) {
    var col = List<double>.filled(25, 0);

    for (var i = 0; i < 5; i++) {
      for (var j = 0; j < 5; j++) {
        col[j] = _storage[j + i * 5];
      }
      for (var j = 0; j < 5; j++) {
        var val = 0.0;
        for (var k = 0; k < 5; k++) {
          val += pMatrix[j + k * 5] * col[k];
        }
        _storage[j + i * 5] = val;
      }
    }
  }

  /// make sure values are within the specified range, hue has a limit of 180,
  /// others are 100:
  double _cleanValue(double pVal, double pLimit) =>
      math.min(pLimit, math.max(-pLimit, pVal));

  /// makes sure Matrices are 5x5 (25 long):
  List<double> _fixMatrix(List<double> pMatrix) {
    if (pMatrix.length < LENGTH) {
      pMatrix = List.from(pMatrix)
        ..addAll(kIdentityMatrix.getRange(pMatrix.length, LENGTH));
    } else if (pMatrix.length > LENGTH) {
      pMatrix = pMatrix.sublist(0, LENGTH);
    }
    return pMatrix;
  }
}
