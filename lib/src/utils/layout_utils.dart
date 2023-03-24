/// roipeker 2021
import 'package:flutter/widgets.dart';

import '../../graphx.dart';

/// Utility class for layout operations in GraphX.
///
/// Provides methods for laying out display objects in columns, rows, and
/// grids, as well as for resizing and positioning display objects within
/// a container.
class LayoutUtils {
  /// Debug color for visualizing layout bounds
  static Color debugColor = kColorMagenta.withOpacity(.1);

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory LayoutUtils() {
    throw UnsupportedError(
      "Cannot instantiate LayoutUtils. Use only static methods.",
    );
  }

  // Private constructor to prevent instantiation
  //LayoutUtils._();

  /// Arranges the [items] vertically in a single column, similar to Flutter's
  /// [Column], with optional [gap] between them. The column will start at the
  /// [startX] and [startY] position. The [width] and [height] of the column can
  /// be specified, but at least one of them must be greater than 0. The
  /// [axisAlign] parameter controls how the items are aligned along the
  /// vertical axis, while the [crossAlign] parameter controls how they are
  /// aligned along the horizontal axis. If [mask] is set to true, the parent
  /// container of the items will be clipped to the specified width and
  /// [height]. If [debug] is set to true, a red rectangle will be drawn around
  /// the column for debugging purposes.
  ///
  /// Make sure all items belongs to the same parent.
  static void col(
    List<GDisplayObject> items, {
    double gap = 0,
    double startX = 0,
    double startY = 0,
    double width = 0,
    double height = 0,
    MainAxisAlignment axisAlign = MainAxisAlignment.start,
    CrossAxisAlignment crossAlign = CrossAxisAlignment.start,
    bool mask = false,
    bool debug = false,
  }) {
    var currentY = .0, maxW = .0, maxH = .0, itemsH = .0;
    final numItems = items.length;
    if (numItems == 0) {
      return;
    }

    /// default to start.
    for (var i = 0; i < numItems; ++i) {
      var itm = items[i];
      itm.y = startY + currentY;
      itm.x = startX;
      maxW = Math.max(maxW, itm.width);
      var itmH = itm.height;
      itemsH += itmH;
      currentY += itmH + gap;
    }

    if (width <= 0) {
      width = maxW;
    }

    final parent = items.first.parent as GSprite?;
    final hasSize = width > 0 && height > 0;
    if (debug && parent != null && hasSize) {
      final g = parent.graphics;
      g.beginFill(debugColor).drawRect(startX, startY, width, height).endFill();
    }

    maxH = currentY - gap;
    currentY = 0;
    if (mask && parent != null && hasSize) {
      parent.maskRect = GRect(startX, startY, width, height);
    }
    if (crossAlign == CrossAxisAlignment.center) {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + (width - itm.width) / 2;
      }
    } else if (crossAlign == CrossAxisAlignment.end) {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + width - itm.width;
      }
    }

    if (axisAlign == MainAxisAlignment.center) {
      var centerY = (height - maxH) / 2;
      startY += centerY;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + currentY;
        currentY += itm.width + gap;
      }
    } else if (axisAlign == MainAxisAlignment.end) {
      startY += height - maxH;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + currentY;
        currentY += itm.height + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceEvenly) {
      /// calculate gap.
      gap = (height - itemsH) / (numItems + 1);
      startY += gap;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + currentY;
        currentY += itm.height + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceBetween) {
      gap = (height - itemsH) / (numItems - 1);
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + currentY;
        currentY += itm.height + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceAround) {
      gap = (height - itemsH) / (numItems);
      startY += gap / 2;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + currentY;
        currentY += itm.height + gap;
      }
    }
  }

  /// Simplistic grid approach that requires you pass the amount of [cols].
  ///
  /// Positions the display objects in a grid layout, with the number of rows
  /// and columns specified by [rows] and [cols], respectively.
  ///
  /// If [width] and [height] are defined, the items will be positioned within
  /// the specified bounds. Otherwise, the items will be positioned using the
  /// maximum dimensions of the items in the list.
  ///
  /// [gapX] and [gapY] specify the gap between the items, and [startX] and
  /// [startY] specify the starting position of the first item.
  static void grid(
    List<GDisplayObject> items, {
    double gapX = 0,
    double gapY = 0,
    int rows = 0,
    required int cols,
    double width = 0,
    double height = 0,
    double startX = 0,
    double startY = 0,
  }) {
    final numItems = items.length;

    /// calculate max item width.
    var maxItemW = .0, maxItemH = .0;

    /// default to start.
    for (var i = 0; i < numItems; ++i) {
      var itm = items[i];
      maxItemW = Math.max(itm.width, maxItemW);
      maxItemH = Math.max(itm.height, maxItemH);
    }
    for (var i = 0; i < numItems; ++i) {
      var itm = items[i];
      var idx = i % cols;
      var idy = i ~/ cols;
      itm.x = startX + idx * (maxItemW + gapX);
      itm.y = startY + idy * (maxItemH + gapY);
    }
  }

  /// Resizes and positions [object] inside a container defined by [canvasW] and
  /// [canvasH]. If [objW] and [objH] are provided, they should be the original
  /// size of the asset. The [fit] parameter works similar to BoxFit in Flutter.
  /// If [reposition] is true, the object will be centered in the container
  /// after resizing.
  static void objectFit(
    GDisplayObject object, {
    BoxFit fit = BoxFit.cover,
    double? objW,
    double? objH,
    required double canvasW,
    required double canvasH,
    bool reposition = false,
  }) {
    if (objW == null || objH == null) {
      /// calculate real objects bounds.
      if (object is GBitmap) {
        objW ??= object.texture!.width;
        objH ??= object.texture!.height;
      } else {
        final bounds = object.bounds!;
        objW ??= bounds.width;
        objH ??= bounds.height;
      }
    }
    var r1 = objW! / objH!;
    var r2 = canvasW / canvasH;
    // Determine resize behavior based on fit parameter
    if (fit == BoxFit.scaleDown) {
      fit = objW > canvasW || objH > canvasH ? BoxFit.contain : BoxFit.none;
    }

    if (fit == BoxFit.cover) {
      if (r2 > r1) {
        object.width = canvasW;
        object.scaleY = object.scaleX;
      } else {
        object.height = canvasH;
        object.scaleX = object.scaleY;
      }
    } else if (fit == BoxFit.contain) {
      if (r1 > r2) {
        object.width = canvasW;
        object.scaleY = object.scaleX;
      } else {
        object.height = canvasH;
        object.scaleX = object.scaleY;
      }
    } else if (fit == BoxFit.fill) {
      object.width = canvasW;
      object.height = canvasH;
    } else if (fit == BoxFit.none) {
      object.width = objW;
      object.height = objH;
    } else if (fit == BoxFit.fitHeight) {
      object.height = canvasH;
      object.scaleX = object.scaleY;
    } else if (fit == BoxFit.fitWidth) {
      object.width = canvasW;
      object.scaleY = object.scaleX;
    }

    // Reposition object if requested
    if (reposition) {
      if (object.pivotX == 0) {
        object.x = (canvasW - object.width) / 2;
        object.y = (canvasH - object.height) / 2;
      } else {
        object.x = canvasW / 2;
        object.y = canvasH / 2;
      }
    }
  }

  /// Arranges the [items] horizontally in a single row, similar to Flutter's
  /// [Row], with optional [gap] between them. The row will start at the
  /// [startX] and [startY] position. The [width] and [height] of the row can be
  /// specified, but at least one of them must be greater than 0. The
  /// [axisAlign] parameter controls how the items are aligned along the
  /// horizontal axis, while the [crossAlign] parameter controls how they are
  /// aligned along the vertical axis. If [mask] is set to true, the parent
  /// container of the items will be clipped to the specified [width] and
  /// [height]. If [debug] is set to true, a red rectangle will be drawn around
  /// the row for debugging purposes. Make sure all items belongs to the same
  /// parent.
  static void row(
    List<GDisplayObject> items, {
    double gap = 0,
    double startX = 0,
    double startY = 0,
    double width = 0,
    double height = 0,
    MainAxisAlignment axisAlign = MainAxisAlignment.start,
    CrossAxisAlignment crossAlign = CrossAxisAlignment.start,
    bool mask = false,
    bool debug = false,
  }) {
    var currentX = .0, maxH = .0, maxW = .0, itemsW = .0;
    final numItems = items.length;
    if (numItems == 0) {
      return;
    }

    /// default to start.
    for (var i = 0; i < numItems; ++i) {
      var itm = items[i];
      itm.y = startY;
      itm.x = startX + currentX;
      maxH = Math.max(maxH, itm.height);
      var itmW = itm.width;
      if (itm is GText && itmW.isInfinite) {
        itmW = itm.textWidth;
      }
      itemsW += itmW;
      currentX += itmW + gap;
    }

    if (height <= 0) {
      height = maxH;
    }

    final parent = items.first.parent as GSprite?;
    final hasSize = width > 0 && height > 0;
    if (debug && parent != null && hasSize) {
      final g = parent.graphics;
      g.beginFill(debugColor).drawRect(startX, startY, width, height).endFill();
    }

    maxW = currentX - gap;
    currentX = 0;
    if (mask && parent != null && hasSize) {
      parent.maskRect = GRect(startX, startY, width, height);
    }
    if (crossAlign == CrossAxisAlignment.center) {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + (height - itm.height) / 2;
      }
    } else if (crossAlign == CrossAxisAlignment.end) {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.y = startY + height - itm.height;
      }
    }

    if (axisAlign == MainAxisAlignment.center) {
      var centerX = (width - maxW) / 2;
      startX += centerX;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + currentX;
        var itmW = itm.width;
        if (itm is GText && itmW.isInfinite) {
          itmW = itm.textWidth;
        }
        currentX += itmW + gap;
      }
    } else if (axisAlign == MainAxisAlignment.end) {
      startX += width - maxW;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + currentX;
        var itmW = itm.width;
        if (itm is GText && itmW.isInfinite) {
          itmW = itm.textWidth;
        }
        currentX += itmW + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceEvenly) {
      /// calculate gap.
      gap = (width - itemsW) / (numItems + 1);
      startX += gap;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + currentX;
        var itmW = itm.width;
        if (itm is GText && itmW.isInfinite) {
          itmW = itm.textWidth;
        }
        currentX += itmW + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceBetween) {
      gap = (width - itemsW) / (numItems - 1);
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + currentX;
        var itmW = itm.width;
        if (itm is GText && itmW.isInfinite) {
          itmW = itm.textWidth;
        }
        currentX += itmW + gap;
      }
    } else if (axisAlign == MainAxisAlignment.spaceAround) {
      gap = (width - itemsW) / (numItems);
      startX += gap / 2;
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + currentX;
        var itmW = itm.width;
        if (itm is GText && itmW.isInfinite) {
          itmW = itm.textWidth;
        }
        currentX += itmW + gap;
      }
    }
  }

  /// Wraps a list of display objects either horizontally or vertically,
  /// depending on whether [width] or [height] is defined.
  ///
  /// If [width] is defined, the display objects are wrapped horizontally, with
  /// [gapX] specifying the gap between objects. If [height] is defined, the
  /// display objects are wrapped vertically, with [gapY] specifying the gap
  /// between objects.
  ///
  /// The starting position of the first object can be set using [startX] and
  /// [startY].
  ///
  /// Throws an assertion error if neither [width] nor [height] is defined.
  static void wrap(
    List<GDisplayObject> items, {
    double gapX = 0,
    double gapY = 0,
    double width = 0,
    double height = 0,
    double startX = 0,
    double startY = 0,
  }) {
    assert(width > 0 || height > 0);
    final numItems = items.length;
    var cx = .0, cy = .0, lineS = .0;
    if (width <= 0) {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + cx;
        itm.y = startY + cy;
        lineS = Math.max(itm.width, lineS);
        cy += itm.height;
        if (cy < height) {
          cy += gapY;
        } else {
          cy = 0;
          cx += (lineS + gapX);
          lineS = 0;
        }
      }
    } else {
      for (var i = 0; i < numItems; ++i) {
        var itm = items[i];
        itm.x = startX + cx;
        itm.y = startY + cy;
        lineS = Math.max(itm.height, lineS);
        cx += itm.width;
        if (cx < width) {
          cx += gapX;
        } else {
          cx = 0;
          cy += (lineS + gapY);
          lineS = 0;
        }
      }
    }
  }
}
