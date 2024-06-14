import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 68,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey),
              color: whitePaleColor,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.heart_broken,
                  size: 15,
                  color: Colors.red,
                ),
                4.hGap,
                Text(
                  '200',
                  style: GoogleFonts.roboto(
                    fontSize: 11,
                    color: blueColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/ic_launcher.png',
                width: 42,
              ),
            ),
          ),
          Container(
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.menu,
                color: blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
