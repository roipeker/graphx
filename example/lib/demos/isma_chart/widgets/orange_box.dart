import 'package:flutter/material.dart';

class OrangeBox extends StatelessWidget {
  const OrangeBox({super.key});

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity();
    matrix.translate(0.0, -10.0);
    return Container(
      width: 32,
      height: 32,
      transform: matrix,
      decoration: BoxDecoration(
        color: const Color(0xffFFA422),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xffFFA422).withOpacity(.4),
            offset: const Offset(0, 3),
            blurRadius: 5,
            spreadRadius: -2,
          )
        ],
      ),
      child: const Icon(
        Icons.show_chart_sharp,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
