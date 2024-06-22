import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/horizontal_text_icon_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/signIn_screen.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

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

                ///user name input
                InputView(
                    passwordController: userNameController,
                    hintLabel: kUserNameLabel),
                24.vGap,

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

                ///Sign up button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: kSignUpLabel,
                    fontSize: 18,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseGenderScreen(),
                        ),
                      );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
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
