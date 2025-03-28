import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_success_dailog.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/response/self_profile_response.dart';

class UnlockDailog extends ConsumerWidget {
  const UnlockDailog(
      {super.key, required this.heartCount, required this.buyId});
  final String heartCount;
  final String buyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CommonDialog(
      isLargeTitleSize: true,
      title: AppLocalizations.of(context)!.kUnlockFeatureLabel,
      width: 400,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.vGap,
            Center(
              child: Container(
                width: 80,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/coin.png',
                      height: 16,
                      fit: BoxFit.cover,
                    ),
                    4.hGap,
                    Text(
                      heartCount,
                      style: GoogleFonts.roboto(
                        fontSize: normalFontSize,
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.vGap,
            InkWell(
              onTap: () async {
                //Navigator.pop(context);
                var response = await ref.watch(repositoryProvider).buyWithPoint(
                    jsonEncode({"point_buying_id": buyId}), context);

                final profileesponse =
                await ref.watch(repositoryProvider).getProfile(jsonEncode({}), context);
                var data = SelfProfileResponse.fromJson(jsonDecode(profileesponse.body));

                if (profileesponse.statusCode.toString().startsWith("2") && response.statusCode.toString().startsWith("2")) {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (context) => UnlockSuccessDailog());

                  ref.read(selfProfileProvider.notifier).state = data;
                }
              },
              child: Text(
                AppLocalizations.of(context)!.kUnlockLabel.toUpperCase(),
                style: GoogleFonts.roboto(
                  fontSize: kTextRegular,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
