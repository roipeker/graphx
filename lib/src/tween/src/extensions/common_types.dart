part of gtween;

extension GTweenNumExt on num {
  GTweenableDouble get twn {
    return this is double ? GTweenableDouble(this) : GTweenableInt(this);
  }
}

extension GTweenDoubleExt on double {
  GTweenableDouble get twn => GTweenableDouble(this);
}

extension GTweenIntExt on int {
  GTweenableInt get twn => GTweenableInt(this);
}

extension GTweenMapExt on Map<String, dynamic> {
  GTweenableMap get twn => GTweenableMap(this);
}

extension GTweenMap2Ext on Map {
  GTweenableMap get twn => GTweenableMap(this);
}

extension GTweenListExt on List {
  GTweenableList get twn => GTweenableList(this);
}
