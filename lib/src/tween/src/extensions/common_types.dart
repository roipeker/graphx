part of gtween;

/// An extension for the `double` class that provides a getter for creating a
/// [GTweenableDouble] object.
extension GTweenDoubleExt on double {
  /// Returns a [GTweenableDouble] object created from the current value.
  ///
  /// A new [GTweenableDouble] object is created using the current value as its
  /// initial value.
  GTweenableDouble get twn {
    return GTweenableDouble(this);
  }
}

/// An extension for the `int` class that provides a getter for creating a
/// [GTweenableInt] object.
extension GTweenIntExt on int {
  /// Returns a [GTweenableInt] object created from the current value.
  ///
  /// A new [GTweenableInt] object is created using the current value as its
  /// initial value.
  GTweenableInt get twn {
    return GTweenableInt(this);
  }
}

/// An extension for the `List` class that provides a getter for creating a
/// [GTweenableList] object.
extension GTweenListExt on List {
  /// Returns a [GTweenableList] object created from the current value.
  ///
  /// A new [GTweenableList] object is created using the current list as its
  /// initial value.
  GTweenableList get twn {
    return GTweenableList(this);
  }
}

/// An extension for the `Map` class that provides a getter for creating a
/// [GTweenableMap] object.
extension GTweenMap2Ext on Map {
  /// Returns a [GTweenableMap] object created from the current value.
  ///
  /// A new [GTweenableMap] object is created using the current map as its
  /// initial value.
  GTweenableMap get twn {
    return GTweenableMap(this);
  }
}

/// An extension for the `Map<String?, dynamic>` class that provides a getter
/// for creating a [GTweenableMap] object.
extension GTweenMapExt on Map<String?, dynamic> {
  /// Returns a [GTweenableMap] object created from the current value.
  ///
  /// A new [GTweenableMap] object is created using the current map as its
  /// initial value.
  GTweenableMap get twn {
    return GTweenableMap(this);
  }
}

/// An extension for the `num` class that provides a getter for creating a
/// [GTweenableDouble] object.
extension GTweenNumExt on num {
  /// Returns a [GTweenableDouble] object created from the current value.
  ///
  /// If the current value is a `double`, a new [GTweenableDouble] object is
  /// created using the current value as its initial value. If the current value
  /// is an `int`, a new [GTweenableInt] object is created using the current
  /// value as its initial value and then converted to a [GTweenableDouble].
  GTweenableDouble get twn {
    return this is double
        ? GTweenableDouble(this as double)
        : GTweenableInt(this as int) as GTweenableDouble;
  }
}
