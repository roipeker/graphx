import 'package:flutter/material.dart';

class OrangeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity();
    matrix.translate(0.0, -10.0, 0.0);
    return Container(
      width: 32,
      height: 32,
      transform: matrix,
      decoration: BoxDecoration(
        color: Color(0xffFFA422),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Color(0xffFFA422).withOpacity(.4),
            offset: Offset(0, 3),
            blurRadius: 5,
            spreadRadius: -2,
          )
        ],
      ),
      child: Icon(
        Icons.show_chart_sharp,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
