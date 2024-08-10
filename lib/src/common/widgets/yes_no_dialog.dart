import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';

Future<bool?> showYesNoDialog({
  required BuildContext context,
  String? title,
  Widget? content,
  required VoidCallback onPress,
}) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      title: title != null ? Text(title) : null,
      content: content ?? const SizedBox(),
      actions: <Widget>[
        SizedBox(
          width: 90,
          child: ElevatedButton(
            onPressed: () {
              onPress();
            },
            child: const Text('Yes'),
          ),
        ),
        16.hGap,
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 90,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('NO'),
          ),
        ),
      ],
    ),
  );
}