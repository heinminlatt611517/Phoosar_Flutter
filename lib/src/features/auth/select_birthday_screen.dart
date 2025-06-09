import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/custom_app_bar_view.dart';
import 'package:phoosar/src/features/auth/choose_country_and_city_screen.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/drop_down_widget.dart';
import '../../providers/data_providers.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

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

  bool isAtLeast18(DateTime birthDate) {
    final today = DateTime.now();
    final eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);
    return birthDate.isBefore(eighteenYearsAgo) || birthDate.isAtSameMomentAs(eighteenYearsAgo);
  }

  @override
  void initState() {
    super.initState();
    days.insert(0, 'Day');
    years = List.generate(61, (i) => (currentYear - i).toString());
    years.insert(0, 'Year');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/choose_birthday_bg.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBarView(),
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
                        AppLocalizations.of(context)!.kBirthdayLabel.toUpperCase(),
                        style:
                            TextStyle(color: Colors.black, fontSize: kTextRegular22,fontFamily: kFontGibsonBold),
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
                if (selectedDay == "" ||
                    selectedMonth == "" ||
                    selectedYear == "") {
                  context.showErrorSnackBar(
                      message: AppLocalizations.of(context)!.kErrorMessage);
                }
                else {
                  var selectedBirthDate =
                      "${selectedDay.toString()}, $selectedMonth, ${selectedYear.toString()}";

                  final selectedBirthDateForCheck = DateTime(
                    int.parse(selectedYear),
                    months.indexOf(selectedMonth) + 1,
                    int.parse(selectedDay),
                  );

                  if (!isAtLeast18(selectedBirthDateForCheck)) {
                    context.showErrorSnackBar(
                      message: 'You must be at least 18 years old to continue.',
                    );
                  }
                  else {
                    ref
                        .read(profileSaveRequestProvider.notifier)
                        .state
                        .birthdate =
                        DateFormat('yyyy-MM-dd').format(
                            DateFormat('d, MMMM, yyyy')
                                .parse(selectedBirthDate));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseCountryAndCityScreen(),
                      ),
                    );
                  }
                }
              },
              bgColor: Colors.black,
              buttonTextColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
