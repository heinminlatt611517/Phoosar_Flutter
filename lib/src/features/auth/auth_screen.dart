import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/user_profile/edit_profile.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({
    super.key,
  });

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var localeSelected = ref.watch(localeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ///wave bg
          // Image.asset(
          //   'assets/images/auth_wave_bg.png',
          //   height: double.infinity,
          //   width: double.infinity,
          //   fit: BoxFit.fill,
          // ),

          ///logo,signIn,signUp
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///app icon
                Image.asset(
                  'assets/images/phoosar_img.png',
                  height: 80,
                ),
                8.vGap,

                Text(
                  'Destination, Myanmar Connections',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                60.vGap,

                ///Sign in button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: AppLocalizations.of(context)!.kSignInLabel,
                    fontSize: 18,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    bgColor: Colors.pinkAccent,
                  ),
                ),

                24.vGap,

                ///Sign up button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    fontSize: 18,
                    text: AppLocalizations.of(context)!.kSignUpLabel,
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
              margin: EdgeInsets.only(bottom: 80),
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
                      padding:
                          const EdgeInsets.only(top: 4, left: 12, bottom: 12),
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
                              color: Colors.black,
                            ),
                          )
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
                      padding:
                          const EdgeInsets.only(top: 4, left: 12, bottom: 12),
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
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
