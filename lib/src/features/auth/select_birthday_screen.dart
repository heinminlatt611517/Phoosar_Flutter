import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/features/auth/choose_country_and_city_screen.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/drop_down_widget.dart';
import '../../providers/data_providers.dart';
import '../../utils/constants.dart';

class SelectBirthdayScreen extends ConsumerStatefulWidget {
  const SelectBirthdayScreen({super.key});

  @override
  ConsumerState<SelectBirthdayScreen> createState() =>
      _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends ConsumerState<SelectBirthdayScreen> {
  var selectedDay = "";
  var selectedMonth = "";
  var selectedYear = "";
  List<String> days = List.generate(31, (i) => (i + 1).toString());
  int currentYear = DateTime.now().year;
  List<String> years = [];

  @override
  void initState() {
    super.initState();
    days.insert(0, 'Day');
    years = List.generate(61, (i) => (currentYear - i).toString());
    years.insert(0, 'Year');
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///day , month , year view
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Text(
                    kBirthdayLabel,
                    style:
                        TextStyle(color: Colors.grey, fontSize: kTextRegular24),
                  ),
                  50.vGap,
                  SizedBox(
                    height: 60,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kMarginLarge),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///day button
                          Flexible(
                            child: DropDownWidget(
                                items: days,
                                onSelect: (value) {
                                  setState(() {
                                    selectedDay = value ?? "";
                                  });
                                },
                                initValue: days.first),
                          ),
                          10.hGap,

                          ///Month
                          Flexible(
                            child: DropDownWidget(
                                items: months,
                                onSelect: (value) {
                                  setState(() {
                                    selectedMonth = value ?? "";
                                  });
                                },
                                initValue: months.first),
                          ),
                          10.hGap,

                          ///Year
                          Flexible(
                            child: DropDownWidget(
                                items: years,
                                onSelect: (value) {
                                  setState(() {
                                    selectedYear = value ?? "";
                                  });
                                },
                                initValue: years.first),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///continue button
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: CommonButton(
                containerVPadding: 10,
                text: kContinueLabel,
                fontSize: 18,
                onTap: () {
                  if (selectedDay == "" ||
                      selectedMonth == "" ||
                      selectedYear == "") {
                    context.showErrorSnackBar(message: kErrorMessage);
                  } else {
                    ref
                            .read(profileSaveRequestProvider.notifier)
                            .state
                            .birthdate =
                        "$selectedDay,$selectedMonth,$selectedYear";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseCountryAndCityScreen(),
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
    );
  }
}
