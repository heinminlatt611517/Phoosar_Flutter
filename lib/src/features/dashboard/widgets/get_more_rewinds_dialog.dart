import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/rewind_row.dart';
import 'package:phoosar/src/features/user_setting/phoosar_premium.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class GetMoreRewindsDialog extends ConsumerWidget {
  const GetMoreRewindsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rewindList = ref.watch(rewindListProvider(context));
    return CommonDialog(
      title: 'GET MORE REWINDS',
      width: 400,
      isCustomFont : true,
      isExpand: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            12.vGap,
            Divider(
              height: 1,
              color: greyColor,
            ),
            12.vGap,
            rewindList.when(
              data: (data) {
                return Container(
                  height: data.length * 60,
                  child: ListView.builder(
                      itemCount: data.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            RewindRow(
                              rewindCount: data[index].rewind.toString(),
                              heartCount: data[index].point.toString(),
                              buyId: data[index].id.toString(),
                            ),
                            12.vGap,
                            Divider(
                              height: 1,
                              color: greyColor,
                            ),
                            12.vGap,
                          ],
                        );
                      }),
                );
              },
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),
            20.vGap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Unlimited',
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                8.hGap,
                Text(
                  'Rewinds',
                  style: GoogleFonts.roboto(
                    fontSize: mediumFontSize,
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            12.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                bgColor: blackColor,
                fontSize: mediumFontSize,
                text: "PHOOSAR PREMIUM",
                buttonTextColor: orangeColor,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhoosarPremiumScreen(),
                    ),
                  );
                },
              ),
            ),
            12.vGap,
          ],
        ),
      ),
    );
  }
}
