import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/fonts.dart';
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
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: blackColor,
                        fontFamily: kFontArticulatCFDemiBold,
                      ),
                    ),
                  ),
              20.vGap,
            ],
          ))
          .toList() ?? [],
    );
  }
}
