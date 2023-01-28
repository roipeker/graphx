import '../../../utils/utils.dart';
import 'package:graphx/graphx.dart';
import '../chart_data.dart';
import 'utils.dart';

class MyGraph extends GSprite {
  GShape? graph;
  GSprite? chartContainer, titlesContainer;
  late GShape background;

  double minValueY = 0, maxValueY = 160, stepY = 20;
  List xRange = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];

  double graphW = 295;
  double graphH = 209;

  double lineSepY = 0.0, lineSepX = 0.0;
  int numLinesY = 0, numLinesX = 0;

  double minAlpha = .7;
  double maxAlpha = 1.0;
  final List<GraphModel>? data;
  MyGraph({this.data});

  @override
  void addedToStage() {
    background = GShape();
    addChild(background);

    chartContainer = GSprite();
    addChild(chartContainer!);

    numLinesY = ((minValueY + (maxValueY - minValueY)) ~/ stepY) + 1;
    numLinesX = xRange.length;
    lineSepY = graphH / (numLinesY - 1);
    lineSepX = graphW / (numLinesX - 1);
    drawBg();
    drawData();
  }

  void drawData() => sampleGraphData.forEach(createGraphData);

  GShape createGraphData(GraphModel data) {
    var graph = GShape();
    graph.mouseUseShape = true;
    graph.alpha = minAlpha;
    graph.onMouseOver.add((event) {
      graph.tween(duration: .2, alpha: maxAlpha);
      // graph.alpha = maxAlpha;
      graph.onMouseOut.addOnce((event) {
        graph.tween(duration: .4, alpha: minAlpha);
        // graph.alpha = minAlpha;
      });
    });

    var percentTween = 1.0.twn;

    graph.onMouseClick.add((event) {
      percentTween.tween(0.0,
          duration: .4,
          onUpdate: () => drawChart(data, graph, percentTween.value),
          ease: GEase.easeInExpo,
          onComplete: () {
            percentTween.tween(
              1.0,
              duration: .6,
              onUpdate: () => drawChart(data, graph, percentTween.value),
              ease: GEase.easeInOutExpo,
            );
          });
    });

    chartContainer?.addChild(graph);
    drawChart(data, graph);
    return graph;
  }

  void drawChart(GraphModel data, GShape graph, [double? percent = 1]) {
    var g = graph.graphics;
    g.clear();
    g.beginFill(data.color!);
    var list = data.data!;
    for (var i = 0; i < list.length; ++i) {
      final valuePercent = list[i] / maxValueY * percent!;
      final relY = graphH - valuePercent * graphH;
      var px = i * lineSepX;
      if (i == 0) {
        g.moveTo(0, relY);
      } else {
        g.lineTo(px, relY);
      }
    }
    g.lineTo(graphW, graphH);
    g.lineTo(0, graphH);
    g.closePath();
    g.endFill();
  }

  void drawBg() {
    var g = background.graphics;
    g.lineStyle(0, const Color(0xff868686));
    g.moveTo(0, 0);
    g.lineTo(0, graphH);

    var lineOffset = 5.0;

    for (var i = 0; i < numLinesY; ++i) {
      var py = i * lineSepY;
      g.moveTo(-lineOffset, py);
      g.lineTo(graphW, py);
      var invIndex = (numLinesY - i - 1);
      var valY = (stepY * invIndex).round();
      var lbl = createLabel('$valY');
      addChild(lbl);
      lbl.alignPivot(Alignment.centerRight);
      lbl.x = -lineOffset * 2;
      lbl.y = py;
    }

    for (var i = 0; i < numLinesX; ++i) {
      var px = i * lineSepX;
      g.moveTo(px, graphH);
      g.lineTo(px, graphH + lineOffset);
      var lbl = createLabel(xRange[i]);
      addChild(lbl);
      lbl.alignPivot(Alignment.topCenter);
      lbl.x = px;
      lbl.y = graphH + lineOffset * 2;
    }
  }
}
