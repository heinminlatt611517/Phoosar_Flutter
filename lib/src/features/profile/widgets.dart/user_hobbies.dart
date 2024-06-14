import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';

class UserHobbies extends StatelessWidget {
  const UserHobbies({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: hobbies
          .map((hobby) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hobby,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: whiteColor,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
