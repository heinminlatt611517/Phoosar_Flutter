import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/widgets/email_and_phone_number_view.dart';
import 'enter_pin_code_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({
    super.key,
  });

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  String e164PhoneNo = "";
  PhoneNumber phone = PhoneNumber(isoCode: 'MM');
  TextEditingController _phoneController = TextEditingController();

  ///Email or Phone number
  String selectedText = "Phone";
  var countryCode = "";

  Future<void> _requestOTP(String type) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final username = _usernameController.text;
    setState(() {
      _isLoading = true;
    });
    var response = await ref.read(repositoryProvider).sendOTP(
          jsonEncode({
            "type": type,
            "value": type == "email" ? email : e164PhoneNo,
            "user_name": username,
          }),
          context,
        );

    if (response.statusCode.toString().startsWith("2")) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnterPinCodeScreen(
            email: email,
            type: type,
            userName: username,
            phoneNumber: e164PhoneNo,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      countryCode = "+95";
    });
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
                      60.vGap,

                      Text(
                        "Can we get your number,par?",
                        style: TextStyle(color: Colors.black, fontSize: kTextRegular2x,fontWeight: FontWeight.bold),
                      ),
                      10.vGap,
                      Text(
                        "We only use phone numbers to\nmake sure everyone on",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: kTextRegular,fontWeight: FontWeight.normal),
                      ),

                      30.vGap,

                      ///phone number sign up view
                      Visibility(
                        visible: selectedText == "Phone",
                        child: Column(
                          children: [
                            ///password input
                            InputView(
                                controller: _usernameController,
                                hintLabel: AppLocalizations.of(context)!
                                    .kUserNameLabel),

                            24.vGap,

                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: InternationalPhoneNumberInput(
                                //countries: ['MM'],
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  setState(() {
                                    e164PhoneNo = number.phoneNumber.toString();
                                  });
                                },
                                onInputValidated: (bool value) {
                                  print(value);
                                },
                                selectorConfig: SelectorConfig(
                                  leadingPadding: 12,
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                initialValue: phone,
                                hintText: '',
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),

                                textFieldController: _phoneController,
                                formatInput: true,
                                keyboardType: TextInputType.number,
                                keyboardAction: TextInputAction.done,
                                textStyle: TextStyle(color: Colors.white),
                                inputBorder: InputBorder.none,
                                onSaved: (PhoneNumber number) {
                                  print('On Saved: $number');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      50.vGap,

                      ///Sign up button
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: AppLocalizations.of(context)!.kSignUpLabel,
                          fontSize: 18,
                          isLoading: _isLoading,
                          onTap: () {
                            if (!_isLoading) {
                              _requestOTP(
                                  selectedText == "Phone" ? "phone" : "email");
                            }
                          },
                          buttonTextColor: Colors.white,
                          bgColor: Colors.cyan,
                        ),
                      ),

                      30.vGap,

                      ///forgot password
                      Visibility(
                        visible: false,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            AppLocalizations.of(context)!.kForgotPasswordLabel,
                            style: TextStyle(
                                fontSize: kTextRegular3x, color: Colors.black),
                          ),
                        ),
                      ),

                      40.vGap,

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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent),
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
}
