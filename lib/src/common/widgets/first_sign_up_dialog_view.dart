import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import '../../utils/dimens.dart';
import 'common_button.dart';

class FirstSignUpDialogView extends ConsumerStatefulWidget {
  const FirstSignUpDialogView({super.key});

  @override
  ConsumerState<FirstSignUpDialogView> createState() => _FirstSignUpDialogViewState();
}

class _FirstSignUpDialogViewState extends ConsumerState<FirstSignUpDialogView> {

  bool isPopUpLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(50),
      surfaceTintColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(kMarginMedium2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kMarginMedium2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.gaining.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 28,
                  height: 0.9,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                fontFamily: kFontArticulatCFBold,),
            ),
            const SizedBox(height: 12),
            IntrinsicWidth(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: blackColor, width: 2.8)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/update_coin.png',
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                    4.hGap,
                    Text(
                      '1,000',
                      style: TextStyle(
                          fontFamily: kFontArticulatCFMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.forFirstSignUp,
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1,
                color: Colors.black,
                fontFamily: kFontArticulatCFBold,
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                containerVPadding: 10,
                fontSize: mediumFontSize,
                bgColor: primaryColor,
                isLoading: isPopUpLoading,
                text: "CONTINUE",
                onTap: () async{
                  setState(() {
                    isPopUpLoading = true;
                  });
                  var response = await ref
                      .read(repositoryProvider)
                      .updatePopupData(context);
                  if (response.statusCode
                      .toString()
                      .startsWith('2')) {
                    Navigator.pop(context);
                    setState(() {
                      isPopUpLoading = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
