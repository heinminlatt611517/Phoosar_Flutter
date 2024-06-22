import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/settings/settings_controller.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.settingsController})
      : super(key: key);
  final SettingsController settingsController;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
        _isLoading = true;
      });
    }
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
                    onTap: () {},
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
}
