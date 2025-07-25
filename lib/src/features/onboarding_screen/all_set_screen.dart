import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../localization/app_localizations.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/dimens.dart';

class AllSetScreen extends ConsumerStatefulWidget {
  const AllSetScreen({super.key});

  @override
  ConsumerState<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends ConsumerState<AllSetScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/auth_bg.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                160.vGap,
                Image.asset(
                  'assets/images/white_logo.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
                26.vGap,
                Text(
                  AppLocalizations.of(context)!.kAllDone.toUpperCase(),
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 34
                  ),
                ),
                12.vGap,
                Text(
                  '${AppLocalizations.of(context)!.kYourProfileIsComplete}.',
                  style: TextStyle(color: Colors.white),
                ),

              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 60,left: 60,right: 60),
            child: CommonButton(
              containerVPadding: 10,
              text:AppLocalizations.of(context)!.kFindMatches.toUpperCase(),
              fontSize: 18,
              onTap: () {
                ref
                    .watch(sharedPrefProvider)
                    .setString(kRecentOnboardingKey, kCompleteStatus);

                ///do navigation login
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false,
                );
              },
              bgColor: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
