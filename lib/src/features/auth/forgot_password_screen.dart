import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/request/forgot_password_otp_request.dart';
import 'package:phoosar/src/data/request/forgot_password_request.dart';
import 'package:phoosar/src/features/auth/enter_forgot_password_pin_code_screen.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
    required this.type,
  }) : super(key: key);
  final String? type;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ForgotPasswordScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  String e164PhoneNo = "";
  PhoneNumber phone = PhoneNumber(isoCode: 'MM');
  TextEditingController _phoneController = TextEditingController();

  String? recentOnboardingStatus;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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

                  40.vGap,

                  ///back icon
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/svgs/ic_back.svg',
                        width: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  40.vGap,

                  ///app icon
                  Image.asset(
                    'assets/images/phoosar_img.png',
                    height: 80,
                  ),
                  30.vGap,

                  Text(
                    AppLocalizations.of(context)!.kEnterYourPhoneNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: kTextRegular2x,fontWeight: FontWeight.normal),
                  ),
                  30.vGap,

                  Text(
                    AppLocalizations.of(context)!.kNoProblem.toUpperCase(),
                    style: TextStyle(color: Colors.black, fontSize: 22,fontFamily: kFontGibsonBold),
                  ),

                  40.vGap,


                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.white,
                                width: 1),
                            borderRadius: BorderRadius.circular(4.0)),
                        child: InternationalPhoneNumberInput(
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
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          initialValue: phone,
                          hintText: '',
                          textAlignVertical: TextAlignVertical.top,
                          cursorColor: Colors.black,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black),
                          textFieldController: _phoneController,
                          formatInput: true,
                          textStyle: TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          keyboardAction: TextInputAction.done,
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),

                      24.vGap,

                    ],
                  ),
                  60.vGap,

                  ///send button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: AppLocalizations.of(context)!.kSend.toUpperCase(),
                      buttonTextColor: Colors.white,
                      fontSize: 18,
                      isLoading: _isLoading,
                      onTap: () async {
                        if(e164PhoneNo != ''){
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });
                            var forgotPasswordOtpRequest = ForgotPasswordOtpRequest(phone: e164PhoneNo);
                            var response = await ref
                                .read(repositoryProvider)
                                .forgotPasswordOtpRequest(forgotPasswordOtpRequest, context);
                            if (response.statusCode.toString().startsWith('2')) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterForgotPasswordPinCodeScreen(phoneNumber: e164PhoneNo)),
                              );
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                            }
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
