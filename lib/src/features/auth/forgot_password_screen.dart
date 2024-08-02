import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/request/forgot_password_request.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ForgotPasswordScreen> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  late final StreamSubscription<AuthState> authSubscription;

  ///Email or Phone number
  String selectedText = "Email";
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              100.vGap,

              ///app icon
              Image.asset(
                'assets/images/phoosar_img.png',
                height: 60,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),

              Text(
                kForgetPasswordLabel,
                style: TextStyle(color: Colors.black, fontSize: kTextRegular2x),
              ),

              30.vGap,

              ///email input
              InputView(
                  controller: emailController,
                  hintLabel: AppLocalizations.of(context)!.kEmailLabel),
              60.vGap,

              ///send button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CommonButton(
                  containerVPadding: 10,
                  text: kSendLabel,
                  fontSize: 18,
                  isLoading: _isLoading,
                  onTap: () async {
                    if (!_isLoading) {
                      setState(() {
                        _isLoading = true;
                      });
                      var request = ForgotPasswordRequest(
                          value: emailController.text, type: 'email');
                      var response = await ref
                          .read(repositoryProvider)
                          .forgotPassword(request, context);
                      if (response.statusCode.toString().startsWith('2')) {
                        final Map<String, dynamic> data =
                            json.decode(response.body);
                        context.showSnackBar(
                            message: data['message'],
                            backgroundColor: Colors.pinkAccent);
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
                  bgColor: Colors.pinkAccent,
                ),
              ),

              30.vGap,
            ],
          ),
        ),
      ),
    );
  }
}
