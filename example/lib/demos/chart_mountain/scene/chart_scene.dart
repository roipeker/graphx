import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../chart_data.dart';
import 'chart_graph.dart';
import 'chart_title.dart';

class SampleMountainChart extends GSprite {
  late MyGraph graph;
  late GraphTitle titles;

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  @override
  void addedToStage() {
    stage!.showBoundsRect = true;
    graph = MyGraph(data: sampleGraphData);
    graph.x = 40;
    graph.y = 20;
    addChild(graph);

    titles = GraphTitle(data: sampleGraphData);
    addChild(titles);
    titles.alignPivot(Alignment.centerRight);
    var startX = graph.graphW + graph.x;
    titles.x = startX + (sw - startX - 20);
    titles.y = sh / 2;
  }
}
