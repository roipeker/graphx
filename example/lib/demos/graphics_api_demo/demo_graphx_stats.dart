import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/src/gameutils/gameutils.dart';
import 'package:graphx/graphx.dart';


class DemoGraphXStats extends RootScene {
  @override
  void init() {
    owner.core.config.usePointer = true;
    owner.core.config.painterWillChange = true;
    owner.core.config.painterIsComplex = true;
  }

  @override
  void ready() {
    super.ready();
    stage.scene.core.resumeTicker();
    stage.scene.needsRepaint = true;
    addChild(MyGraph());
  }
}

class MyGraph extends Sprite {
  double w = 400;
  double h = 300;

  MyGraph() {
    onAddedToStage.addOnce(init);
  }

  void init() {
    StaticText.defaultTextStyle = StaticText.getStyle(
      color: Colors.grey.shade800,
      fontSize: 12,
    );

    var numRows = 8;
    var numCols = 7;
    var rowHeight = 50.0;
    graphics.lineStyle(0, 0x0, .3);

    var mainTitle = StaticText(text: 'Average Sales per Person');
    addChild(mainTitle);
    mainTitle.setTextStyle(StaticText.getStyle(
      color: Colors.black,
      fontSize: 16,
    ));
    mainTitle.alignPivot(Alignment.bottomCenter);
    mainTitle.x = w / 2;
    mainTitle.y = -16;

    var revenueText = StaticText(text: 'Revenue');
    addChild(revenueText);
    revenueText.alignPivot(Alignment.bottomCenter);
    revenueText.x = -50;
    h = (numRows - 1) * rowHeight;
    revenueText.y = h / 2;
    revenueText.rotation = deg2rad(-90);
    for (var i = 0; i < numRows; ++i) {
      var value = (numRows - i) * 10;
      var myRowText = StaticText();
      myRowText.text = '$value' + 'M';
      myRowText.y = i * rowHeight;
      myRowText.x = -10;
      myRowText.alignPivot(Alignment.centerRight);
      addChild(myRowText);
      graphics.moveTo(0, i * rowHeight);
      graphics.lineTo(w, i * rowHeight);
    }

    var yearsSprite = Sprite();
    addChild(yearsSprite);
    yearsSprite.graphics.lineStyle(0, 0x0, .3);
    yearsSprite.y = numCols * rowHeight;
    var colSep = 60.0;
    var halfColSep = colSep / 2;
    var startYear = 2000;
    for (var i = 0; i < numCols; ++i) {
      var value = startYear + i;
      var myRowText = StaticText();
      myRowText.text = '$value';
      if (i > 0) {
        myRowText.alignPivot(Alignment.topCenter);
      }
      double posX = i * colSep;
      myRowText.x = posX;
      myRowText.y = 8;
      yearsSprite.graphics.moveTo(posX, 0);
      yearsSprite.graphics.lineTo(posX, 5);
      yearsSprite.addChild(myRowText);
      myRowText.validate();
    }

    /// reference the persons.

    var footer = Sprite();
    addChild(footer);
    footer.y = yearsSprite.y + yearsSprite.height + 24;

    void addName(String name, int color) {
      var currentX = footer.width;
      var ico = GxIcon(Icons.person, color, 18.0);
      ico.x = currentX;
      footer.addChild(ico);
      var tf = buildStaticText(name + ' ' * 4, Colors.black, 11, footer);
      tf.y = 2;
      tf.x = ico.x + ico.width;
      tf.validate();
    }

    addName('John', 0x54BAAE);
    addName('Andrew', 0x404041);
    addName('Thomas', 0x467CCC);
    footer.x = (w - footer.width) / 2;

    /// create data graph!
    var data1 =
        List.generate(numCols * 2, (index) => GameUtils.rndRange(.4, .7));
    var data2 =
        List.generate(numCols * 2, (index) => GameUtils.rndRange(.3, .8));
    var data3 =
        List.generate(numCols * 2, (index) => GameUtils.rndRange(.1, .4));

    var dotsShape = Shape();
    var linesShape = Shape();
    addChild(linesShape);
    addChild(dotsShape);

    void drawGraph(List<double> data, int color) {
      final total = data.length;
      dotsShape.graphics.beginFill(Colors.white.value);
      dotsShape.graphics.lineStyle(1.5, color);
      linesShape.graphics.lineStyle(1.5, color);
      for (var i = 0; i < total; ++i) {
        var percentY = data[i];
        double px = i * halfColSep;
        double py = percentY * h;
        dotsShape.graphics.drawCircle(px, py, 2.5);
        if (i == 0) {
          linesShape.graphics.moveTo(px, py);
        } else {
          linesShape.graphics.lineTo(px, py);
        }
      }
      dotsShape.graphics.endFill();
      linesShape.graphics.endFill();
    }

    Shape createBigDot(int color, Sprite container) {
      var dot = Shape();
      dot.graphics.beginFill(color, .25).drawCircle(0, 0, 10).endFill();
      dot.graphics
          .beginFill(0xffffff)
          .lineStyle(2, color, 1)
          .drawCircle(0, 0, 5)
          .endFill();
      container.addChild(dot);
      return dot;
    }

    drawGraph(data1, 0x54BAAE);
    drawGraph(data2, 0x404041);
    drawGraph(data3, 0x467CCC);

    var graphAreaSprite = Sprite();
    addChild(graphAreaSprite);
    graphAreaSprite.graphics.beginFill(0x0, 0);
    graphAreaSprite.graphics.drawRect(0, 0, w, h);
    graphAreaSprite.graphics.endFill();

    var overlayContainer = new Sprite();
    addChild(overlayContainer);
    overlayContainer.graphics.lineStyle(0, 0x0);
    overlayContainer.graphics.moveTo(0, 0);
    overlayContainer.graphics.lineTo(0, h);

    /// add 3 dots
    var bigDots = [
      createBigDot(0x54BAAE, overlayContainer),
      createBigDot(0x404041, overlayContainer),
      createBigDot(0x467CCC, overlayContainer),
    ];

    void positionY(int idx, double value) {
      bigDots[idx].y = value * h;
    }

    var tooltip = TooltipOverlay();
    overlayContainer.addChild(tooltip);
    tooltip.x = 12;

    double targetTooltipY = 0;
    stage.onEnterFrame.add(() {
      tooltip.y += (targetTooltipY - tooltip.y) / 2;
      tooltip.pivotY = tooltip.y - tooltip.h < 0 ? 0 : tooltip.h;
    });

    graphAreaSprite.onHover.add((e) {
      /// select index from the data.
      double percentX = e.stagePosition.x / w;
      targetTooltipY = e.stagePosition.y;

      var totalPoints = data1.length;
      int pointIndex = (percentX * (totalPoints - 1)).round();
      var halfSep = colSep / 2;

      var px = halfSep * pointIndex;
      positionY(0, data1[pointIndex]);
      positionY(1, data2[pointIndex]);
      positionY(2, data3[pointIndex]);

      int offsetYear = (percentX * numCols).floor();
      tooltip.setYear(startYear + offsetYear);
      tooltip.setData(data1[pointIndex], data2[pointIndex], data3[pointIndex]);

      overlayContainer.x = px;
      if (overlayContainer.x + tooltip.w >= w) {
        tooltip.pivotX = tooltip.w + tooltip.x * 2;
      } else {
        tooltip.pivotX = 0;
      }
    });
  }
}

