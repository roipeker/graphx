/// Ismail Alam Khan and roipeker, 2020.
///

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphx/graphx.dart';

import 'assets.dart';
import 'scene.dart';

class HeartReactionMain extends StatefulWidget {
  @override
  State<HeartReactionMain> createState() => _HeartReactionMainState();
}

class _HeartReactionMainState extends State<HeartReactionMain> {
  final GlobalKey _key = GlobalKey();
  final onLiked = ValueNotifier(false);

  Color get iconColor {
    return onLiked.value ? Theme.of(context).disabledColor : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedBuilder(
        animation: onLiked,
        builder: (_, __ ) => FloatingActionButton(
          key: _key,
          onPressed: () {
            onLiked.value = !onLiked.value;
            setState(() {});
          },
          backgroundColor: iconColor,
          disabledElevation: 0,
          elevation: 6,
          child: SvgPicture.string(
            SvgAssets.HEART,
            color: onLiked.value ? Colors.red : Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/heart_reaction/background_photo.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SceneBuilderWidget(
          builder: () => SceneController(
            back: HeartScene(
              key: _key,
              onLiked: onLiked,
            ),
          ),
          autoSize: true,
        ),
      ),
    );
  }
}
