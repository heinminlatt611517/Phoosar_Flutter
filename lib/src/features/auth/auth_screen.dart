import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:phoosar/src/utils/strings.dart';

import '../../data/response/config_response.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({
    super.key,
  });

  static const routeName = '/auth';

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _fetchConfigData();
    });
  }

  ///fetch config data
  Future<void> _fetchConfigData() async {
    final response = await ref.read(repositoryProvider).getConfig(
      context,
    );
    var data = ConfigResponse.fromJson(jsonDecode(response.body)).data;
    ref.watch(sharedPrefProvider).setString(
        kSkipQuestion, data?.skipQuestion.toString() ?? '');
  }


  @override
  Widget build(BuildContext context) {
    var localeSelected = ref.watch(localeProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
              children: [
                Image.asset(
                  'assets/images/auth_bg.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),

                /// Main UI
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(height: MediaQuery.of(context).size.height/4.5,),
                      /// App icon
                      Image.asset(
                        'assets/images/white_logo.png',
                        height: 80,
                      ),
                      8.vGap,

                      Text(
                        'Find Myanmar Connections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      60.vGap,

                      /// Sign in button
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: AppLocalizations.of(context)!.kSignInLabel.toUpperCase(),
                          fontSize: 18,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          bgColor: primaryColor,
                        ),
                      ),

                      24.vGap,

                      /// Sign up button
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CommonButton(
                          containerVPadding: 10,
                          fontSize: 18,
                          isShowBorderColor: true,
                          text: AppLocalizations.of(context)!.kSignUpLabel.toUpperCase(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          bgColor: Colors.cyan,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            var sharedPrefs = ref.watch(sharedPrefProvider);
                            sharedPrefs.setString("locale", "en");
                            ref.invalidate(localeProvider);
                          },
                          child: Container(
                            height: 60,
                            width: 110,
                            padding: const EdgeInsets.only(
                                top: 4, left: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/eng.png",
                                      width: 24,
                                    ),
                                    10.hGap,
                                    Text(
                                      "English",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: localeSelected == "en",
                                  child: Container(
                                    height: 1,
                                    margin: EdgeInsets.only(top: 8),
                                    width: double.infinity,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            var sharedPrefs = ref.watch(sharedPrefProvider);
                            sharedPrefs.setString("locale", "my");
                            ref.invalidate(localeProvider);
                          },
                          child: Container(
                            height: 60,
                            width: 110,
                            padding: const EdgeInsets.only(
                                top: 4, left: 12, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/burma.png",
                                      width: 24,
                                    ),
                                    10.hGap,
                                    Text(
                                      "မြန်မာ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: localeSelected == "my",
                                  child: Container(
                                    height: 1,
                                    margin: EdgeInsets.only(top: 8),
                                    width: double.infinity,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
         );
  }
}
