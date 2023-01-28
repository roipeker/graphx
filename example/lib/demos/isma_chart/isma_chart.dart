/// Ismail Alam Khan and roipeker, 2020.
///
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'data.dart';
import 'scene/chart_scene.dart';
import 'widgets/orange_box.dart';

class IsmaChartMain extends StatelessWidget {
  const IsmaChartMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 430,
          height: 260,
          child: Card(
            child: Column(
              children: [
                Row(
                  children: const [
                    SizedBox(width: 7),
                    OrangeBox(),
                    SizedBox(width: 7),
                    Text(
                      'Case fatality rate(%) of reported cases by month',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.2,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: SceneBuilderWidget(
                            builder: () => SceneController(back: ChartScene()),
                          ),
                        ),
                        MPSBuilder<DotDataModel>(
                          builder: (ctx, data, _) {
                            final model = data.data;
                            if (model == null) return Container();
                            final point = model.coordinate;
                            return Positioned(
                              left: point.x,
                              top: point.y,
                              child: Tooltip(
                                height: 20,
                                padding: const EdgeInsets.all(2),
                                showDuration: const Duration(seconds: 2),
                                message: model.year,
                                child: const Text("."),
                              ),
                            );
                          },
                          topics: const ['chartHover'],
                          mps: mps,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Divider(
                        height: 0,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CFR%',
                            style: TextStyle(
                                fontSize: 8, color: Color(0xffA29999)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
