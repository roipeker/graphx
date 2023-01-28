import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../data.dart';
import 'chart_cell.dart';
import 'chart_sprite.dart';

class ChartScene extends GSprite {
  late GSprite boxCFR1;
  late GSprite boxCFR2;
  late ChartTableCell boxCell;
  late Chart boxLineChart;

  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;

  double get chartH => stage!.stageHeight - monthYearBarH;
  double monthYearBarH = 26;

  late GText cfr1;
  late GText monthYear;
  late GSprite cfr2;

  double valuesYW = 17;

  @override
  Future<void> addedToStage() async {
    await loadJson();

    //// on the left side.
    boxCFR1 = GSprite();
    cfr1 = GText(
      text: 'CFR(%)',
      textStyle: smallText,
    );
    monthYear = GText(
      text: 'Month and Year',
      textStyle: smallText,
    );
    monthYear.validate();
    monthYear.alignPivot();
    monthYear.y = chartH + monthYearBarH / 2;
    monthYear.x = sw / 2;
    addChild(monthYear);

    boxCFR1.graphics
        .beginFill(Colors.red.withOpacity(0.001))
        .drawRect(0, 0, 17, chartH)
        .endFill();
    cfr1.alignPivot();
    cfr1.rotation = deg2rad(-90);
    cfr1.y = chartH / 2;
    cfr1.x = boxCFR1.width / 2;
    boxCFR1.addChild(cfr1);
    addChild(boxCFR1);

    //// on the right side.
    boxCFR2 = GSprite();
    boxCFR2.graphics
        .beginFill(Colors.red.withOpacity(.001))
        .drawRect(0, 0, 50, chartH)
        .endFill();
    addChild(boxCFR2);
    boxCFR2.x = sw - boxCFR2.width;
    var lbl = GText(
      text: 'CFR(%)',
      textStyle: smallText,
    );
    lbl.alignPivot(Alignment.centerLeft);
    lbl.x = 16;
    cfr2 = GSprite();
    cfr2.addChild(lbl);
    cfr2.graphics
        .lineStyle(1.5, Colors.orange)
        .moveTo(0, 0)
        .lineTo(14, 0)
        .endFill()
        .beginFill(Colors.orange)
        .drawCircle(7, 0, 3);
    cfr2.y = chartH / 2;
    boxCFR2.addChild(cfr2);

    _buildYValues();
    _buildCells();

    boxLineChart = Chart(this);
    boxLineChart.maxValueY = 100;
    boxLineChart.initDraw(
      w: boxCell.w,
      h: chartH - boxCell.h,
      cols: boxCell.colValues.length,
      rows: 6,
    );
    boxLineChart.drawData(cfrData);
    boxLineChart.x = boxCell.x;
  }

  late GSprite valuesYContainer;

  void _buildYValues() {
    valuesYContainer = GSprite();
    addChild(valuesYContainer);
    var valuesYH = chartH - cellH;
    valuesYContainer.x = boxCFR1.x + boxCFR1.width;
    valuesYContainer.graphics
        .beginFill(Colors.green.withOpacity(.2))
        .drawRect(0, 0, valuesYW, valuesYH)
        .endFill();

    var numValues = 6; //0, 20, 40, 60, 80, 100
    // 0, 1, 2, 3, 4, 5
    var valuesSep = valuesYH / (numValues - 1);
    List.generate(numValues, (index) {
      var value = ((numValues - 1) - index) * 20;
      var tf = GText(
        text: '$value',
        textStyle: valueTextStyle,
      );
      tf.alignPivot(Alignment.centerRight);
      tf.x = valuesYW - 4;
      tf.y = index * valuesSep;
      valuesYContainer.addChild(tf);
    });
  }

  double cellH = 26;

  void _buildCells() {
    boxCell = ChartTableCell(this);
    var leftX = valuesYContainer.x + valuesYContainer.width;
    boxCell.initDraw(w: sw - leftX - boxCFR2.width, h: cellH);
    boxCell.colValues = [8, 3, 6, 7, 8];
    boxCell.drawData();
    boxCell.x = leftX;
    boxCell.y = chartH - boxCell.h;
  }
}
