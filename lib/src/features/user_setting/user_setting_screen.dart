import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/auth/login.dart';
import 'package:phoosar/src/features/user_setting/block_user_screen.dart';
import 'package:phoosar/src/features/user_setting/phoosar_premium.dart';
import 'package:phoosar/src/features/user_setting/purchase_history.dart';
import 'package:phoosar/src/features/user_setting/whats_new.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/phoosar_premium_carousel_widget.dart';
import '../../utils/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettingScreen extends ConsumerWidget {
  const UserSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selfProfileData = ref.watch(selfProfileProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: whitePaleColor,
        title: Text(
          AppLocalizations.of(context)!.kSettingLowerCaseLabel,
        ),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: kMarginMedium2, horizontal: kMarginMedium2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///phoosar premium view
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoosarPremiumScreen()));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMarginMedium),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: PhoosarPremiumCarouselWidget(),
                    )),
              ),

              20.vGap,

              ///location and city dropdown with label view
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kAccountSettingLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                  ),
                  12.vGap,
                  LabelWithIconOrText(
                    label: AppLocalizations.of(context)!.kLocationLabel,
                    isIcon: false,
                    text: 'Yangon',
                  ),
                ],
              ),

              20.vGap,

              ///active subscription
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kActiveSubscriptionLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                  ),
                  12.vGap,
                  LabelWithIconOrText(
                    label: (selfProfileData?.data?.isPremium ?? false)
                        ? 'Phoosar Premium'
                        : 'None',
                    isIcon: false,
                  ),
                ],
              ),

              28.vGap,

              ///billing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kBillingLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                  ),
                  12.vGap,
                  LabelWithIconOrText(
                    label: AppLocalizations.of(context)!.kPurchaseHistoryLabel,
                    isIcon: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PurchaseHistory()));
                    },
                  ),
                ],
              ),

              28.vGap,

              ///privacy
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kPrivacyLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                  ),
                  12.vGap,
                  LabelWithIconOrText(
                    label: AppLocalizations.of(context)!.kBlockingLabel,
                    isIcon: false,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlockUserScreen()));
                    },
                  ),
                ],
              ),

              20.vGap,

              ///notification
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.kNotificationLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                  ),
                  12.vGap,
                  LabelWithIconOrText(
                    label: AppLocalizations.of(context)!.kPushNotificationLabel,
                    isIcon: false,
                    onTap: () {},
                  ),
                ],
              ),

              40.vGap,

              ///help and what's new view
              HelpAndWhatNewView(),

              40.vGap,

              ///logout and delete account view
              LogoutAndDeleteAccountView(),

              10.vGap,
            ],
          ),
        ),
      ),
    );
  }
}

///help and what's new view
class HelpAndWhatNewView extends StatelessWidget {
  const HelpAndWhatNewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///help container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Spacer(),
              Text(
                AppLocalizations.of(context)!.kHelpAndSupportLabel,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
        ),

        10.vGap,

        ///term and conditions
        LabelWithIconOrText(
          label: AppLocalizations.of(context)!.kTermAndConditionLabel,
          isIcon: true,
        ),

        10.vGap,

        ///what news container
        LabelWithIconOrText(
          label: AppLocalizations.of(context)!.kWhatNewLabel,
          isIcon: true,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WhatsNewScreen()));
          },
        ),
      ],
    );
  }
}

///logout and delete account view
class LogoutAndDeleteAccountView extends ConsumerWidget {
  const LogoutAndDeleteAccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selfProfileData = ref.watch(selfProfileProvider);
    return Column(
      children: [
        ///logout container
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            logout(context, ref);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: kMarginMedium2, vertical: kMarginMedium2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.3))),
            child: Row(
              children: [
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.kLogoutLabel,
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
              ],
            ),
          ),
        ),

        16.vGap,

        ///app icon
        Image.asset(
          selfProfileData != null && (selfProfileData.data!.isPremium ?? false)
              ? 'assets/images/ic_premium_launcher.png'
              : 'assets/images/ic_launcher.png',
          width: (selfProfileData!.data!.isPremium ?? false) ? 60 : 42,
          fit: BoxFit.fill,
        ),

        16.vGap,

        ///delete account container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Spacer(),
              Text(
                AppLocalizations.of(context)!.kDeleteAccountLabel,
                style: TextStyle(color: Colors.red),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    // Clear shared preferences
    await ref.read(sharedPrefProvider).clear();

    // Navigate to the login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}

///label with icon or text container view
class LabelWithIconOrText extends StatelessWidget {
  final String label;
  final String? text;
  final bool isIcon;
  final Function()? onTap;
  const LabelWithIconOrText(
      {super.key,
      required this.label,
      required this.isIcon,
      this.text,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: kMarginMedium2, vertical: kMarginMedium2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.3))),
        child: Row(
          children: [
            Text(
              label,
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
            ),
            Spacer(),

            ///arrow forward
            Visibility(
                visible: isIcon,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kMarginMedium2, vertical: kMarginSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.5)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                )),

            Visibility(
              visible: !isIcon,
              child: Text(
                text ?? "",
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
