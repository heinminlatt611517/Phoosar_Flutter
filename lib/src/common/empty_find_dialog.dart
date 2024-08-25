import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyFindDialog extends StatelessWidget {
  final Function? onTap;
  const EmptyFindDialog({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: context.widthPx,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/images/ic_end.png',
              width: 120,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 60, right: 60, top: 24, bottom: 12),
              child: Text(
                AppLocalizations.of(context)!.kLastProfile,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: kTextRegular24, height: 1.8),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  containerHPadding: 40,
                  containerVPadding: 14,
                  text: AppLocalizations.of(context)!.kStartOver.toUpperCase(),
                  bgColor: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    if (onTap != null) onTap!();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
