import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'star.dart';

const Color kBgColor = Color(0xFFEBEDFD);
const Color kStarColor = Color(0xFFFCC915);
const Color kUnselectedSColor = Color(0xFF7F86AC);

class RatingStarsScene extends GSprite {
  double get sw => stage!.stageWidth;

  double get sh => stage!.stageHeight;
  late List<Star> stars;
  late GSprite container;

  @override
  void addedToStage() {
    stage!.color = kBgColor;
    container = GSprite();
    addChild(container);
    stars = List.generate(
      5,
      (index) {
        var star = Star();
        container.addChild(star);
        star.setPosition(index * (star.starSize + 5), 0);
        star.onMouseOver.add((_) {
          hoverStar(index);
        });
        star.onMouseClick.add((_) {
          selectStar(index);
        });
        return star;
      },
    );
    container.alignPivot();
    final bb = container.bounds!;
    container.graphics.beginFill(kColorTransparent).drawGRect(bb).endFill();
    container.onMouseOut.add((event) {
      if (container.hitTouch(GPoint(
        container.mouseX,
        container.mouseY,
      ))) return;
      for (var i = 0; i < stars.length; i++) {
        stars[i].hoverState(false);
      }
    });
    stage!.onResized.add(() {
      container.setPosition(sw / 2, sh / 2);
    });
  }

  void selectStar(int index) {
    for (var i = 0; i < stars.length; i++) {
      if (i <= index) {
        stars[i].selectState(true);
      } else {
        stars[i].selectState(false);
      }
    }
  }

  void hoverStar(int index) {
    for (var i = 0; i < stars.length; i++) {
      if (i <= index) {
        stars[i].hoverState(true);
      } else {
        stars[i].hoverState(false);
      }
    }
  }
}
