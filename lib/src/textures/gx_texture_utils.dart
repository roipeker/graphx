abstract class GxTextureUtils {
  static bool isValidTextureSize(int size) {
    return getNextValidTextureSize(size) == size;
  }

  static int getNextValidTextureSize(int size) {
    int _size = 1;
    while (size > _size) _size *= 2;
    return _size;
  }

  static int getPreviousValidTextureSize(int size) {
    return getNextValidTextureSize(size) >> 1;
  }

  static int getNearestValidTextureSize(int size) {
    final prev = getPreviousValidTextureSize(size);
    final next = getNextValidTextureSize(size);
    return size - prev < next - size ? prev : next;
  }
}
