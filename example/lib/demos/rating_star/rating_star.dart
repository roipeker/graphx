import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';
import 'scene/rating_scene.dart';

class RatingStarsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('rating stars')),
      body: SceneBuilderWidget(
        builder: () => SceneController(back: RatingStarsScene()),
        autoSize: true,
      ),
    );
  }
}
