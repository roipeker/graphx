import '../../graphx.dart';

/// A utility class for performing various operations on lists of
/// [GDisplayObject]s.
class ListUtils {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory ListUtils() {
    throw UnsupportedError(
      "Cannot instantiate ListUtils. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  ListUtils._();

  /// Sorts the given list of [GDisplayObject]s using the merge sort algorithm.
  /// The [compare] callback is used to determine the ordering of the elements.
  /// [startIndex] is the starting index of the sub-list to be sorted. [len] is
  /// the length of the sub-list to be sorted. [buffer] is a temporary buffer
  /// used for merging the sub-lists.
  static void mergeSort(
    List<GDisplayObject> input,
    SortChildrenCallback compare,
    int startIndex,
    int len,
    List<GDisplayObject> buffer,
  ) {
    if (len > 1) {
      int i,
          endIndex = startIndex + len,
          halfLen = len ~/ 2,
          l = startIndex,
          r = startIndex + halfLen;
      mergeSort(input, compare, startIndex, halfLen, buffer);
      mergeSort(input, compare, startIndex + halfLen, len - halfLen, buffer);
      for (i = 0; i < len; i++) {
        if (l < startIndex + halfLen &&
            (r == endIndex || compare(input[l], input[r]) <= 0)) {
          buffer[i] = input[l];
          l++;
        } else {
          buffer[i] = input[r];
          r++;
        }
      }
      // copy sorted sub list back to input.
      for (i = startIndex; i < endIndex; ++i) {
        input[i] = buffer[i - startIndex];
      }
    }
  }
}
