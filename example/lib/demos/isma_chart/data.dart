import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

final smallText = TextStyle(
  color: const Color(0xff333333),
  fontSize: 9,
  fontWeight: FontWeight.w600,
);

final valueTextStyle = TextStyle(
  color: const Color(0xff333333),
  fontSize: 6,
  fontWeight: FontWeight.w600,
);

late List<double> cfrData;

Future<void> loadJson() async {
  // var id = 'assets/isma_chart/chart_data.json';
  /// mmm, not usable it seems.
  // var str = await rootBundle.loadString(id);
  buildData();
}

void buildData() {
  cfrData = List.generate(5, (index) {
    return Math.randomRange(4, 100);
  });
}

class DotDataModel {
  double? value;
  String year = '2020';
  String value2 = '11';
  String name = 'Ismail';
  GPoint coordinate = GPoint();

  @override
  String toString() {
    return 'DotDataModel {value: $value, year: $year, value2: $value2, name: $name}';
  }
}
