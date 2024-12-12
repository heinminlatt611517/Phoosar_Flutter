import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/select_birthday_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              'assets/images/ic_launcher.png',
              height: 60,
            ),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.kIamLabel,
                  style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
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

                80.vGap,

                ///continue button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
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
                    bgColor:selectedGender == "" ? Colors.grey : Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///choose gender circle container
class ChooseGenderCircleContainer extends StatelessWidget {
  final String selectedGender;
  final Function(String) onTap;
  const ChooseGenderCircleContainer(
      {super.key, required this.selectedGender, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ///male
        GenderCircleContainerView(
          isMale: true,
          isSelected: selectedGender == "Male",
          onTapButton: () {
            onTap("Male");
          },
          borderColor: Colors.pinkAccent,
        ),

        20.hGap,

        ///female
        GenderCircleContainerView(
            isMale: false,
            isSelected: selectedGender == "Female",
            borderColor: Colors.lightBlueAccent,
            onTapButton: () {
              onTap("Female");
            })
      ],
    );
  }
}

///gender circle container view
class GenderCircleContainerView extends StatelessWidget {
  final bool isSelected;
  final Function onTapButton;
  final Color borderColor;
  final bool isMale;

  const GenderCircleContainerView(
      {super.key,
      required this.isMale,
      required this.isSelected,
      required this.onTapButton,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapButton();
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50)),
        child: isMale
            ? Image.asset('assets/images/male.png',)
            : Image.asset('assets/images/female.png'),
      ),
    );
  }
}
