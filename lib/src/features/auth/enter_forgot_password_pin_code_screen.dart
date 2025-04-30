import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/auth/update_password_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/request/forgot_password_otp_request.dart';

class EnterForgotPasswordPinCodeScreen extends ConsumerStatefulWidget {
  const EnterForgotPasswordPinCodeScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  ConsumerState<EnterForgotPasswordPinCodeScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends ConsumerState<EnterForgotPasswordPinCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  final TextEditingController _pinController = TextEditingController();

  ///Email or Phone number
  String selectedText = "Email";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    super.dispose();

    errorController?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/sign_up_bg.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    80.vGap,

                    ///app icon
                    Image.asset(
                      'assets/images/phoosar_img.png',
                      height: 80,
                    ),

                    40.vGap,

                    Text(
                      AppLocalizations.of(context)!.kCheckYourMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: kTextRegular2x,
                          fontWeight: FontWeight.normal),
                    ),
                    40.vGap,
                    Text(
                      AppLocalizations.of(context)!
                          .kYourCodeIsComing
                          .toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: kFontGibsonBold),
                    ),

                    20.vGap,

                    ///Pin code text field
                    Center(
                        child: PinCodeTextField(
                      backgroundColor: Colors.transparent,
                      keyboardType: TextInputType.number,
                      autoDisposeControllers: true,
                      cursorColor: Colors.blue,
                      appContext: context,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        selectedFillColor: Colors.black,
                        inactiveColor: Colors.black,
                        activeColor: Colors.transparent,
                        inactiveFillColor: Colors.black,
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1,
                        inactiveBorderWidth: 1,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: primaryColor,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: _pinController,
                      onCompleted: (v) async {
                        // _verifyOTP();
                      },
                    )),

                    ///resend otp text button
                    TextButton(
                      onPressed: () {
                        _requestOTP();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.kResendOTPLabel,
                        style: TextStyle(
                            fontSize: kTextRegular2x, color: Colors.black),
                      ),
                    ),

                    30.vGap,

                    ///ConfirmButton button
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CommonButton(
                          containerVPadding: 10,
                          text: AppLocalizations.of(context)!
                              .kConfirmLabel
                              .toUpperCase(),
                          fontSize: 18,
                          onTap: () {
                            if(_pinController.text.isNotEmpty){
                              _verifyOTP();
                            }
                          },
                          bgColor: Colors.green,
                          buttonTextColor: Colors.white,
                          isLoading: isLoading),
                    ),

                    60.vGap,

                    ///already have account
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: kTextRegular2x,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .kAlreadyHaveAccount,
                              style: TextStyle(
                                  fontFamily: kFontArticulatCFNormal)),
                          TextSpan(
                            text: AppLocalizations.of(context)!.kSignInLabel,
                            style: new TextStyle(
                                fontFamily: kFontArticulatCFNormal,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///request otp
  Future<void> _requestOTP() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    var forgotPasswordOtpRequest =
        ForgotPasswordOtpRequest(phone: widget.phoneNumber);
    await ref
        .read(repositoryProvider)
        .forgotPasswordOtpRequest(forgotPasswordOtpRequest, context);
  }

  ///verify otp
  Future<void> _verifyOTP() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final pin = _pinController.text;
    setState(() {
      isLoading = true;
    });
    var response = await ref.read(repositoryProvider).forgotPasswordVerifyOTP(
          jsonEncode({
            "phone": widget.phoneNumber,
            "otp": pin,
          }),
          context,
        );
    _pinController.clear();
    if (response.statusCode.toString().startsWith("2")) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UpdatePasswordScreen(
            phoneNumber: widget.phoneNumber,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
