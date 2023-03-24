/// roipeker 2020
///
/// GraphX code picker sample, inspired by SuperDeclarative video:
/// https://www.youtube.com/watch?v=HURA4DKjA1c
///
/// web demo:
/// https://roi-graphx-color-picker.surge.sh
///
/// GraphX package: https://pub.dev/packages/graphx
///
/// NOTE: No code cleanup, nor refactoring was made.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'picker_container.dart';

class ColorPickerMain extends StatelessWidget {
  const ColorPickerMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          // appBar: AppBar(
          //   title: Row(
          //     children: [
          //       const Text('graphx color picker'),
          //       const Spacer(),
          //       Column(
          //         children: const [
          //           Text(
          //             'based on SuperDeclarative! video.',
          //             style: TextStyle(fontSize: 10, color: Colors.white54),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          body: const Center(child: PickerContainer()),
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.black87,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const SizedBox(width: 12),
                TextButton(
                  child:
                      const Text('graphx gist', style: TextStyle(fontSize: 12)),
                  onPressed: () => trace(
                      'https://gist.github.com/roipeker/6e7d5b30f6b022196bc98e2db14676a2'),
                ),
                const VerticalDivider(),
                TextButton(
                  child: const Text('original workshop',
                      style: TextStyle(fontSize: 12)),
                  onPressed: () =>
                      trace('https://www.youtube.com/watch?v=HURA4DKjA1c'),
                ),
              ],
            ),
          ),
        ));
  }
}
