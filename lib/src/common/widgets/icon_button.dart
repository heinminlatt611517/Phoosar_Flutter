import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:phoosar/src/utils/colors.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.backgroundColor = whiteColor,
    this.padding = 10,
  });
  final Function() onTap;
  final Widget icon;
  final Color? backgroundColor;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      scaleFactor: 0.5,
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(padding ?? 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: backgroundColor ?? whiteColor),
              color: backgroundColor),
          child: icon),
    );
  }
}
