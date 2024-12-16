import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          'assets/images/bg_image_4.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              'assets/images/phoosar_img.png',
              height: 40,
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(kMarginLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "All done!",
                          style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: kTextRegular24),
                        ),
                        15.vGap,
                        Text(
                          "Your profile is complete",
                          style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),

                  ///let go button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: "Find matches",
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
                      bgColor: Colors.pinkAccent,
                    ),
                  ),

                  40.vGap,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
