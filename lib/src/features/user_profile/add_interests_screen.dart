import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../common/widgets/common_button.dart';
import '../../common/widgets/icon_button.dart';
import '../../list_items/interest_list_item_view.dart';
import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';
import '../../utils/fonts.dart';

class AddInterestsScreen extends ConsumerStatefulWidget {
  const AddInterestsScreen({super.key});

  @override
  ConsumerState<AddInterestsScreen> createState() => _AddInterestsScreenState();
}

class _AddInterestsScreenState extends ConsumerState<AddInterestsScreen> {
  final TextEditingController _interestController = TextEditingController();
  final List<String> _interests = [];
  var isLoading = false;

  void _addInterest() {
    final String interest = _interestController.text.trim();
    if (interest.isNotEmpty && !_interests.contains(interest)) {
      setState(() {
        _interests.add(interest);
      });
      _interestController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 20,)),
        title: Text(
          AppLocalizations.of(context)!.kAddInterestLabel.toUpperCase(),
          style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: appBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.vGap,
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              AppLocalizations.of(context)!.kTypeInOneInterest,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontSize: kTextRegular3x,
                color: blackColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          20.vGap,

          ///add interest button
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _interestController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.kTapHereToAddInterest,
                        border: InputBorder.none),
                  ),
                ),
                CommonIconButton(
                  onTap: () {
                    _addInterest();
                  },
                  backgroundColor: greyColor,
                  icon: Icon(
                    Icons.add,
                    color: whiteColor,
                    size: 18,
                  ),
                  padding: 4,
                ),
              ],
            ),
          ),

          20.vGap,

          ///new added interest items
          Visibility(
              visible: _interests.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      AppLocalizations.of(context)!.kInterestLabel,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: kTextRegular3x,
                        color: blackColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return InterestListItemView(
                        isShowDeleteIcon: false,
                        value: _interests[index],
                        onTapDelete: (value){},
                      );
                    },
                    itemCount: _interests.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 0.0, // spacing between rows
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 3 / 1 // spacing between columns
                        ),
                  ),
                ],
              )),

          20.vGap,

          Center(
            child: Container(
              width: 180,
              child: CommonButton(
                containerVPadding: 10,
                text: AppLocalizations.of(context)!.kSaveLabel,
                isLoading: isLoading,
                fontSize: 18,
                onTap: () async {
                  if(_interests.isNotEmpty){
                    setState(() {
                      isLoading = true;
                    });
                    var response = await ref
                        .read(repositoryProvider)
                        .addInterests({"interest_names": _interests}, context);
                    if (response.statusCode.toString().startsWith('2')) {
                      ref.invalidate(profileDataProvider);
                      showSuccessUpdated(context);
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                bgColor: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

showSuccessUpdated(context) {
  SnackBar snackBar = SnackBar(
    content: Text(
      'Profile successfully updated',
      textAlign: TextAlign.center,
      style: GoogleFonts.roboto(
        fontSize: 12,
        color: whiteColor,
      ),
    ),
    backgroundColor: greenColor,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(left: 1, right: 1),
    duration: Duration(seconds: 1),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {
    Navigator.of(context).pop();
  });;
}
