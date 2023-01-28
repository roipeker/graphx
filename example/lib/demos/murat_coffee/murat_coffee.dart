import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'scene.dart';

class MuratCoffeeMain extends StatelessWidget {
  const MuratCoffeeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: const Text(
      //     'playful coffee',
      //     style: TextStyle(
      //       color: Colors.black45,
      //       fontSize: 16,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
      body: Center(child: SampleItem()),
    );
  }
}

class SampleItem extends StatelessWidget {
  const SampleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.13),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SceneBuilderWidget(
        builder: () => SceneController(
          front: CoffeeItemScene(),
          config: SceneConfig.autoRender,
        ),
        // child: Text("Hola"),
      ),
    );
  }
}
