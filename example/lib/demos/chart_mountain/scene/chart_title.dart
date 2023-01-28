import 'package:graphx/graphx.dart';

import '../chart_data.dart';
import 'utils.dart';

class GraphTitle extends GSprite {
  final List<GraphModel>? data;

  GraphTitle({this.data});

  @override
  void addedToStage() {
    for (var i = 0; i < data!.length; ++i) {
      final vo = data![i];
      var item = GSprite();
      addChild(item);
      var quad = GShape();
      item.addChild(quad);
      quad.graphics.beginFill(vo.color!).drawRect(0, 0, 7, 7).endFill();
      quad.y = 3;
      var title = createLabel(vo.name);
      item.addChild(title);
      title.x = 10;
      item.y = i * 25.0;
    }
  }
}
