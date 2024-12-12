import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/enter_password_screen.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterPinCodeScreen extends ConsumerStatefulWidget {
  const EnterPinCodeScreen({
    super.key,
    required this.email,
    required this.type,
    required this.userName,
    required this.phoneNumber,
  });
  final String email;
  final String type;
  final String userName;
  final String phoneNumber;

  @override
  ConsumerState<EnterPinCodeScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<EnterPinCodeScreen> {
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
            'assets/images/bg_image_2.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///app icon
                      Image.asset(
                        'assets/images/phoosar_img.png',
                        height: 60,
                      ),
                      100.vGap,

                      ///Pin code text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
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
                            selectedFillColor: Colors.white,
                            inactiveColor: Colors.grey,
                            activeColor: Colors.transparent,
                            inactiveFillColor: Colors.white.withOpacity(0.2),
                            shape: PinCodeFieldShape.box,
                            borderWidth: 1,
                            inactiveBorderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.pinkAccent,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: _pinController,
                          onCompleted: (v) async {
                            _verifyOTP();
                          },
                        )),
                      ),

                      10.vGap,

                      ///resend otp text button
                      TextButton(
                        onPressed: () {
                          _requestOTP();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.kResendOTPLabel,
                          style: TextStyle(
                              fontSize: kTextRegular3x, color: Colors.white),
                        ),
                      ),

                      30.vGap,

                      ///ConfirmButton button
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: AppLocalizations.of(context)!.kConfirmLabel,
                          fontSize: 18,
                          onTap: () {
                            _verifyOTP();
                          },
                          bgColor: Colors.white,
                          buttonTextColor: Colors.black,
                        ),
                      ),

                      140.vGap,

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
                                    .kAlreadyHaveAccount),
                            TextSpan(
                              text: AppLocalizations.of(context)!.kSignInLabel,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.pinkAccent),
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
          ),
        ],
      ),
    );
  }

  Future<void> _requestOTP() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    await ref.read(repositoryProvider).sendOTP(
          jsonEncode({
            "type": widget.type,
            "value": widget.type == "email" ? widget.email : widget.phoneNumber,
            "user_name": widget.userName,
          }),
          context,
        );
  }

  Future<void> _verifyOTP() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final pin = _pinController.text;
    setState(() {
      isLoading = true;
    });
    var response = await ref.read(repositoryProvider).verifyOTP(
          jsonEncode({
            "type": widget.type,
            "value": widget.type == "email" ? widget.email : widget.phoneNumber,
            "user_name": widget.userName,
            "otp": pin,
          }),
          context,
        );
    _pinController.clear();
    if (response.statusCode.toString().startsWith("2")) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnterPasswordScreen(
            email: widget.email,
            type: widget.type,
            userName: widget.userName,
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
