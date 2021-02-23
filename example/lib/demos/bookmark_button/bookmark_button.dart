/// roipeker 2021
///
/// idea from: https://dribbble.com/shots/13890969-Bookmark-Button
/// demo: https://graphx-bookmark-btn.surge.sh
/// bookmark gif asset:
/// https://graphx-bookmark-btn.surge.sh/assets/assets/samples/bookmark.gif
///
import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene.dart';

class BookmarkButtonMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bookmark button')),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 80,
          child: SceneBuilderWidget(
            builder: () => SceneController(
              front: BookmarkButton(),
              config: SceneConfig.interactive,
            ),
          ),
        ),
      ),
    );
  }
}
