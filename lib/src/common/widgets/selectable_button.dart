import 'package:flutter/material.dart';

import '../../utils/dimens.dart';

class SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(String) onTapButton;
  const SelectableButton(
      {super.key,
      required this.label,
      required this.isSelected,
      required this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapButton(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kMarginMedium2),
        decoration: BoxDecoration(
            color:
                isSelected ? Colors.pinkAccent : Colors.grey.withOpacity(0.4),
            borderRadius: BorderRadius.circular(kMarginMedium)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
