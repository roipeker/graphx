import '../../graphx.dart';

/// Utility class for matrix transformation operations.
///
class MatrixUtils {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory MatrixUtils() {
    throw UnsupportedError(
      "Cannot instantiate MatrixUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  //MatrixUtils._();

  /// Returns the bounding rectangle of the specified [rect] after applying the
  /// specified [matrix] transformation.
  ///
  /// If the [out] parameter is provided, the result is stored in that object.
  /// Otherwise, a new [GRect] object is created and returned.
  static GRect getTransformedBoundsRect(
    GMatrix matrix,
    GRect rect, [
    GRect? out,
  ]) {
    out ??= GRect();
    double minX = 10000000.0;
    double maxX = -10000000.0;
    double minY = 10000000.0;
    double maxY = -10000000.0;
    final tx1 = matrix.a * rect.x + matrix.c * rect.y + matrix.tx;
    final ty1 = matrix.d * rect.y + matrix.b * rect.x + matrix.ty;
    final tx2 = matrix.a * rect.x + matrix.c * rect.bottom + matrix.tx;
    final ty2 = matrix.d * rect.bottom + matrix.b * rect.x + matrix.ty;
    final tx3 = matrix.a * rect.right + matrix.c * rect.y + matrix.tx;
    final ty3 = matrix.d * rect.y + matrix.b * rect.right + matrix.ty;
    final tx4 = matrix.a * rect.right + matrix.c * rect.bottom + matrix.tx;
    final ty4 = matrix.d * rect.bottom + matrix.b * rect.right + matrix.ty;
    if (minX > tx1) minX = tx1;
    if (minX > tx2) minX = tx2;
    if (minX > tx3) minX = tx3;
    if (minX > tx4) minX = tx4;
    if (minY > ty1) minY = ty1;
    if (minY > ty2) minY = ty2;
    if (minY > ty3) minY = ty3;
    if (minY > ty4) minY = ty4;
    if (maxX < tx1) maxX = tx1;
    if (maxX < tx2) maxX = tx2;
    if (maxX < tx3) maxX = tx3;
    if (maxX < tx4) maxX = tx4;
    if (maxY < ty1) maxY = ty1;
    if (maxY < ty2) maxY = ty2;
    if (maxY < ty3) maxY = ty3;
    if (maxY < ty4) maxY = ty4;
    out.setTo(minX, minY, maxX - minX, maxY - minY);
    return out;
  }

  /// Applies a skew transformation to the specified [matrix] using the
  /// specified [skewX] and [skewY] angles in radians.
  ///
  /// The [matrix] is updated with the skew transformation matrix.
  static void skew(GMatrix matrix, double skewX, double skewY) {
    final sinX = Math.sin(skewX);
    final cosX = Math.cos(skewX);
    final sinY = Math.sin(skewY);
    final cosY = Math.cos(skewY);
    matrix.setTo(
      matrix.a * cosY - matrix.b * sinX,
      matrix.a * sinY + matrix.b * cosX,
      matrix.c * cosY - matrix.d * sinX,
      matrix.c * sinY + matrix.d * cosX,
      matrix.tx * cosY - matrix.ty * sinX,
      matrix.tx * sinY + matrix.ty * cosX,
    );
  }
}
