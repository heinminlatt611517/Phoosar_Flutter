import 'package:flutter/material.dart';
import 'package:phoosar/src/features/profile/widgets.dart/more_information.dart';
import 'package:phoosar/src/features/profile/widgets.dart/profile_slider.dart';
import 'package:phoosar/src/features/profile/widgets.dart/user_hobbies.dart';
import 'package:phoosar/src/features/profile/widgets.dart/user_information.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileSlider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInformation(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
