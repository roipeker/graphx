import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MobileControlButton extends StatelessWidget {
  const MobileControlButton({
    Key? key,
    this.icon,
    this.onPressed,
  }) : super(key: key);
  final IconData? icon;
  final Function? onPressed;

  MobileControlButton.left(this.onPressed)
      : icon = Icons.keyboard_arrow_left_outlined;

  MobileControlButton.right(this.onPressed)
      : icon = Icons.keyboard_arrow_right_outlined;

  MobileControlButton.up(this.onPressed)
      : icon = Icons.keyboard_arrow_up_outlined;

  MobileControlButton.down(this.onPressed)
      : icon = Icons.keyboard_arrow_down_outlined;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed as void Function()?,
        child: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(.4),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
