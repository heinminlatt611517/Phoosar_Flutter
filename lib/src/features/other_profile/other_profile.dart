import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/features/other_profile/widgets/more_information.dart';
import 'package:phoosar/src/features/other_profile/widgets/profile_slider.dart';
import 'package:phoosar/src/features/other_profile/widgets/user_hobbies.dart';
import 'package:phoosar/src/features/other_profile/widgets/user_information.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.findData,
  });
  final ProfileData findData;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                OtherUserProfileSlider(
                  profileImages: widget.findData.profileImages ?? [],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 40),
                  child: InkWell(
                      onTap: (){ Navigator.of(context).pop();},
                      child: Icon(Icons.arrow_back,color: Colors.grey.withOpacity(0.5),size: 40,)),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInformation(findData: widget.findData),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                  UserHobbies(),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                  MoreInformation(
                    title: 'Two truths on lie',
                    description:
                        'I\'ve climbed the highest mountain in the world, I\'ve been to the moon and I\'ve been to the sun.',
                  ),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                  MoreInformation(
                    title: 'After work, you can find me',
                    description: 'At drinks with friends.',
                  ),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                  MoreInformation(
                    title: 'I could donate a million dollar, it\'d be',
                    description:
                        'Helping the poor, helping the needy and making a difference.',
                  ),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report,
                        color: greyColor,
                      ),
                      12.hGap,
                      Text(
                        'Report Julia',
                        style: GoogleFonts.roboto(
                          fontSize: smallLargeFontSize,
                          color: greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  20.vGap,
                  Divider(
                    height: 1,
                    color: greyColor,
                  ),
                  20.vGap,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
