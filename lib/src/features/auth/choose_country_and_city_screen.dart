import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/drop_down_widget.dart';
import 'package:phoosar/src/features/auth/add_speak_language_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/dimens.dart';

class ChooseCountryAndCityScreen extends StatefulWidget {
  const ChooseCountryAndCityScreen({super.key});

  @override
  State<ChooseCountryAndCityScreen> createState() =>
      _ChooseCountryAndCityScreenState();
}

class _ChooseCountryAndCityScreenState
    extends State<ChooseCountryAndCityScreen> {
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
              ///currently located city and country dropdown view
              CurrentlyLocatedCityAndCountryDropdownView(),

              30.vGap,

              ///match city and country dropdown view
              MatchCityAndCountryDropdownView(),

              60.vGap,

              ///continue button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CommonButton(
                  containerVPadding: 10,
                  text: kContinueLabel,
                  fontSize: 18,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSpeakLanguageScreen(),
                      ),
                    );
                  },
                  bgColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///currently located city and country dropdown view
class CurrentlyLocatedCityAndCountryDropdownView extends ConsumerWidget {
  const CurrentlyLocatedCityAndCountryDropdownView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(profileSaveRequestProvider.notifier).state.city = cities.first;
    ref.read(profileSaveRequestProvider.notifier).state.country = 'Myanmar';
    return Column(
      children: [
        Text(
          kCurrentLocateIn,
          style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
        ),
        20.vGap,
        DropDownWidget(
            items: cities,
            onSelect: (value) {
              ref.read(profileSaveRequestProvider.notifier).state.city = value;
            },
            initValue: cities.first),
        20.vGap,
        DropDownWidget(
            items: ['Myanmar'],
            onSelect: (value) {
              ref.read(profileSaveRequestProvider.notifier).state.country =
                  value;
            },
            initValue: 'Myanmar'),
      ],
    );
  }
}

///match  city and country dropdown view
class MatchCityAndCountryDropdownView extends StatelessWidget {
  const MatchCityAndCountryDropdownView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          kWantMyMatch,
          style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
        ),
        20.vGap,
        DropDownWidget(
            items: cities, onSelect: (value) {}, initValue: cities.first),
        20.vGap,
        DropDownWidget(
            items: cities, onSelect: (value) {}, initValue: cities.first),
      ],
    );
  }
}
