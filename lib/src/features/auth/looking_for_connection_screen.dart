import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/custom_app_bar_view.dart';
import 'package:phoosar/src/features/auth/interests_screen.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
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

class _ChooseGenderScreenState
    extends ConsumerState<LookingForConnectionScreen> {
  var selectedText = "";
  var selectedValue = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final matchTypes = ref.watch(matchTypeDataProvider(context));
    return Stack(
      children: [
        Scaffold(
            backgroundColor: whitePaleColor,
            appBar: CustomAppBarView(),
            body: matchTypes.when(
              data: (data) {
                if (data == null || data.isEmpty) {
                  return Center(
                    child: Text(
                      'There is no data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(kMarginLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        50.vGap,
                        Text(
                          AppLocalizations.of(context)!.theConnectionLookingFor,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontSize: kTextRegular24,fontWeight: FontWeight.bold),
                        ),

                        50.vGap,

                        ///List view
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SelectableButton(
                                  initialBgColor: data[index].backgroundColor,
                                  label: data[index].label ?? "",
                                  isSelected: selectedText == data[index].label,
                                  onTapButton: (value) {
                                    setState(() {
                                      selectedText = data[index].label ?? "";
                                      selectedValue = data[index].value ?? "";
                                    });
                                  },
                                ),
                              );
                            }),

                      ],
                    ),
                  ),
                );
              },
              error: (error, stack) => Center(
                child: Text(
                  AppLocalizations.of(context)!.kErrorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              loading: () => Center(
                child: SpinKitThreeBounce(
                  color: primaryColor,
                ),
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
                if (selectedText == "") {
                  context.showErrorSnackBar(
                      message: AppLocalizations.of(context)!
                          .kErrorMessage);
                } else {
                  ref.read(profileSaveRequestProvider.notifier).state.matchType = selectedValue;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InterestsScreen(),
                    ),
                  );
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
