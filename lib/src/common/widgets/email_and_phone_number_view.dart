import 'package:flutter/material.dart';

import '../../utils/dimens.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///email and phone number view
class EmailAndPhoneNumberView extends StatelessWidget {
  final String selectedText;
  final Function(String) onTapEmailOrPhoneNumber;

  const EmailAndPhoneNumberView(
      {super.key,
      required this.selectedText,
      required this.onTapEmailOrPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: kMarginLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kMargin5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ///email
          EmailAndPhoneNumberButtonView(
            isSelected: selectedText == "Email",
            label: AppLocalizations.of(context)!.kEmailLabel,
            onTapButton: () {
              onTapEmailOrPhoneNumber("Email");
            },
          ),

          ///Phone number
          EmailAndPhoneNumberButtonView(
            isSelected: selectedText == "Phone",
            label: AppLocalizations.of(context)!.kPhoneNumberLabel,
            onTapButton: () {
              onTapEmailOrPhoneNumber("Phone");
            },
          )
        ],
      ),
    );
  }
}

///Email and Phone Number button view
class EmailAndPhoneNumberButtonView extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function onTapButton;

  const EmailAndPhoneNumberButtonView(
      {super.key,
      required this.isSelected,
      required this.label,
      required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton();
      },
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: kTextRegular2x,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.cyan : Colors.grey),
            ),
            Container(
              color: isSelected ? Colors.cyan : Colors.transparent,
              height: 3,
            )
          ],
        ),
      ),
    );
  }
}
