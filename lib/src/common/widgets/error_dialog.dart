import 'package:flutter/material.dart';
import 'common_button.dart';
import 'common_dialog.dart';
import 'package:sized_context/sized_context.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  final String? title;
  final Function? onTap;
  const ErrorDialog(
      {super.key, required this.title, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonDialog(
      title: title.toString(),
      width: context.widthPx,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
            child: Text(
              message.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.8),
            ),
          ),
          SizedBox(
            height: 42,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  text: "Ok",
                  bgColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    if (onTap != null) onTap!();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
