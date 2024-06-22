import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/dimens.dart';

class InputView extends StatelessWidget {
  final TextEditingController passwordController;
  final String hintLabel;

  const InputView(
      {super.key, required this.passwordController, required this.hintLabel});

  @override
  Widget build(BuildContext context) {
    ///text form field
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: const Color.fromRGBO(0, 0, 0, 0),
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5)),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintLabel,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.grey,
            )),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
