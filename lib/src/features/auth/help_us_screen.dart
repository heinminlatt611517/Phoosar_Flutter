import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/onboarding_screen/onboarding_screen.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/dimens.dart';

class HelpUsScreen extends ConsumerStatefulWidget {
  const HelpUsScreen({super.key});

  @override
  ConsumerState<HelpUsScreen> createState() => _HelpUsScreenState();
}

class _HelpUsScreenState extends ConsumerState<HelpUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/ic_launcher.png',
          height: 60,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.kHelpUsGetToKnowLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: kTextRegular24),
              ),

              20.vGap,

              Text(
                AppLocalizations.of(context)!
                    .kAnswerFollowingQuestionToFindPerfectMatch,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: kTextRegular),
              ),

              120.vGap,

              ///continue button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CommonButton(
                  containerVPadding: 10,
                  text: AppLocalizations.of(context)!.kContinueLabel,
                  fontSize: 18,
                  onTap: () {
                    ref
                        .watch(sharedPrefProvider)
                        .setString(kRecentOnboardingKey, kQuestionStatus);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OnBoardingScreen(),
                      ),
                    );
                  },
                  bgColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
