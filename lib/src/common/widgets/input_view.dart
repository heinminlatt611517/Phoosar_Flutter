import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/dimens.dart';

class InputView extends StatelessWidget {
  final TextEditingController controller;
  final String hintLabel;
  final String? Function(String?)? validator;

  const InputView(
      {super.key,
      required this.controller,
      required this.hintLabel,
      this.validator});

  @override
  Widget build(BuildContext context) {
    ///text form field
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white.withOpacity(0.2),
        border: Border.all(
            color: Colors.white,
            width: 1),),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintLabel,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.white,
            )),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
