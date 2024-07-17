import 'package:flutter/material.dart';

Future<void> pageNavigator(
  BuildContext context,
  Widget page, {
  Function? callback,
  bool removeBackStacks = false,
  bool pushAndReplace = false,
  bool noAnimation = false,
}) async {
  if (removeBackStacks) {
    if (noAnimation) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => page,
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
  if (pushAndReplace) {
    if (noAnimation) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => page,
        ),
      );
    }
  } else if (!removeBackStacks && !pushAndReplace) {
    if (noAnimation) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, _, __) => page,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => page,
        ),
      );
    }
  }

  callback?.call();
}
