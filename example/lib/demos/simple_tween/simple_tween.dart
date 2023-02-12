import '../../utils/utils.dart';
import 'simple_tween_scene.dart';
import 'tween_controller.dart';

class SimpleTweenMain extends StatefulWidget {
  const SimpleTweenMain({super.key});

  @override
  State<SimpleTweenMain> createState() => _SimpleTweenMainState();
}

class _SimpleTweenMainState extends State<SimpleTweenMain> {
  final controller = TweenSceneController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DemoSingleSceneWidget(
      root: SimpleTweenScene(controller),
      child: _TweenMenu(controller),
    );
  }
}

class _TweenMenu extends StatelessWidget {
  final TweenSceneController controller;

  const _TweenMenu(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: 300,
//      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _addButton(
            label: 'rotate',
            icon: Icons.rotate_left,
            onPressed: controller.onRotate.dispatch,
          ),
          _addButton(
            label: 'scale',
            icon: Icons.photo_size_select_small,
            onPressed: controller.onScale.dispatch,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _addButton(
                label: 'left',
                icon: Icons.chevron_left,
                onPressed: () => controller.onTranslate.dispatch(-1),
              ),
              _addButton(
                label: 'center',
                icon: Icons.filter_center_focus,
                onPressed: () => controller.onTranslate.dispatch(0),
              ),
              _addButton(
                label: 'right',
                icon: Icons.chevron_right,
                onPressed: () => controller.onTranslate.dispatch(1),
              ),
            ],
          ),
          _addButton(
            label: 'counter text',
            icon: Icons.plus_one,
            onPressed: controller.onAddCounter.dispatch,
          ),
        ],
      ),
    );
  }

  Widget _addButton(
      {required String label, IconData? icon, VoidCallback? onPressed}) {
    return TextButton(
      // color: Colors.red,
      onPressed: onPressed,
      // color: Colors.red,
      child: Row(
        children: [
          Icon(icon),
          Text(label),
        ],
      ),
    );
  }
}
