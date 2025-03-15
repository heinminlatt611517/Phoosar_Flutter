import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/custom_app_bar_view.dart';
import 'package:phoosar/src/features/auth/upload_profile_image_screen.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../providers/data_providers.dart';
import '../../utils/constants.dart';

class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key});

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  Set<String> selectedItems = Set();

  void toggleSelection(String item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      }
      else if (selectedItems.length < 6) {
        selectedItems.add(item);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text('You can only select up to 6 items',style: TextStyle(color: Colors.white),),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final interestsDataState = ref.watch(interestsDataProvider(context));

    return Stack(
      children: [
        Scaffold(
          backgroundColor: whitePaleColor,
          appBar: CustomAppBarView(),
          body: interestsDataState.when(
            data: (data) {
              if (data == null || data.isEmpty) {
                return Center(
                  child: Text(
                    'There is no data',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(kMarginLarge),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.kInterests.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black, fontSize: kTextRegular22,fontFamily: kFontGibsonBold),
                      ),
                      Text(
                        '(${AppLocalizations.of(context)!.kPickOneToSix.toUpperCase()})',
                        style: TextStyle(color: Colors.black, fontSize: kTextSmall),
                      ),
                      30.vGap,
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1 / 0.3,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, itemIndex) {
                          final item = data[itemIndex];
                          return GestureDetector(
                            onTap: () => toggleSelection(item ?? ""),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: selectedItems.contains(item)
                                    ? Color(0xffE7647A)
                                    : Colors.white,
                                border: Border.all(color: Colors.black,width: 1.5)
                              ),
                              child: Center(child: Text(item,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight:FontWeight.w600),)),
                            ),
                          );
                        },
                      ),
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 60,right: 60,bottom: 60),
            child: CommonButton(
              containerVPadding: 10,
              text: AppLocalizations.of(context)!.kContinueLabel,
              fontSize: 18,
              onTap: () {
                if (selectedItems.isEmpty) {
                  context.showErrorSnackBar(
                    message: AppLocalizations.of(context)!.kErrorMessage,
                  );
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
              bgColor: Colors.black,
              buttonTextColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
