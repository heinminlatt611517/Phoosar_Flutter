import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/custom_switch.dart';
import 'package:phoosar/src/features/dashboard/widgets/get_more_coins_dialog.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../../providers/app_provider.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var localeSelected = ref.watch(localeProvider);
    var selfProfileData = ref.watch(selfProfileProvider);
    var showBuyCoinData = ref.watch(showBuyCoinProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          showBuyCoinData.toString() == '1' ?
          GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          showDialog(
              context: context, builder: (context) => GetMoreCoinsDialog());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black),
            color: whitePaleColor,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/update_coin.png',
                height: 16,
                fit: BoxFit.cover,
              ),
              4.hGap,
              Container(
                child: Text(
                  selfProfileData != null && selfProfileData.data != null
                      ? (selfProfileData.data!.pointTotal.toString())
                      : "0",
                  textAlign: TextAlign.end,
                  style: GoogleFonts.roboto(
                      fontSize: smallFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      )
              :
          InkWell(
            onTap: (){
              ref.read(dashboardProvider.notifier).setPosition(2);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
              CachedNetworkImage(
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  imageUrl: selfProfileData?.data?.profileImages?.first ?? errorImageUrl),),
          ) ,
          Expanded(
            child: Center(
              child: Image.asset(
                selfProfileData != null &&
                    (selfProfileData.data!.isPremium ?? false)
                    ? 'assets/images/ic_premium_launcher.png'
                    : 'assets/images/phoosar_img.png',
                width: selfProfileData != null
                    ? (selfProfileData.data!.isPremium ?? false)
                    ? 60
                    : 120
                    : 0,
                fit: BoxFit.fill,
              ),
            ),
          ),
          CustomSwitch(
            width: 82.0,
            height: 30.0,
            toggleSize: 40.0,
            padding: 0,
            value: localeSelected == "en" ? false : true,
            activeToggleColor: Colors.transparent,
            inactiveToggleColor: Colors.transparent,
            activeSwitchBorder: Border.all(
              color: Colors.black,
              width: 1,
            ),
            inactiveSwitchBorder: Border.all(
              color: Colors.black,
              width: 1,
            ),
            activeToggleBorder: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
            inactiveToggleBorder: Border.all(
              color: Colors.transparent,
              width: 0.0,
            ),
            valueFontSize: 10,
            activeText: 'Burmese',
            activeTextColor: Colors.black,
            inactiveText: 'English',
            activeTextFontWeight: FontWeight.normal,
            inactiveTextColor: Colors.black,
            showOnOff: true,
            inactiveTextFontWeight: FontWeight.normal,
            activeColor: Colors.white,
            inactiveColor: Colors.white,
            activeIcon: Image.network(
              fit: BoxFit.cover,
              "https://static.vecteezy.com/system/resources/previews/011/571/448/original/circle-flag-of-myanmar-free-png.png",
            ),
            inactiveIcon: Image.network(
              fit: BoxFit.cover,
              "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/United-kingdom_flag_icon_round.svg/2048px-United-kingdom_flag_icon_round.svg.png",
            ),
            onToggle: (val) {
              if (val) {
                var sharedPrefs = ref.watch(sharedPrefProvider);
                sharedPrefs.setString("locale", "my");
                ref.invalidate(localeProvider);
              } else {
                var sharedPrefs = ref.watch(sharedPrefProvider);
                sharedPrefs.setString("locale", "en");
                ref.invalidate(localeProvider);
              }
            },
          ),
        ],
      ),
    );
  }
}