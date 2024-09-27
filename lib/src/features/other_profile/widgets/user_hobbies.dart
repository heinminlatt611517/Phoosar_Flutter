import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../../data/response/profile.dart';

class UserHobbies extends StatelessWidget {
  final ProfileData findData;
  const UserHobbies({
    super.key,
    required this.findData
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("Interest:::${findData.interests?.length}");
    return findData.interests!.isEmpty ? SizedBox.shrink() : Wrap(
      spacing: 8,
      runSpacing: 8,
      children: findData.interests
          ?.map((interest) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      interest,
                      style: GoogleFonts.roboto(
                        fontSize: smallFontSize,
                        color: whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              20.vGap,
              // Divider(
              //   height: 1,
              //   color: greyColor,
              // ),
              // 20.vGap,
            ],
          ))
          .toList() ?? [],
    );
  }
}
