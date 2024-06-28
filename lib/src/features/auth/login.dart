import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phoosar/env/env.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/models/facebook_user.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late final StreamSubscription<AuthState> authSubscription;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
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

  @override
  void initState() {
    super.initState();

    bool haveNavigated = false;
    // Listen to auth state to redirect user when the user clicks on confirmation link
    authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !haveNavigated) {
        haveNavigated = true;
        ref.invalidate(profilesProvider);
        ref.invalidate(profileProvider);
        ref.invalidate(roomsProvider);
        ref.invalidate(supabaseClientProvider);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(settingsController: widget.settingsController)),
        );
      }
    });
  }

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

                ///email input
                InputView(
                    passwordController: emailController,
                    hintLabel: kEmailLabel),
                24.vGap,

                ///password input
                InputView(
                    passwordController: passwordController,
                    hintLabel: kPasswordLabel),

                50.vGap,

                ///Sign in button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: kSignInLabel,
                    fontSize: 18,
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
                  onPressed: () {},
                  child: Text(
                    kForgotPasswordLabel,
                    style:
                        TextStyle(fontSize: kTextRegular3x, color: Colors.grey),
                  ),
                ),

                30.vGap,

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
                        text: kSignInLabel),

                    20.hGap,

                    ///google signIn button
                    HorizontalTextIconButton(
                        onTap: () {
                          googleSignIn();
                        },
                        icon: Icon(
                          Icons.email,
                          color: Colors.red,
                        ),
                        text: kSignInLabel),
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
                      TextSpan(text: kDontHaveAccount),
                      TextSpan(
                        text: kSignUpLabel,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(
                                  settingsController: widget.settingsController,
                                ),
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
      String name, String email) async {}
}
