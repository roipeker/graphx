import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class GraphicsClipperDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphX Graphics Clipper'),
      ),

      /// takes the entire body area.
      body: Center(
          child: ClipPath(
        clipper: MyCurvyPath(),
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.blue],
            ),
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            itemBuilder: (ctx, idx) {
              return Text(
                'graphics clipper demo',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      )),
    );
  }
}

/// Clipper sample.
class MyCurvyPath extends GraphicsClipper {
  @override
  void draw(Graphics g, Size size) {
    final curveSize = 60.0;
    final targetW = size.width;
    final targetH = size.height;
    g
        .moveTo(0, curveSize)
        .curveTo(0, 0, curveSize, 0)
        .lineTo(targetW - curveSize, 0)
        .curveTo(targetW, 0, targetW, -curveSize)
        .lineTo(targetW, targetH)
        .lineTo(0, targetH)
        .closePath();

    /// make holes in the shape.
    g.beginHole();
    g.drawRoundRect(30, 30, 80, 20, 8).drawCircle(80, 80, 20);

    // we can append other Graphics, and apply some Matrix transform.
    final matrix = GMatrix()..rotate(deg2rad(45));
    final g2 = Graphics().beginFill(Colors.black).drawRoundRectComplex(
          0,
          0,
          50,
          10,
          8,
        );
    g.drawPath(g2.getPaths(), 100, 100, matrix);

    g.endHole(true);

    /// fill the inner circle from the hole.
    g.drawCircle(80, 80, 12);

    /// we can transform x, y, scaleX, scaleY, rotation, skewX, skewY, etc for
    /// the entire drawing...
    y = curveSize;
  }
}
