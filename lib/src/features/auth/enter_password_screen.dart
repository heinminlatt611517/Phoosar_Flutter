import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/input_view.dart';
import 'package:phoosar/src/data/response/authentication_response.dart';
import 'package:phoosar/src/features/auth/choose_gender_screen.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/profile_provider.dart';
import 'package:phoosar/src/providers/profiles_provider.dart';
import 'package:phoosar/src/providers/room_provider.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnterPasswordScreen extends ConsumerStatefulWidget {
  const EnterPasswordScreen({
    super.key,
    required this.email,
    required this.type,
    required this.userName,
    required this.phoneNumber,
  });
  final String email;
  final String type;
  final String userName;
  final String phoneNumber;

  @override
  ConsumerState<EnterPasswordScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<EnterPasswordScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ///Email or Phone number
  String selectedText = "Email";

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
          MaterialPageRoute(builder: (context) => ChooseGenderScreen()),
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
                  InputView(
                      controller: _passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      hintLabel: AppLocalizations.of(context)!.kPasswordLabel),
                  24.vGap,
                  InputView(
                      controller: _confirmPasswordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      hintLabel: AppLocalizations.of(context)!.kConfirmPasswordLabel),

                  10.vGap,

                  30.vGap,

                  ///ConfirmButton button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: AppLocalizations.of(context)!.kConfirmLabel,
                      fontSize: 18,
                      onTap: () {
                        _signUp();
                      },
                      bgColor: Colors.lightBlueAccent,
                    ),
                  ),

                  140.vGap,

                  ///already have account
                  RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        fontSize: kTextRegular2x,
                        color: Colors.grey,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: AppLocalizations.of(context)!.kAlreadyHaveAccount),
                        TextSpan(
                          text: AppLocalizations.of(context)!.kSignInLabel,
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

  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (password != confirmPassword) {
      context.showErrorSnackBar(message: 'Passwords do not match');
      return;
    }
    var response = await ref.read(repositoryProvider).register(
          jsonEncode({
            "value": widget.type == "email" ? widget.email : widget.phoneNumber,
            "password": password,
            "password_confirmation": confirmPassword,
            "user_name": widget.userName,
            "type": widget.type,
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
        await supabase.auth.signUp(
          email: widget.email,
          password: password,
          data: {
            'username': widget.userName,
            'device_token': 'device_token',
          },
          emailRedirectTo: 'io.supabase.chat://login',
        );
      } on AuthException catch (error) {
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
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
