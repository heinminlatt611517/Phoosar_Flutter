import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/response/authentication_response.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../env/env.dart';
import '../../common/widgets/country_code_with_phone_number_widget.dart';
import '../../common/widgets/email_and_phone_number_view.dart';
import '../../data/models/facebook_user.dart';
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
  final phoneNumberController = TextEditingController();

  ///Email or Phone number
  String selectedText = kEmailLabel;

  Future<void> _requestOTP(String type) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final phoneNumber = phoneNumberController.text;
    final username = _usernameController.text;
    setState(() {
      _isLoading = true;
    });
    var response = await ref.read(repositoryProvider).sendOTP(
          jsonEncode({
            "type": type,
            "value": type == "email" ? email : phoneNumber,
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
            phoneNumber: phoneNumber,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
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
                  50.vGap,

                  ///email and phone number view
                  EmailAndPhoneNumberView(
                      selectedText: selectedText,
                      onTapEmailOrPhoneNumber: (value) {
                        setState(() {
                          selectedText = value;
                        });
                      }),

                  20.vGap,

                  ///phone number sign up view
                  Visibility(
                    visible: selectedText == kPhoneNumberLabel,
                    child: Column(
                      children: [
                        ///password input
                        InputView(
                            controller: _usernameController,
                            hintLabel: kUserNameLabel),

                        24.vGap,

                        CountryCodeWithPhoneNumberWidget(
                          textEditingController: phoneNumberController,
                          hintLabel: '',
                          onSelectCountryCode: (String value) {
                            log("SelectedCountryCode===========> $value");
                          },
                        ),
                      ],
                    ),
                  ),

                  ///user name , email , password view
                  Visibility(
                      visible: selectedText == kEmailLabel,
                      child: Column(
                        children: [
                          ///user name input
                          InputView(
                              controller: _usernameController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              hintLabel: kUserNameLabel),
                          24.vGap,

                          ///email input
                          InputView(
                              controller: _emailController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                              hintLabel: kEmailLabel),
                          24.vGap,
                        ],
                      )),

                  50.vGap,

                  ///Sign up button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: kSignUpLabel,
                      fontSize: 18,
                      onTap: () {
                        if (!_isLoading) {
                          _requestOTP(selectedText == kPhoneNumberLabel
                              ? "phone"
                              : "email");
                        }
                        // if (selectedText == kPhoneNumberLabel) {
                        //   Navigator.of(context).pushReplacement(
                        //     MaterialPageRoute(
                        //         builder: (context) => EnterPinCodeScreen()),
                        //   );
                        // } else {
                        //   if (!_isLoading) {
                        //     _signUp();
                        //   }
                        // }
                      },
                      bgColor: Colors.lightBlueAccent,
                    ),
                  ),

                  30.vGap,

                  ///forgot password
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      kForgotPasswordLabel,
                      style: TextStyle(
                          fontSize: kTextRegular3x, color: Colors.grey),
                    ),
                  ),

                  40.vGap,

                  ///already have account
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: kTextRegular2x,
                        color: Colors.grey,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: kAlreadyHaveAccount),
                        TextSpan(
                          text: kSignInLabel,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
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
    );
  }

  googleSignIn() async {
    GoogleSignIn googleSignIn = Platform.isAndroid
        ? GoogleSignIn(
            scopes: <String>[
              'email',
              'https://www.googleapis.com/auth/contacts.readonly',
            ],
          )
        : GoogleSignIn(
            clientId: Env.googleClientId,
            scopes: <String>[
              'email',
              'https://www.googleapis.com/auth/contacts.readonly',
            ],
          );

    googleSignIn.signIn().then((result) {
      var avator = result!.photoUrl;
      var name = result.displayName;
      var email = result.email;
      result.authentication.then((googleKey) {
        loginWithSocialToken(
            googleKey.accessToken!, "google", avator ?? "", name ?? "", email);
      }).catchError((err) {
        log("====================GoogleSignIn authentication====================");
        log(err.toString());
        log("===================================================================");
      });
    }).catchError((err) {
      log("====================GoogleSignIn====================");
      log(err.toString());
      log("====================================================");
    });
  }

  facebookSignIn(BuildContext context) async {
    log("Facebook Sign IN called");
    await FacebookAuth.instance.login(
      permissions: ['email'],
    ).then((result) {
      FacebookAuth.instance.getUserData().then((userData) async {
        log("Facebook userData => $userData");

        // or FacebookAuth.i.login()
        if (result.status == LoginStatus.success) {
          final userProfile = FacebookUser.fromJson(userData);
          var name = userProfile.name;
          var email = userProfile.email;
          var avator = userProfile.pictureUrl;
          // you are logged
          final AccessToken accessToken = result.accessToken!;
          loginWithSocialToken(accessToken.tokenString, "facebook", avator,
              name, email); // print(result.accessToken!.token
        } else if (result.status == LoginStatus.cancelled) {
        } else if (result.status == LoginStatus.failed) {}
      });
    }); // by default we request the email and the public profile
  }

  loginWithSocialToken(String socialToken, String type, String avator,
      String name, String email) async {
    var response = await ref.read(repositoryProvider).socialLogin(
          jsonEncode({
            {
              "provider": type,
              "provider_id": socialToken,
              "email": email,
              "name": name
            }
          }),
          context,
        );
    if (response.statusCode.toString().startsWith("2")) {
      AuthenticationResponse authResponse =
          AuthenticationResponse.fromJson(jsonDecode(response.body));
      ref
          .watch(sharedPrefProvider)
          .setString("token", authResponse.token ?? '');
      try {
        await supabase.auth.signInWithPassword(
          email: _emailController.text,
          password: socialToken,
        );
      } on AuthException catch (error) {
        context.showErrorSnackBar(message: error.message);
      } catch (_) {
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
