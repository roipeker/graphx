import 'dart:typed_data';
import 'dart:ui';

import '../../graphx.dart';

/// Class that holds information about a graphic element's vertices data.
/// Internal usage of [Graphics]
class GraphicsVertices {
  /// The vertices list of the element.
  List<double> vertices;

  /// The uvtData of the element.
  List<double>? uvtData;

  /// The adjusted uvtData of the element.
  List<double>? adjustedUvtData;

  /// The colors of the element.
  List<int>? colors;

  /// The indices of the element.
  List<int>? indices;

  /// The blend mode of the element.
  BlendMode? blendMode;

  /// The vertex mode of the element.
  VertexMode? mode;

  /// The path of the element, computed from the vertices data.
  Path? _path;

  /// The bounds of the element.
  Rect? _bounds;

  /// Boolean value that indicates if the uvtData is normalized or not.
  late bool _normalizedUvt;

  /// The raw data points of the element.
  Float32List? _rawPoints;

  /// The culling mode applied to the element.
  Culling culling;

  /// The raw data of the element, as an instance of [ui.Vertices].
  Vertices? _rawData;

  /// Creates a new instance of [GraphicsVertices].
  /// TODO: check if uvt requires normalization.
  GraphicsVertices(
    this.mode,
    this.vertices, [
    this.indices,
    this.uvtData,
    this.colors,
    this.blendMode = BlendMode.src,
    this.culling = Culling.positive,
  ]) {
    _normalizedUvt = false;
    final len = uvtData?.length ?? 0;
    if (uvtData != null && len > 6) {
      for (var i = 0; i < 6; ++i) {
        if (uvtData![i] <= 2.0) {
          _normalizedUvt = true;
        }
      }
      if (uvtData![len - 2] <= 2.0 || uvtData![len - 1] <= 2.0) {
        _normalizedUvt = true;
      }
    }
  }

  /// Returns the raw data of the element, as an instance of [ui.Vertices].
  ///
  /// If the [_rawData] property is null, computes and returns the raw data.
  Vertices? get rawData {
    if (_rawData != null) {
      return _rawData;
    }
    // calculateCulling();
    Float32List? textureCoordinates;
    Int32List? newColors;
    Uint16List? newIndices;
    if (uvtData != null && adjustedUvtData != null) {
      textureCoordinates =
          Float32List.fromList(adjustedUvtData as List<double>);
    }
    if (colors != null) {
      newColors = Int32List.fromList(colors!);
    }
    if (indices != null) {
      newIndices = Uint16List.fromList(indices!);
    }
    _rawData = Vertices.raw(
      VertexMode.triangles,
      Float32List.fromList(vertices),
      textureCoordinates: textureCoordinates,
      colors: newColors,
      indices: newIndices,
    );
    return _rawData;
  }

  /// Gets the raw points data of the [TriangleVertices].
  /// If the [_rawPoints] is not null, then it returns that value.
  /// Note that the raw points list is cached and reused if possible.
  /// Returns null if [_points] is null or empty.
  Float32List? get rawPoints {
    if (_rawPoints != null) {
      return _rawPoints;
    }
    final points = GraphicsVerticesUtils.getTrianglePoints(this);
    return _rawPoints = Float32List.fromList(points as List<double>);
  }

  /// Calculates the culling for the element.
  ///
  /// Calculates the culling of the triangles defined by the [vertices] and [indices] properties
  /// of the element, and assigns the result to the [culling] property.
  void calculateCulling() {
    var i = 0;
    var offsetX = 0.0, offsetY = 0.0;
    var ind = indices;
    var v = vertices;
    var l = indices!.length;
    while (i < l) {
      var a = i;
      var b = i + 1;
      var c = i + 2;

      var iax = ind![a] * 2;
      var iay = ind[a] * 2 + 1;
      var ibx = ind[b] * 2;
      var iby = ind[b] * 2 + 1;
      var icx = ind[c] * 2;
      var icy = ind[c] * 2 + 1;

      var x1 = v[iax] - offsetX;
      var y1 = v[iay] - offsetY;
      var x2 = v[ibx] - offsetX;
      var y2 = v[iby] - offsetY;
      var x3 = v[icx] - offsetX;
      var y3 = v[icy] - offsetY;

      switch (culling) {
        case Culling.positive:
          if (!GraphicsVerticesUtils.isCCW(x1, y1, x2, y2, x3, y3)) {
            i += 3;
            continue;
          }
          break;

        case Culling.negative:
          if (GraphicsVerticesUtils.isCCW(x1, y1, x2, y2, x3, y3)) {
            i += 3;
            continue;
          }
          break;
      }

      /// TODO: finish implementation.
      i += 3;
    }
  }

