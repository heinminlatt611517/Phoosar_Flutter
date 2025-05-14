import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

class VpnScreen extends StatelessWidget {
  const VpnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'TURN ON YOUR VPN TO MAKE SURE NOTHING STANDS IN YOUR WAY!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: kFontGibsonBold,
                        fontSize: 26,
                        letterSpacing: 1.5,
                        color: Colors.white)),
                50.vGap,
                Image.asset(
                  'assets/images/vpn_img.png',
                ),
                50.vGap,
                Image.asset(
                  'assets/images/vpn_mm.png',
                  fit: BoxFit.cover,
                  height: 124,
                ),
              ],
            ),
          )),
    );
  }
}
