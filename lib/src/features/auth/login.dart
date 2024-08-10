import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phoosar/env/env.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/country_code_with_phone_number_widget.dart';
import 'package:phoosar/src/common/widgets/email_and_phone_number_view.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/models/facebook_user.dart';
import 'package:phoosar/src/data/response/authentication_response.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/forgot_password_screen.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  ///Email or Phone number
  String selectedText = "Email";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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

                ///phone number sign in view
                Visibility(
                  visible: selectedText == "Phone",
                  child: Column(
                    children: [
                      CountryCodeWithPhoneNumberWidget(
                        textEditingController: phoneNumberController,
                        hintLabel: '',
                        onSelectCountryCode: (String value) {
                          log("SelectedCountryCode===========> $value");
                        },
                      ),
                      24.vGap,

                      ///password input
                      InputView(
                          controller: passwordController,
                          hintLabel:
                              AppLocalizations.of(context)!.kPasswordLabel),
                    ],
                  ),
                ),

                ///email sing in view
                Visibility(
                  visible: selectedText == "Email",
                  child: Column(
                    children: [
                      ///email input
                      InputView(
                          controller: emailController,
                          hintLabel: AppLocalizations.of(context)!.kEmailLabel),
                      24.vGap,

                      ///password input
                      InputView(
                          controller: passwordController,
                          hintLabel:
                              AppLocalizations.of(context)!.kPasswordLabel),
                    ],
                  ),
                ),

                50.vGap,

                ///Sign in button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: AppLocalizations.of(context)!.kSignInLabel,
                    fontSize: 18,
                    isLoading: _isLoading,
                    onTap: () {
                      if (!_isLoading) {
                        _signIn();
                      }
                    },
                    bgColor: Colors.pinkAccent,
                  ),
                ),

                30.vGap,

                ///forgot password
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.kForgotPasswordLabel,
                    style:
                        TextStyle(fontSize: kTextRegular3x, color: Colors.grey),
                  ),
                ),

                30.vGap,

                ///facebook and google sign in view
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///facebook signIn button
                    HorizontalTextIconButton(
                        onTap: () {
                          facebookSignIn(context);
                        },
                        icon: Icon(
                          Icons.facebook,
                          color: Colors.blue,
                        ),
                        text: AppLocalizations.of(context)!.kSignInLabel),

                    20.hGap,

                    ///google signIn button
                    HorizontalTextIconButton(
                        onTap: () {
                          googleSignIn();
                        },
                        icon: Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                        text: AppLocalizations.of(context)!.kSignInLabel),
                  ],
                ),

                40.vGap,

                ///dont have account
                RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      fontSize: kTextRegular2x,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: AppLocalizations.of(context)!.kDontHaveAccount),
                      TextSpan(
                        text: AppLocalizations.of(context)!.kSignUpLabel,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
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
    );
  }

  Future<void> _signIn() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "login",
      parameters: {
        "email": emailController.text,
        "password": passwordController.text,
      },
    );
    setState(() {
      _isLoading = true;
    });
    var response = await ref.read(repositoryProvider).login(
          jsonEncode({
            "type": selectedText == "Email" ? "email" : "phone",
            "value": selectedText == "Email"
                ? emailController.text
                : phoneNumberController.text,
            "password": passwordController.text,
          }),
          context,
        );
    if (response.statusCode.toString().startsWith("2")) {
      AuthenticationResponse authResponse =
          AuthenticationResponse.fromJson(jsonDecode(response.body));
      ref
          .watch(sharedPrefProvider)
          .setString(kTokenKey, authResponse.token ?? '');
      ref
          .watch(sharedPrefProvider)
          .setString(kRecentOnboardingKey, authResponse.recentOnBoarding ?? '');
      navigateToNextScreen(authResponse.recentOnBoarding ?? '');
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  navigateToNextScreen(String recentOnboardingStatus) {
    ref.invalidate(profilesProvider);
    ref.invalidate(profileProvider);
    ref.invalidate(roomsProvider);
    ref.invalidate(supabaseClientProvider);
    if (recentOnboardingStatus == kProfileStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChooseGenderScreen()),
      );
    }
    if (recentOnboardingStatus == kQuestionStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
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
    // Sanitize the username
    String sanitizedName =
        name.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_').toLowerCase();
    if (sanitizedName.length > 30) {
      sanitizedName = sanitizedName.substring(0, 30);
    }

    var response = await ref.read(repositoryProvider).socialLogin(
          jsonEncode({
            "provider": type,
            "provider_id": socialToken,
            "email": email,
            "name": sanitizedName
          }),
          context,
        );
    if (response.statusCode.toString().startsWith("2")) {
      AuthenticationResponse authResponse =
          AuthenticationResponse.fromJson(jsonDecode(response.body));
      ref
          .watch(sharedPrefProvider)
          .setString(kTokenKey, authResponse.token ?? '');
      navigateToNextScreen(authResponse.recentOnBoarding ?? '');
    }
  }

  supabaseLogin() async {
    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on AuthException catch (error) {
      setState(() {
        _isLoading = false;
      });
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
