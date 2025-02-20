import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/select_birthday_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

class ChooseGenderScreen extends ConsumerStatefulWidget {
  const ChooseGenderScreen({super.key});

  @override
  ConsumerState<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends ConsumerState<ChooseGenderScreen> {
  var selectedGender = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        title: Image.asset(
          'assets/images/phoosar_img.png',
          height: 70,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.kIamLabel,
              style: TextStyle(color: Colors.black, fontSize: kTextRegular24,fontWeight: FontWeight.bold),
            ),

            50.vGap,

            ///choose gender view
            ChooseGenderCircleContainer(
              selectedGender: selectedGender,
              onTap: (value) {
                setState(() {
                  selectedGender = value;
                });
                ref.read(profileSaveRequestProvider.notifier).state.gender =
                    value == "Male" ? "1" : "2";
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: ///continue button
      Padding(
        padding: const EdgeInsets.all(60),
        child: CommonButton(
          containerVPadding: 10,
          text: AppLocalizations.of(context)!.kContinueLabel,
          fontSize: 18,
          onTap: () {
            if (selectedGender == "") {
              context.showErrorSnackBar(
                  message: AppLocalizations.of(context)!.kErrorMessage);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectBirthdayScreen(),
                ),
              );
            }
          },
          buttonTextColor: Colors.white,
          bgColor: Colors.black,
        ),
      ),
    );
  }
}

class ChooseGenderCircleContainer extends StatelessWidget {
  final String selectedGender;
  final Function(String) onTap;

  const ChooseGenderCircleContainer({
    super.key,
    required this.selectedGender,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 2.8),
            child: GenderCircleContainerView(
              selectedGender: selectedGender,
              height: 175,
              width: 175,
              isMale: true,
              isSelected: selectedGender == "Male",
              onTapButton: () {
                onTap("Male");
              },
              borderColor: primaryColor,
              imageAsset: 'assets/images/male.png',
              dimImageAsset: 'assets/images/male_dim.png',
            ),
          ),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 2.6,
          top: -2,
          child: GenderCircleContainerView(
            selectedGender: selectedGender,
            height: 200,
            width: 200,
            isMale: false,
            isSelected: selectedGender == "Female",
            onTapButton: () {
              onTap("Female");
            },
            borderColor: Colors.lightBlueAccent,
            imageAsset: 'assets/images/female.png',
            dimImageAsset: 'assets/images/female_dim.png',
          ),
        ),
      ],
    );
  }
}

class GenderCircleContainerView extends StatelessWidget {
  final bool isSelected;
  final Function onTapButton;
  final Color borderColor;
  final bool isMale;
  final double width;
  final double height;
  final String imageAsset;
  final String dimImageAsset;
  final String selectedGender;


  const GenderCircleContainerView({
    super.key,
    required this.isMale,
    required this.isSelected,
    required this.onTapButton,
    required this.borderColor,
    required this.width,
    required this.height,
    required this.imageAsset,
    required this.dimImageAsset,
    required this.selectedGender
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapButton();
      },
      child: Container(
        height: height,
        width: width,
        child:selectedGender == '' ? Image.asset(imageAsset) : isSelected
            ? Image.asset(imageAsset)
            : Image.asset(dimImageAsset),
      ),
    );
  }
}

