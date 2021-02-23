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
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text('graphx color picker'),
                Spacer(),
                Column(
                  children: [
                    Text(
                      'based on SuperDeclarative! video.',
                      style: TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Center(child: PickerContainer()),
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.black87,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(width: 12),
                TextButton(
                  child: Text('graphx gist', style: TextStyle(fontSize: 12)),
                  onPressed: () => trace(
                      'https://gist.github.com/roipeker/6e7d5b30f6b022196bc98e2db14676a2'),
                ),
                VerticalDivider(),
                TextButton(
                  child:
                      Text('original workshop', style: TextStyle(fontSize: 12)),
                  onPressed: () =>
                      trace('https://www.youtube.com/watch?v=HURA4DKjA1c'),
                ),
              ],
            ),
          ),
        ));
  }
}
