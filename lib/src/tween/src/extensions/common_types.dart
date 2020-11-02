part of gtween;

extension GTweenDoubleExt on double {
  GTweenableDouble get twn => GTweenableDouble(this);
}

extension GTweenIntExt on int {
  GTweenableInt get twn => GTweenableInt(this);
}

extension GTweenMapExt on Map<String, dynamic> {
  GTweenableMap get twn => GTweenableMap(this);
}

extension GTweenListExt on List {
  GTweenableList get twn => GTweenableList(this);
}
