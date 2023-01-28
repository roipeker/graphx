/// roipeker 2021
///
/// idea from: https://dribbble.com/shots/7116566-Sorting-Button
/// demo: https://graphx-dropdown-4.surge.sh/
///
import 'package:graphx/graphx.dart';

import '../../utils/utils.dart';
import 'scene/root_scene.dart';
import 'scene/sorting_button_scene.dart';

class SortingButtonMain extends StatelessWidget {
  const SortingButtonMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: RootWidget(
        child: SceneBuilderWidget(
          builder: () => SceneController(
            front: SortingButtonScene(),
            config: SceneConfig.interactive,
          ),
        ),
      ),
    );
  }
}
