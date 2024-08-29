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
  final Function(String name) onTapDelete;
  const InterestListItemView({super.key,required this.isShowDeleteIcon,this.value,required this.onTapDelete});

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
            child: Center(child: Flexible(child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                  value??""),
            )),),
          ),
        ),
        Visibility(
          visible: isShowDeleteIcon,
          child: Positioned(
            left: 8,
            top: 10,
            child: CommonIconButton(
              onTap: () {
                onTapDelete(value ?? "");
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
