import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/data/dummy_data/looking_for_connection_dummy_data.dart';
import 'package:phoosar/src/features/auth/interests_screen.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/selectable_button.dart';
import '../../utils/constants.dart';

class LookingForConnectionScreen extends ConsumerStatefulWidget {
  const LookingForConnectionScreen({super.key});

  @override
  ConsumerState<LookingForConnectionScreen> createState() =>
      _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends ConsumerState<LookingForConnectionScreen> {
  var selectedText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bg_image_4.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              'assets/images/phoosar_img.png',
              height: 40,
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(kMarginLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  50.vGap,
                  Text(
                    'The connection i am looking for',
                    textAlign: TextAlign.center,
                    style:
                    TextStyle(color: Colors.grey, fontSize: kTextRegular24),
                  ),

                  50.vGap,
                  ///List view
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: lookingForConnectionDummyData.length,
                      itemBuilder: (context,index){
                    return  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SelectableButton(
                        label: lookingForConnectionDummyData[index]['title'] ?? "",
                        isSelected: selectedText ==
                            lookingForConnectionDummyData[index]['title'],
                        onTapButton: (value) {
                          setState(() {
                            selectedText = lookingForConnectionDummyData[index]['title'] ?? "";
                          });
                        },
                      ),
                    );
                  }),

                  50.vGap,

                  ///continue button
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: AppLocalizations.of(context)!.kContinueLabel,
                      fontSize: 18,
                      onTap: () {
                        if (selectedText == "") {
                          context.showErrorSnackBar(
                              message: AppLocalizations.of(context)!.kErrorMessage);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InterestsScreen(),
                            ),
                          );
                        }
                      },
                      bgColor: Colors.pinkAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
