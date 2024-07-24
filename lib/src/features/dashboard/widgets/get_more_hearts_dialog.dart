import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/common_dialog.dart';
import 'package:phoosar/src/features/dashboard/widgets/heart_row.dart';
import 'package:phoosar/src/features/user_setting/phoosar_premium.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class GetMoreHeartsDialog extends ConsumerWidget {
  const GetMoreHeartsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var heartList = ref.watch(pointListProvider(context));
    return CommonDialog(
      title: 'Get More Hearts',
      width: 400,
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
            heartList.when(
              data: (data) {
                return Container(
                  height: data.length * 60,
                  child: ListView.builder(
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            HeartRow(
                                likeHeartCount: data[index].value.toString(),
                                heartCount: data[index].point.toString()),
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
            Center(
              child: Text(
                'UNLIMITED Hearts',
                style: GoogleFonts.roboto(
                  fontSize: largeFontSize,
                  color: blueColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            12.vGap,
            Align(
              alignment: Alignment.center,
              child: CommonButton(
                fontSize: mediumFontSize,
                text: "PHOOSAR PREMINUM",
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
