import 'package:exampleGraphx/utils/utils.dart';
import 'package:graphx/graphx.dart';

import 'curved_graph_scene.dart';

class ChartBezierMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('curved chart'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 400,
                height: 300,
                child: SceneBuilderWidget(
                  builder: () => SceneController(
                    front: CurvedGraphScene(),
                  ),
                ),
              ),
            ),
          ),
          ExampleInfo(
            color: Colors.white,
            text: 'Click to generate random data points',
          )
        ],
      ),
    );
  }
}
