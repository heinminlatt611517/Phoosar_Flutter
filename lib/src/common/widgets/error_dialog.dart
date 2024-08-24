import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'common_button.dart';
import 'common_dialog.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            height: 20,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
            child: Text(
              message.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1.8),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  containerHPadding: 40,
                  text: AppLocalizations.of(context)!.kOkLabel,
                  bgColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    if (onTap != null) onTap!();
                  },
                ),
              ),
              20.hGap
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
