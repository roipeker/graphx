

import '../../graphx.dart';

abstract class ListUtils {
  static void mergeSort(List<DisplayObject> input, SortChildrenCallback compare,
      int startIndex, int len, List<DisplayObject> buffer) {
    if (len > 1) {
      int i,
          endIndex = startIndex + len,
          halfLen = len ~/ 2,
          l = startIndex,
          r = startIndex + halfLen;
      //
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
