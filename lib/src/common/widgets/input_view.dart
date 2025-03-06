import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';

class InputView extends StatelessWidget {
  final TextEditingController controller;
  final String hintLabel;
  final Color? cursorColor;
  final Color? bgColor;
  final Color? hintTextColor;
  final bool? isPasswordView;
  final String? Function(String?)? validator;
  final Function()? toggleObscured;
  final bool isSecure;
  final Color? toggleObscuredColor;

  const InputView({
    super.key,
    required this.controller,
    required this.hintLabel,
    this.validator,
    this.cursorColor,
    this.bgColor,
    this.hintTextColor,
    this.isPasswordView = false,
    this.isSecure = false,
    this.toggleObscured,
    this.toggleObscuredColor
  });

  @override
  Widget build(BuildContext context) {
    ///text form field
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: bgColor ?? Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        textAlignVertical:isPasswordView == true ? TextAlignVertical.center : null,
        cursorColor: cursorColor ?? primaryColor,
        obscureText: isSecure,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: isPasswordView == true
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: GestureDetector(
                      onTap: toggleObscured,
                      child: Icon(
                        isSecure
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                        color: toggleObscuredColor,
                      ),
                    ),
                  )
                : null,
            hintText: hintLabel,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: hintTextColor ?? Colors.white,
            )),
        style: TextStyle(color: hintTextColor ?? Colors.white),
      ),
    );
  }
}
