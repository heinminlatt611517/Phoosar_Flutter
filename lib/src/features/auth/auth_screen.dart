import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/auth/register.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:phoosar/src/utils/strings.dart';
import 'package:sized_context/sized_context.dart';
import 'package:video_player/video_player.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({
    super.key,
  });

  static const routeName = '/auth';

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundVideoDataState = ref.watch(backgroundVideoDataProvider(context));
    final configDataState = ref.watch(configDataProvider(context));
    var localeSelected = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: backgroundVideoDataState.when(
        data: (videoData) {
          if (_videoController == null && videoData?.videoUrl != null) {
            _videoController = VideoPlayerController.networkUrl(Uri.parse(videoData?.videoUrl ?? ""))
              ..initialize().then((_) {
                setState(() {});
              });
            _videoController?.play();
            _videoController?.setLooping(true);
            _videoController?.setPlaybackSpeed(0.5);
          }

          return configDataState.when(
            data: (configData) {
              ref
                  .watch(sharedPrefProvider)
                  .setString(kSkipQuestion, configData?.skipQuestion.toString() ?? '');
              return Stack(
                children: [
                  _videoController != null && _videoController!.value.isInitialized
                      ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_videoController!),
                  )
                      : Container(),

                  // Main UI
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App icon
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

                        // Sign in button
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
                                  builder: (context) => OnBoardingScreen(),
                                ),
                              );
                            },
                            bgColor: primaryColor,
                          ),
                        ),

                        24.vGap,

                        // Sign up button
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: CommonButton(
                            containerVPadding: 10,
                            fontSize: 18,
                            isShowBorderColor: true,
                            text: AppLocalizations.of(context)!.kSignUpLabel,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            bgColor: Colors.cyan.withOpacity(0.3),
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
                              padding: const EdgeInsets.only(top: 4, left: 12, bottom: 12),
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
                              padding: const EdgeInsets.only(top: 4, left: 12, bottom: 12),
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
              );
            },
            loading: () => Container(
              height: context.heightPx,
              child: Center(
                child: Image.asset(
                  'assets/images/phoosar_img.png',
                  height: 80,
                ),
              ),
            ),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => Container(
          height: context.heightPx,
          child: Center(
            child: Image.asset(
              'assets/images/phoosar_img.png',
              height: 80,
            ),
          ),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