  /// Computes the adjusted UV texture coordinates from the [uvtData] property.
  ///
  /// If the [uvtData] property is null, this method does nothing.
  /// If the [uvtData] property is normalized, this method scales the data to match the
  /// dimensions of the [shaderTexture] parameter.
  void calculateUvt(GTexture? shaderTexture) {
    if (uvtData == null) {
      return;
    }
    if (!_normalizedUvt) {
      adjustedUvtData = uvtData;
    } else {
      /// make a ratio of the image size
      final imgW = shaderTexture!.width ?? 0;
      final imgH = shaderTexture.height ?? 0;
      adjustedUvtData = List<double>.filled(uvtData!.length, 0.0);
      for (var i = 0; i < uvtData!.length; i += 2) {
        adjustedUvtData![i] = uvtData![i] * imgW;
        adjustedUvtData![i + 1] = uvtData![i + 1] * imgH;
      }
    }
  }

  /// Computes the path of the element.
  ///
  /// If [_path] is null, computes the path from the vertices data.
  Path computePath() {
    return _path ??= GraphicsVerticesUtils.getPathFromVertices(this);
  }

  /// Returns the bounds of the element.
  /// If [_bounds] is null, computes the bounds from the [_path] property.
  Rect? getBounds() {
    if (_bounds != null) {
      return _bounds;
    }
    _bounds = computePath().getBounds();
    return _bounds;
  }

  /// Resets the [_path], [_rawPoints] and [_bounds] properties of the element.
  void reset() {
    _path?.reset();
    _rawData = null;
    _bounds = null;
  }
}

/// A set of internal utility methods for the graphics module.
/// Internal usage of [Graphics]
abstract class GraphicsVerticesUtils {
  /// A helper path used to compute paths from vertices.
  static final Path _helperPath = Path();

  /// Computes a path from the [vertices] property of a [GraphicsVertices] element.
  ///
  /// This method creates a [Path] object, populates it with points from the [vertices] property
  /// of a [GraphicsVertices] object, and returns it.
  static Path getPathFromVertices(GraphicsVertices vertices) {
    var path = _helperPath;
    path.reset();
    final pos = vertices.vertices;
    var len = pos.length;
    final points = <Offset>[];
    for (var i = 0; i < len; i += 2) {
      points.add(Offset(pos[i], pos[i + 1]));
    }
    path.addPolygon(points, true);
    return path;
  }

  /// Computes a list of points that define a set of triangles from a [GraphicsVertices] element.
  ///
  /// This method creates a list of points that represent the triangles defined by the [vertices]
  /// and [indices] properties of a [GraphicsVertices] element, and returns it.
  static List<double?> getTrianglePoints(GraphicsVertices vertices) {
    var ver = vertices.vertices;
    var ind = vertices.indices;
    if (ind == null) {
      /// calculate
      var len = ver.length;
      var out = List<double>.filled(len * 2, 0.0);
      var j = 0;
      for (var i = 0; i < len; i += 6) {
        out[j++] = ver[i + 0];
        out[j++] = ver[i + 1];
        out[j++] = ver[i + 2];
        out[j++] = ver[i + 3];
        out[j++] = ver[i + 2];
        out[j++] = ver[i + 3];
        out[j++] = ver[i + 4];
        out[j++] = ver[i + 5];
        out[j++] = ver[i + 4];
        out[j++] = ver[i + 5];
        out[j++] = ver[i + 0];
        out[j++] = ver[i + 1];
      }
      return out;
    } else {
      var len = ind.length;
      var out = List<double>.filled(len * 4, 0.0);
      var j = 0;
      for (var i = 0; i < len; i += 3) {
        var i0 = ind[i + 0];
        var i1 = ind[i + 1];
        var i2 = ind[i + 2];
        var v0 = i0 * 2;
        var v1 = i1 * 2;
        var v2 = i2 * 2;
        out[j++] = ver[v0];
        out[j++] = ver[v0 + 1];
        out[j++] = ver[v1];
        out[j++] = ver[v1 + 1];
        out[j++] = ver[v1];
        out[j++] = ver[v1 + 1];
        out[j++] = ver[v2];
        out[j++] = ver[v2 + 1];
        out[j++] = ver[v2];
        out[j++] = ver[v2 + 1];
        out[j++] = ver[v0];
        out[j++] = ver[v0 + 1];
      }
      return out;
    }
  }

  /// Determines if three points in a 2D space are in counter-clockwise order.
  static bool isCCW(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
  }
}
