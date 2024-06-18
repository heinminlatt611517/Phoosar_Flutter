import 'package:flutter/material.dart';
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
      ),
      backgroundColor: whitePaleColor,
      body: ListView(
        children: [
          Divider(
            height: 1,
            color: greyColor,
          ),
          12.vGap,
        ],
      ),
    );
  }
}
