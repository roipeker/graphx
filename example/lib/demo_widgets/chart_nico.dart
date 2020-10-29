import 'dart:math';
import 'package:flutter/material.dart';
import '../graphx/core/graphx.dart';

class ChartNico extends RootScene {
  final List<Venta> lista;

  ChartNico(this.lista);
  @override
  void init() {
    owner.core.config.useTicker = true;
  }

  @override
  void ready() {
    super.ready();
    owner.needsRepaint = true;
    stage.scene.core.resumeTicker();
    var obj = _Base(
      lista,
    );
    addChild(obj);
    obj.alignPivot(Alignment.bottomCenter);
    obj.x = obj.pivotX;
    obj.y = obj.pivotY;

    var pic = obj.createPicture();
    final shape1 = Shape();
    addChild(shape1);
    shape1.graphics.drawPicture(pic);
    // obj.createImage().then((value) {
    // });
    obj.visible = false;
    obj.removeFromParent(true);
    // double counterScale = 0;
    // stage.onEnterFrame.add(() {
    //   counterScale += .01;
    //   obj.rotation = sin(counterScale) * pi;
    // });
  }
}

class _Base extends Sprite {
  final List<Venta> lista;

  double h;
  double w;
  _Base(this.lista) {
    onAddedToStage.addOnce(init);
  }

  void init() {
    final maxTotal = lista.fold<double>(
      0.0,
      (v, element) {
        if (v < element.total) v = element.total;
        return v;
      },
    );
    print(maxTotal);

    final padding = 40.0;
    w = stage.stageWidth - (padding * 2);
    h = stage.stageHeight - (padding * 2);
    final lines = Shape();
    final container = Sprite();
    container.addChild(lines);

    container.x = 40;
    container.y = 40;

    lines.graphics.lineStyle(
      5.0,
      Colors.blueGrey.value,
    );

    final separatorX = w / lista.length;
    lines.graphics.moveTo(0.0, 0.0);
    lines.graphics.lineTo(0.0, h);

    lines.graphics.lineTo(w, h);
    lines.graphics.lineStyle(
      1,
      Colors.blueGrey.value,
      .5,
    );
    for (int i = 0; i < lista.length; i++) {
      final tX = (i + 1) * separatorX;
      lines.graphics.moveTo(tX, 0);
      lines.graphics.lineTo(tX, h);
    }
    container.graphics.lineStyle(2, Colors.black.value, .9);

    for (int i = 0; i < lista.length; i++) {
      final dot = Shape();
      dot.graphics.beginFill(Colors.red.value, .7);
      dot.graphics
          .drawCircle(
            0.0,
            0.0,
            5.0,
          )
          .endFill();
      final tX = (i + 1) * separatorX;
      container.addChild(dot);
      final percent = 1 - (lista[i].total / maxTotal);
      dot.y = percent * h;
      dot.x = tX;
      if (i == 0) {
        container.graphics.moveTo(dot.x, dot.y);
      } else {
        container.graphics.lineTo(dot.x, dot.y);
      }
    }

    addChild(container);
  }
}

class Venta {
  final DateTime date;
  final double total;
  final double iva;
  final String cliente;

  Venta({
    this.date,
    this.total,
    this.iva,
    this.cliente,
  });
  static List<Venta> generate() {
    final lista = <Venta>[];
    final rng = Random();
    for (int i = 1; i <= 20; i++) {
      lista.add(
        Venta(
          cliente: 'cliente-$i',
          total: rng.nextInt(100).toDouble(),
          iva: rng.nextInt(100).toDouble(),
          date: DateTime.now().subtract(
            Duration(days: 30 * i),
          ),
        ),
      );
    }
    lista.sort((v1, v2) => v1.date.millisecondsSinceEpoch);
    lista.forEach((element) => element.date.toIso8601String());
    return lista;
  }
}
