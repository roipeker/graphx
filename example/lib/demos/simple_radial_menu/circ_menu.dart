import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class SimpleRadialMenuMain extends StatelessWidget {
  const SimpleRadialMenuMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SceneBuilderWidget(
        builder: () => SceneController(front: SimpleRadialMenuScene()),
      ),
    );
  }
}

class SimpleRadialMenuScene extends GSprite {
  GSprite container = GSprite();

  final icons = [
    Icons.accessibility,
    Icons.close,
    Icons.colorize,
    Icons.restore,
    Icons.access_time_outlined,
    Icons.assignment_late_rounded,
  ];

  final itemSize = 50.0;
  final itemColor = Colors.blueAccent;
  final mainCircleRadius = 80.0;
  final List<GSprite> items = [];

  bool isOpen = true;

  @override
  void addedToStage() {
    var container = GSprite();
    addChild(container);

    items.clear();
    var mainCircle = createCircle(
      label: 'MAIN',
      size: itemSize * 1.5,
      iconData: Icons.menu,
      onPressed: toggleMenu,
    );
    container.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
    var numItems = icons.length;
    var angleStep = Math.PI * 2 / numItems;
    var angleOffset = -Math.PI / 2;
    for (var i = 0; i < numItems; ++i) {
      var circle = createCircle(
        label: 'ITEM $i',
        size: itemSize,
        iconData: icons[i],
        onPressed: (input) {
          trace("You clicked item $i");
        },
      );
      items.add(circle);
      container.addChild(circle);
      container.addChild(mainCircle);

      var angle = angleOffset + i * angleStep;
      circle.x = Math.cos(angle) * mainCircleRadius;
      circle.y = Math.sin(angle) * mainCircleRadius;
      circle.userData = GPoint(circle.x, circle.y);
    }
  }

  GSprite createCircle({
    String? label,
    required double size,
    required IconData iconData,
    Function(MouseInputData input)? onPressed,
  }) {
    var item = GSprite();
    var text = GText(
      text: label,
      paragraphStyle: ParagraphStyle(textAlign: TextAlign.center),
    );
    text.width = size;
    text.setTextStyle(const TextStyle(
      color: Colors.white,
      fontSize: 10,
    ));

    var bg = GShape();
    bg.graphics.beginFill(itemColor).drawCircle(0, 0, size / 2).endFill();
    text.alignPivot();

    var icon = GIcon(iconData, Colors.white, size / 2);
    icon.alignPivot();
    icon.y = -8;
    text.y = icon.y + icon.height / 2 + text.height / 2;

    item.addChild(bg);
    item.addChild(text);
    item.addChild(icon);

    item.mouseChildren = false;
    if (onPressed != null) {
      item.onMouseDown.add(onPressed);
    }
    item.onMouseOver.add((input) {
      item.scale = 1.3;
      item.onMouseOut.addOnce((input) {
        item.scale = 1;
      });
    });
    return item;
  }

  void toggleMenu(MouseInputData input) {
    isOpen = !isOpen;
    for (var i = 0; i < items.length; ++i) {
      final itm = items[i];
      var point = itm.userData as GPoint?;
      itm.tween(
        duration: .3,
        x: isOpen ? point!.x : 0,
        y: isOpen ? point!.y : 0,
      );
      // itm.x = isOpen ? point.x : 0;
      // itm.y = isOpen ? point.y : 0;
    }
    // items.forEach((c) {
    //   c.visible = isOpen;
    // });
  }
}
