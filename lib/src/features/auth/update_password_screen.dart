import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../common/widgets/input_view.dart';
import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';
import 'login.dart';

class UpdatePasswordScreen extends ConsumerStatefulWidget {
  const UpdatePasswordScreen({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<UpdatePasswordScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String e164PhoneNo = "";
  bool isShowNewPassword = true;
  bool isShowConfirmPassword = true;
  String? recentOnboardingStatus;

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onTapToggleObscuredNewPassword() {
    setState(() {
      isShowNewPassword = !isShowNewPassword;
    });
  }

  void onTapToggleObscuredConfirmPassword() {
    setState(() {
      isShowConfirmPassword = !isShowConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/forgot_password_bg.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  80.vGap,

                  ///app icon
                  Image.asset(
                    'assets/images/phoosar_img.png',
                    height: 80,
                  ),
                  30.vGap,

                  Text(
                    AppLocalizations.of(context)!.kEnter8Characters,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: kTextRegular2x,
                        fontWeight: FontWeight.normal),
                  ),
                  30.vGap,

                  Text(
                    AppLocalizations.of(context)!
                        .kMakeItMemorable
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: kFontGibsonBold),
                  ),

                  40.vGap,

                  Column(
                    children: [
                      ///new password input
                      InputView(
                          bgColor: Colors.white,
                          cursorColor: Colors.black,
                          controller: newPasswordController,
                          hintTextColor: Colors.black,
                          isSecure: isShowNewPassword,
                          isPasswordView: true,
                          toggleObscured: onTapToggleObscuredNewPassword,
                          toggleObscuredColor: Colors.black,
                          hintLabel:
                              AppLocalizations.of(context)!.enterNewPassword),

                      24.vGap,

                      ///confirm password input
                      InputView(
                          bgColor: Colors.white,
                          cursorColor: Colors.black,
                          controller: confirmPasswordController,
                          hintTextColor: Colors.black,
                          isSecure: isShowConfirmPassword,
                          isPasswordView: true,
                          toggleObscured: onTapToggleObscuredConfirmPassword,
                          toggleObscuredColor: Colors.black,
                          hintLabel:
                              AppLocalizations.of(context)!.confirmPassword),
                    ],
                  ),
                  60.vGap,

                  ///send button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: AppLocalizations.of(context)!.update.toUpperCase(),
                      buttonTextColor: Colors.white,
                      fontSize: 18,
                      isLoading: _isLoading,
                      onTap: () async {
                        if (!_isLoading) {
                          if (newPasswordController.text.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "New Password must be at least 8 characters long.")),
                            );
                            return;
                          }

                          if (confirmPasswordController.text.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Confirm Password must be at least 8 characters long.")),
                            );
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });
                          var response =
                              await ref.read(repositoryProvider).resetPassword(
                                  jsonEncode({
                                    "phone": widget.phoneNumber,
                                    "password": newPasswordController.text,
                                    "password_confirmation":
                                        confirmPasswordController.text
                                  }),
                                  context);
                          if (response.statusCode.toString().startsWith('2')) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      bgColor: Colors.green,
                    ),
                  ),

                  30.vGap,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
