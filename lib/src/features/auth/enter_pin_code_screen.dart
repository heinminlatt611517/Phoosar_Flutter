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
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
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
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../env/env.dart';
import '../../data/models/facebook_user.dart';

class EnterPinCodeScreen extends ConsumerStatefulWidget {
  const EnterPinCodeScreen({
    super.key,
  });

  @override
  ConsumerState<EnterPinCodeScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<EnterPinCodeScreen> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  final TextEditingController _pinController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  ///Email or Phone number
  String selectedText = kEmailLabel;

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();

    bool haveNavigated = false;
    // Listen to auth state to redirect user when the user clicks on confirmation link
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !haveNavigated) {
        haveNavigated = true;
        ref.invalidate(profilesProvider);
        ref.invalidate(profileProvider);
        ref.invalidate(roomsProvider);
        ref.invalidate(supabaseClientProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    errorController?.close();
    // Dispose subscription when no longer needed
    _authSubscription.cancel();
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
                        activeColor: Colors.white,
                        inactiveFillColor: Colors.grey.shade200,
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
                        _pinController.clear();
                      },
                    )),
                  ),

                  10.vGap,

                  ///resend otp text button
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      kResendOTPLabel,
                      style: TextStyle(
                          fontSize: kTextRegular3x, color: Colors.grey),
                    ),
                  ),

                  30.vGap,

                  ///ConfirmButton button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: kConfirmLabel,
                      fontSize: 18,
                      onTap: () {},
                      bgColor: Colors.lightBlueAccent,
                    ),
                  ),

                  100.vGap,

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///facebook signIn button
                      HorizontalTextIconButton(
                          onTap: () {},
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.blue,
                          ),
                          text: kSignInLabel),

                      20.hGap,

                      ///google signIn button
                      HorizontalTextIconButton(
                          onTap: () {},
                          icon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          text: kSignInLabel),
                    ],
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
          password: _passwordController.text,
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
