import 'package:flutter/material.dart';
import 'package:phoosar/src/features/home/home.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/dimens.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key});

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/ic_launcher.png',
          height: 60,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      kYourAreAllSetLabel,
                      style: TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: kTextRegular24),
                    ),
                    20.vGap,
                    Text(
                      kFindYourMatch,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              ///let go button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CommonButton(
                  containerVPadding: 10,
                  text: kLetGoLabel,
                  fontSize: 18,
                  onTap: () {
                    ///do navigation login
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  bgColor: Colors.pinkAccent,
                ),
              ),

              40.vGap,
            ],
          ),
        ),
      ),
    );
  }
}
