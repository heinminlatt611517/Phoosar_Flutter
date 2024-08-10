import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/yes_no_dialog.dart';

import '../common/widgets/icon_button.dart';
import '../providers/app_provider.dart';
import '../providers/data_providers.dart';
import '../utils/colors.dart';

class InterestListItemView extends ConsumerWidget {
  final bool isShowDeleteIcon;
  final String? value;
  const InterestListItemView({super.key,required this.isShowDeleteIcon,this.value});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1,color: Colors.grey)),
            child: Center(child: Text(value??""),),
          ),
        ),
        Visibility(
          visible: isShowDeleteIcon,
          child: Positioned(
            left: 8,
            top: 10,
            child: CommonIconButton(
              onTap: () {
                showYesNoDialog(context: context, onPress: () async{
                  var request = {"interest_name" : value};
                  var response =
                      await ref.read(repositoryProvider).deleteInterest(request, context);
                  if (response.statusCode.toString().startsWith('2')) {
                    ref.invalidate(profileDataProvider(context));
                    Navigator.pop(context);
                    ref.invalidate(profileDataProvider(context));
                  }
                },title: 'Are you sure you want to delete this interest?');
              },
              backgroundColor: primaryColor,
              icon: Icon(
                Icons.delete,
                color: whiteColor,
                size: 18,
              ),
              padding: 4,
            ),
          ),
        )
      ],
    );
  }
}
