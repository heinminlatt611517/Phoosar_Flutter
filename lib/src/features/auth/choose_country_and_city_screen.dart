import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/dynamic_drop_down_widget.dart';
import 'package:phoosar/src/features/auth/add_speak_language_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../data/response/country_list_response.dart';
import '../../utils/dimens.dart';

class ChooseCountryAndCityScreen extends ConsumerStatefulWidget {
  const ChooseCountryAndCityScreen({super.key});

  @override
  ConsumerState<ChooseCountryAndCityScreen> createState() =>
      _ChooseCountryAndCityScreenState();
}

class _ChooseCountryAndCityScreenState
    extends ConsumerState<ChooseCountryAndCityScreen> {
  @override
  Widget build(BuildContext context) {
    var countryList = ref.watch(countryListProvider(context));
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
              'assets/images/ic_launcher.png',
              height: 60,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(kMarginLarge),
                  child: countryList.when(data: (countryList) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///currently located city and country dropdown view
                        CurrentlyLocatedCityAndCountryDropdownView(
                          countryList: countryList,
                        ),

                        30.vGap,

                        ///match city and country dropdown view
                        MatchCityAndCountryDropdownView(
                          countryList: countryList,
                        ),

                        60.vGap,

                        ///continue button
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: CommonButton(
                            containerVPadding: 10,
                            text: AppLocalizations.of(context)!.kContinueLabel,
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
                    );
                  }, error: (error, stack) {
                    return Container();
                  }, loading: () {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.pinkAccent,
                      ),
                    );
                  })),
            ),
          ),
        ),
      ],
    );
  }
}

///currently located city and country dropdown view
class CurrentlyLocatedCityAndCountryDropdownView
    extends ConsumerStatefulWidget {
  final List<CountryData> countryList;
  const CurrentlyLocatedCityAndCountryDropdownView(
      {super.key, required this.countryList});

  @override
  ConsumerState<CurrentlyLocatedCityAndCountryDropdownView> createState() =>
      _CurrentlyLocatedCityAndCountryDropdownViewState();
}

class _CurrentlyLocatedCityAndCountryDropdownViewState
    extends ConsumerState<CurrentlyLocatedCityAndCountryDropdownView> {
  @override
  void initState() {
    super.initState();
    ref.read(cityRequestProvider.notifier).state.countryCode =
        widget.countryList.first.code.toString();
    ref.read(profileSaveRequestProvider.notifier).state.country =
        widget.countryList.first.code.toString();
  }

  @override
  Widget build(BuildContext context) {
    var cityList = ref.watch(cityListProvider(context));
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.kCurrentLocateIn,
          style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
        ),
        20.vGap,
        DynamicDropDownWidget(
          items: widget.countryList,
          hintText: 'Country',
          onSelect: (value) {
            ref.invalidate(cityRequestProvider);
            ref.read(profileSaveRequestProvider.notifier).state.country =
                value.code.toString();
            ref.read(cityRequestProvider.notifier).state.countryCode =
                value.code.toString();
            ref.invalidate(cityListProvider);
          },
        ),
        20.vGap,
        cityList.when(data: (cityList) {
          ref.read(profileSaveRequestProvider.notifier).state.city =
              cityList.first.code.toString();
          return DynamicDropDownWidget(
            hintText: 'City',
              items: cityList,
              onSelect: (value) {
                ref.read(profileSaveRequestProvider.notifier).state.city =
                    value.code.toString();
              },
          );
        }, error: (error, stack) {
          return Container(
            child: Text(error.toString()),
          );
        }, loading: () {
          return Container();
        })
      ],
    );
  }
}

///match  city and country dropdown view
class MatchCityAndCountryDropdownView extends ConsumerStatefulWidget {
  final List<CountryData> countryList;
  const MatchCityAndCountryDropdownView({super.key, required this.countryList});

  @override
  ConsumerState<MatchCityAndCountryDropdownView> createState() =>
      _MatchCityAndCountryDropdownViewState();
}

class _MatchCityAndCountryDropdownViewState
    extends ConsumerState<MatchCityAndCountryDropdownView> {
  void initState() {
    super.initState();
    ref.read(matchCityRequestProvider.notifier).state.countryCode =
        widget.countryList.first.code.toString();
    ref.read(profileSaveRequestProvider.notifier).state.matchCountry =
        widget.countryList.first.code.toString();
  }

  Widget build(BuildContext context) {
    var matchCityList = ref.watch(matchCityListProvider(context));
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.kWantMyMatch,
          style: TextStyle(color: Colors.grey, fontSize: kTextRegular24),
        ),
        20.vGap,
        DynamicDropDownWidget(
          hintText: 'Country',
          items: widget.countryList,
          onSelect: (value) {
            ref.invalidate(matchCityRequestProvider);
            ref.read(profileSaveRequestProvider.notifier).state.matchCountry =
                value.code.toString();
            ref.read(matchCityRequestProvider.notifier).state.countryCode =
                value.code.toString();
            ref.invalidate(matchCityListProvider);
          },
        ),
        20.vGap,
        matchCityList.when(data: (cityList) {
          ref.read(profileSaveRequestProvider.notifier).state.matchCity =
              cityList.first.code.toString();
          return DynamicDropDownWidget(
              items: cityList,
              onSelect: (value) {
                ref.read(profileSaveRequestProvider.notifier).state.matchCity =
                    value.code.toString();
              },
              hintText: 'City',);
        }, error: (error, stack) {
          return Container(
            child: Text(error.toString()),
          );
        }, loading: () {
          return Container();
        })
      ],
    );
  }
}
