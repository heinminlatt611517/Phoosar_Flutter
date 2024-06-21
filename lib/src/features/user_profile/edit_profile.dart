import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/heart_count.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/features/user_profile/widgets/self_information.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: ListView(
        children: [
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/sample_profile2.jpeg",
                          width: 100,
                          height: 125,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CommonIconButton(
                        onTap: () {},
                        backgroundColor: blueColor,
                        icon: Icon(
                          Icons.delete,
                          color: whiteColor,
                          size: 18,
                        ),
                        padding: 4,
                      ),
                    )
                  ],
                );
              } else {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: greyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: index == 1 || index == 2
                        ? Icon(
                            Icons.add,
                            color: blackColor,
                            size: 24,
                          )
                        : HeartCount(
                            width: 54,
                            heartCount: '10',
                          ),
                  ),
                );
              }
            },
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // number of items in each row
              mainAxisSpacing: 8.0, // spacing between rows
              crossAxisSpacing: 8.0, // spacing between columns
            ),
          ),
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          SelfInformation(
            title: 'Name',
            description: 'Marius',
          ),
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          SelfInformation(
            title: 'About Marius',
            description:
                'Hard work, kindness, and always maintaining a positive outlook.',
          ),
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          SelfInformation(
            title: 'Job Title',
            description: 'Software Engineer',
          ),
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          SelfInformation(
            title: 'School',
            description: 'University of California, Berkeley',
          ),
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
          SelfInformation(
            title: 'Living In',
            description: 'Yangon, Myanmar',
          ),
          24.vGap,
        ],
      ),
    );
  }
}
