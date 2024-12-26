import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/request/forgot_password_request.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
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
            'assets/images/bg_image_3.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  100.vGap,

                  ///app icon
                  Image.asset(
                    'assets/images/white_logo.png',
                    height: 60,
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  ),

                  Text(
                      AppLocalizations.of(context)!.kNoProblem,
                    style: TextStyle(color: Colors.white, fontSize: kTextRegular2x,fontWeight: FontWeight.bold),
                  ),
                  10.vGap,
                  Text(
                    AppLocalizations.of(context)!.kEnterYourPhoneNumber,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: kTextRegular,fontWeight: FontWeight.w500),
                  ),

                  40.vGap,

                  // ///email input
                  // InputView(
                  //     controller: emailController,
                  //     hintLabel: widget.type == 'Email'.toLowerCase()
                  //         ? AppLocalizations.of(context)!.kEmailLabel
                  //         : AppLocalizations.of(context)!.kPhoneNumberLabel),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
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
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white),
                          textFieldController: _phoneController,
                          formatInput: true,
                          textStyle: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          keyboardAction: TextInputAction.done,
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),

                      24.vGap,

                      ///password input
                      // InputView(
                      //     controller: passwordController,
                      //     hintLabel:
                      //     AppLocalizations.of(context)!.kPasswordLabel),
                    ],
                  ),
                  60.vGap,

                  ///send button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: AppLocalizations.of(context)!.kSend,
                      buttonTextColor: Colors.black,
                      fontSize: 18,
                      isLoading: _isLoading,
                      onTap: () async {
                        if (!_isLoading) {
                          setState(() {
                            _isLoading = true;
                          });
                          var request = ForgotPasswordRequest(
                              value: _phoneController.text, type: widget.type);
                          var response = await ref
                              .read(repositoryProvider)
                              .forgotPassword(request, context);
                          if (response.statusCode.toString().startsWith('2')) {
                            final Map<String, dynamic> data =
                                json.decode(response.body);
                            context.showSnackBar(
                                message: data['message'],
                                backgroundColor: primaryColor);
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
                      bgColor: Colors.white,
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
