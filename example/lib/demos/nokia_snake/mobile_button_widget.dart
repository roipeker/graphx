import 'package:flutter/material.dart';

class MobileControlButton extends StatelessWidget {
  const MobileControlButton({
    super.key,
    this.icon,
    this.onPressed,
  });
  final IconData? icon;
  final Function? onPressed;

  const MobileControlButton.left(this.onPressed, {super.key})
      : icon = Icons.keyboard_arrow_left_outlined;

  const MobileControlButton.right(this.onPressed, {super.key})
      : icon = Icons.keyboard_arrow_right_outlined;

  const MobileControlButton.up(this.onPressed, {super.key})
      : icon = Icons.keyboard_arrow_up_outlined;

  const MobileControlButton.down(this.onPressed, {super.key})
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
