part of gtween;

extension GTweenNumExt on num {
  GTweenableDouble get twn => this is double
      ? GTweenableDouble(this as double)
      : GTweenableInt(this as int) as GTweenableDouble;
}

extension GTweenDoubleExt on double {
  GTweenableDouble get twn => GTweenableDouble(this);
}

extension GTweenIntExt on int {
  GTweenableInt get twn => GTweenableInt(this);
}

extension GTweenMapExt on Map<String?, dynamic> {
  GTweenableMap get twn => GTweenableMap(this);
}

extension GTweenMap2Ext on Map {
  GTweenableMap get twn => GTweenableMap(this);
}

extension GTweenListExt on List {
  GTweenableList get twn => GTweenableList(this);
}
