import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.settingsController});
  final SettingsController settingsController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    bool haveNavigated = false;
    // Listen to auth state to redirect user when the user clicks on confirmation link
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && !haveNavigated) {
        haveNavigated = true;
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
    super.dispose();

    // Dispose subscription when no longer needed
    _authSubscription.cancel();
  }

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;
    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username, 'device_token': 'device_token'},
        emailRedirectTo: 'io.supabase.chat://login',
      );
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      debugPrint(error.toString());
      context.showErrorSnackBar(message: unexpectedErrorMessage);
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

                  ///user name input
                  InputView(
                      passwordController: _usernameController,
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
                      passwordController: _emailController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      hintLabel: kEmailLabel),
                  24.vGap,

                  ///password input
                  InputView(
                      passwordController: _passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        if (val.length < 6) {
                          return '6 characters minimum';
                        }
                        return null;
                      },
                      hintLabel: kPasswordLabel),

                  50.vGap,

                  ///Sign up button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: kSignUpLabel,
                      fontSize: 18,
                      onTap: () {
                        _signUp();
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

                  30.vGap,

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
                                  builder: (context) => LoginScreen(
                                    settingsController:
                                        widget.settingsController,
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
      ),
    );
  }
}
