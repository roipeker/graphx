import 'dart:ui';

const graphData3 = <double>[138, 110, 142, 100, 108, 124, 109];
const graphData2 = <double>[95, 78, 90, 56, 40, 36, 28];
const graphData1 = <double>[13, 22, 57, 33, 26, 22, 14];

const sampleGraphData = <GraphModel>[
  GraphModel(data: graphData3, color: Color(0xff9BBB5A), name: 'Plant 3'),
  GraphModel(data: graphData2, color: Color(0xffC0514E), name: 'Plant 2'),
  GraphModel(data: graphData1, color: Color(0xff5082BD), name: 'Plant 1'),
];

class GraphModel {
  final List<double>? data;
  final Color? color;
  final String? name;
  const GraphModel({this.data, this.color, this.name});
}
