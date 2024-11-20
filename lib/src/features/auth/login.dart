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
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:phoosar/env/env.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/email_and_phone_number_view.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/models/facebook_user.dart';
import 'package:phoosar/src/data/response/authentication_response.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/forgot_password_screen.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
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
  //final TextEditingController phoneNumberController = TextEditingController();

  ///Email or Phone number
  String selectedText = "Phone";
  //var countryCode = "+959";
  String e164PhoneNo = "";
  PhoneNumber phone = PhoneNumber(isoCode: 'MM');
  TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;
  String? recentOnBoarding;
  bool haveNavigated = false;
  String? recentOnboardingStatus;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> saveSupabaseUserId(String userId) async {
    var response = await ref.read(repositoryProvider).saveSupabaseUserId(
      {
        "supabase_user_id": userId.toString(),
      },
      context,
    );
    if (response.statusCode.toString().startsWith("2")) {
      navigateToNextScreen();
    } else {
      // Handle error response
    }
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

                EmailAndPhoneNumberButtonView(
                  isSelected: selectedText == "Phone",
                  label: AppLocalizations.of(context)!.kPhoneNumberLabel,
                  onTapButton: () {
                  },
                ),

                // ///email and phone number view
                // EmailAndPhoneNumberView(
                //     selectedText: selectedText,
                //     onTapEmailOrPhoneNumber: (value) {
                //       setState(() {
                //         selectedText = value;
                //       });
                //     }),

                20.vGap,

                ///phone number sign in view
                Visibility(
                  // visible: selectedText == "Phone",
                  visible: true,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 0.5),
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
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          initialValue: phone,
                          hintText: '',
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),

                          //initialValue: number,
                          textFieldController: _phoneController,
                          formatInput: true,
                          keyboardType: TextInputType.number,
                          keyboardAction: TextInputAction.done,
                          // keyboardType: TextInputType.numberWithOptions(
                          //     signed: true, decimal: true),
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
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
                  // visible: selectedText == "Email",
                  visible: false,
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
                        builder: (context) => ForgotPasswordScreen(
                            type: selectedText.toLowerCase()),
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
                Visibility(
                  visible: false,
                  child: Row(
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
                          icon: Image.asset(
                            'assets/images/google.jpg',
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                          text: AppLocalizations.of(context)!.kSignInLabel),
                    ],
                  ),
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
            //"type": selectedText == "Email" ? "email" : "phone",
            "type": "phone",
            "value":
            e164PhoneNo,
            // "value":
            //     selectedText == "Email" ? emailController.text : e164PhoneNo,
            //: "${countryCode}${phoneNumberController.text}",
            "password": "${passwordController.text}",
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
      final profileRes = await ref
          .watch(repositoryProvider)
          .getProfile(jsonEncode({}), context);
      var data = SelfProfileResponse.fromJson(jsonDecode(profileRes.body));
      ref.read(selfProfileProvider.notifier).state = data;
      setState(() {
        recentOnboardingStatus = authResponse.recentOnBoarding ?? '';
      });

      //Supabase Login
      try {
        // await supabase.auth.signInWithPassword(
        //   email: selectedText == "Email"
        //       ? emailController.text.toString()
        //       : ('user' + e164PhoneNo + '@gmail.com'),
        //   password: passwordController.text,
        // );
        await supabase.auth.signInWithPassword(
          email: ('user' + e164PhoneNo + '@gmail.com'),
          password: passwordController.text,
        );
        navigateToNextScreen();
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
      setState(() {
        recentOnBoarding = authResponse.recentOnBoarding;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  navigateToNextScreen() {
    ref.invalidate(profilesProvider);
    ref.invalidate(profileProvider);
    ref.invalidate(roomsProvider);
    ref.invalidate(supabaseClientProvider);
    ref
        .watch(sharedPrefProvider)
        .setString(kRecentOnboardingKey, recentOnboardingStatus ?? '');
    if (recentOnboardingStatus == kProfileStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChooseGenderScreen()),
      );
    } else if (recentOnboardingStatus == kQuestionStatus) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false,
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
      log(result.toString());
      result.authentication.then((googleKey) {
        loginWithSocialToken(
            googleKey.accessToken!, "google", avator ?? "", name ?? "", email);
      }).catchError((err) {
        log(err.toString());
      });
    }).catchError((err) {
      log(err.toString());
    });
  }

  supabaseSocialRegister(String email, String name) async {
    // Supabase Register
    try {
      var authState = await supabase.auth.signUp(
        email: email,
        password: email,
        data: {
          'username': name,
          'device_token': 'device_token',
        },
        emailRedirectTo: 'io.supabase.chat://login',
      );
      saveSupabaseUserId(authState.session!.user.id.toString());
    } on AuthException catch (error) {
      debugPrint(error.toString());
      context.showErrorSnackBar(message: error.message);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      debugPrint(error.toString());
      context.showErrorSnackBar(message: unexpectedErrorMessage);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  facebookSignIn(BuildContext context) async {
    await FacebookAuth.instance.login(
      permissions: ['email'],
    ).then((result) {
      FacebookAuth.instance.getUserData().then((userData) async {
        // log("Facebook userData => $userData");

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

      if (authResponse.type == "old") {
        setState(() {
          recentOnboardingStatus = authResponse.recentOnBoarding ?? '';
        });

        supabaseSocialLogin(email);
      } else {
        setState(() {
          recentOnboardingStatus = kProfileStatus;
        });
        supabaseSocialRegister(email, sanitizedName);
      }
    }
  }

  supabaseSocialLogin(String email) async {
    try {
      var authState = await supabase.auth.signInWithPassword(
        email: email,
        password: email,
      );
      saveSupabaseUserId(authState.session!.user.id.toString());
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