class TooltipOverlay extends Sprite {
  double w, h;

  StaticText title;
  double _itemH;
  double titlebarHeight = 26.0;
  double lineSep = 16.0;

  TooltipOverlay([this.w = 115, this.h = 105]) {
    init();
  }

  void init() {
    var bg = Shape();
    addChild(bg);

    bg.graphics
        .lineStyle(0, 0xffffff, .1)
        .beginFill(0x0, .67)
        .drawRoundRect(0, 0, w, h, 4)
        .endFill();
    title = StaticText(
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
      textStyle: StaticText.getStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      width: w,
    );
    title.alignPivot();
    title.setPosition(w / 2, titlebarHeight / 2);
    addChild(title);
    title.text = '2001';
    bg.graphics
        .lineStyle(1, 0xffffff, 1)
        .moveTo(lineSep, titlebarHeight)
        .lineTo(w - lineSep, titlebarHeight)
        .endFill();
//    alignPivot(Alignment.bottomLeft);

    _itemH = (h - titlebarHeight) / 3;
    _buildItem(0x467CCC, 'Thomas', '3M');
    _buildItem(0x404041, 'Andrew', '3M');
    _buildItem(0x54BAAE, 'John', '3M');
  }

  void setYear(int year) {
    title.text = year.toString();
  }

  List<Sprite> items = [];

  void _buildItem(int color, String name, String value) {
    int index = items.length;
    var item = Sprite();

    /// dot graphics
    var dot = Shape();
    dot.graphics
        .beginFill(color)
        .lineStyle(1, Colors.grey.shade200.value, .8)
        .drawCircle(0, 0, 5)
        .endFill();
    item.addChild(dot);

    var title = StaticText(
        textStyle: StaticText.getStyle(
      color: Colors.grey.shade200.withOpacity(.8),
      fontSize: 11,
      fontWeight: FontWeight.w400,
    ));
    title.text = name + ':';
    title.x = dot.width / 2 + 8;
    item.addChild(title);
    title.alignPivot(Alignment.centerLeft);

    var quantity = StaticText(
        textStyle: StaticText.getStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ));
    title.validate();
    quantity.name = 'quantity';
    quantity.text = value;
    quantity.x = title.x + title.textWidth + 4;
    item.addChild(quantity);
    quantity.alignPivot(Alignment.centerLeft);

    item.y = titlebarHeight + (index * _itemH) + _itemH / 2;
    item.x = lineSep;
    addChild(item);
    items.add(item);
  }

  void setValueItem(int index, double value) {
    var valueString = (10 + value * 70).round().toString() + 'M';
    var quantity = items[index].getChildByName('quantity') as StaticText;
    quantity.text = valueString;
  }

  void setData(double p1, double p2, double p3) {
    /// from 10 to 80m.
    setValueItem(0, p1);
    setValueItem(1, p2);
    setValueItem(2, p3);
  }
}

/// global methods

StaticText buildStaticText(String text, Color color,
    [double fontSize = 11, DisplayObjectContainer doc]) {
  var tf = StaticText(
      text: text,
      textStyle: StaticText.getStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ));
//  title.x = dot.width / 2 + 8;
  if (doc != null) doc.addChild(tf);
  return tf;
}

Shape createBigDot(int color, Sprite container, [bool createHalo = true]) {
  var dot = Shape();
  if (createHalo) {
    dot.graphics.beginFill(color, .25).drawCircle(0, 0, 10).endFill();
  }
  dot.graphics
      .beginFill(0xffffff)
      .lineStyle(2, color, 1)
      .drawCircle(0, 0, 5)
      .endFill();
  container.addChild(dot);
  return dot;
}
