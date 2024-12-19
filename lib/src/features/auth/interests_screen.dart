import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/data/dummy_data/looking_for_connection_dummy_data.dart';
import 'package:phoosar/src/features/auth/choose_country_and_city_screen.dart';
import 'package:phoosar/src/features/auth/upload_profile_image_screen.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/drop_down_widget.dart';
import '../../common/widgets/selectable_button.dart';
import '../../providers/data_providers.dart';
import '../../utils/constants.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key});

  @override
  ConsumerState<InterestsScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends ConsumerState<InterestsScreen> {
  Set<String> selectedItems = Set();

  void toggleSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final interestsDataState =
    ref.watch(interestsDataProvider(context));
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
          body: interestsDataState.when(data: (data){
            return Padding(
              padding: const EdgeInsets.all(kMarginLarge),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add interests',
                        style: TextStyle(
                            color: Colors.grey, fontSize: kTextRegular24),
                      ),
                      Text(
                        '(Pick 1 to 6)',
                        style:
                        TextStyle(color: Colors.grey, fontSize: kTextSmall),
                      ),

                      20.vGap,

                      ///List view
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: data?.length,
                        itemBuilder: (context, sectionIndex) {
                          final section = data?[sectionIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  section?.title ?? "",
                                  style: TextStyle(
                                      fontSize: kTextRegular2x, fontWeight: FontWeight.w500),
                                ),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1 / 0.3),
                                itemCount: section?.items?.length,
                                itemBuilder: (context, itemIndex) {
                                  final item = section?.items?[itemIndex];
                                  return GestureDetector(
                                    onTap: () => toggleSelection(item ?? ""),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: selectedItems.contains(item)
                                            ? Colors.cyan
                                            : Colors.grey.withOpacity(0.2),
                                      ),
                                      child: Center(child: Text(item ?? "")),
                                    ),
                                  );
                                },
                              ),
                              10.vGap
                            ],
                          );
                        },
                      ),

                      50.vGap,

                      ///continue button
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CommonButton(
                          containerVPadding: 10,
                          text: AppLocalizations.of(context)!.kContinueLabel,
                          fontSize: 18,
                          onTap: () {
                            if (selectedItems.isEmpty) {
                              context.showErrorSnackBar(
                                  message: AppLocalizations.of(context)!
                                      .kErrorMessage);
                            } else {
                              debugPrint("SelectedData:::${selectedItems.toList()}");
                              ref.read(profileSaveRequestProvider.notifier).state.interests = selectedItems.toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UploadProfileImageScreen(),
                                ),
                              );
                            }
                          },
                          bgColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },error: (error, stack) => Container(),
            loading: () => Center(
              child: SpinKitThreeBounce(
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
