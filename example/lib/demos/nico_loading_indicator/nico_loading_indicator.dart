/// made by Nico Lopez (unacorbatanegra), 2020
/// source code:
/// https://github.com/unacorbatanegra/custom_progress_indicator
///
import 'package:flutter/material.dart';

import 'scene.dart';

class NicoLoadingIndicatorMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nico Progress Indicator'),
      ),
      body: Center(
        child: CustomLoadingIndicator(),
      ),
    );
  }
}
