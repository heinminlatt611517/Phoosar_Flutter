import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../common/widgets/icon_button.dart';
import '../../list_items/interest_list_item_view.dart';
import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';

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
        backgroundColor: whitePaleColor,
        title: Text('Add Interests'),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        20.vGap,
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Type in one interest at a time hit the\n"+" icon',
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
                      hintText: 'Tap here to add an interest',
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
              'Interests',
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                fontSize: kTextRegular3x,
                color: blackColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              return InterestListItemView(isShowDeleteIcon: false,value: _interests[index],);
            },
            itemCount: _interests.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 0.0, // spacing between rows
                crossAxisSpacing: 10.0,
                childAspectRatio: 3 / 1 // spacing between columns
            ),
          ),
        ],)),

        20.vGap,

        Center(
          child: CommonButton(
            containerVPadding: 10,
            text: "Save",
            isLoading: isLoading,
            fontSize: 18,
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              var response =
              await ref.read(repositoryProvider).addInterests({"interest_names":_interests}, context);
              if (response.statusCode.toString().startsWith('2')) {
                Navigator.of(context).pop();
                ref.invalidate(profileDataProvider);
              }
              else{
                setState(() {
                  isLoading = false;
                });
              }
            },
            bgColor: Colors.pinkAccent,
          ),
        ),

      ],),
    );
  }
}
