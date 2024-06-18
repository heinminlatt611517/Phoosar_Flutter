import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

class MessageListItemView extends StatelessWidget {
  const MessageListItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
      child: Column(
        children: [
          18.vGap,

          Row(
            children: [
              ///user image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/images/sample_profile.png",
                  width: 60,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              16.hGap,

              ///Name , status and description
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///name and status
                    Row(
                      children: [
                        Text(
                          "Julia",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: kTextRegular22,
                              fontWeight: FontWeight.bold),
                        ),
                        10.hGap,

                        ///status
                        ///green circle indicator
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(3)),
                        ),
                        4.hGap,
                        Text(
                          "Online",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: kTextSmall,
                          ),
                        ),
                      ],
                    ),
                    6.hGap,

                    ///description
                    Text(
                      maxLines: 2,
                      "Hey, how's going? Wanna hang out today?We could...",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: kTextSmall,
                      ),
                    ),
                  ],
                ),
              ),

              ///message red count circle container
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text(
                    "2",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),

          18.vGap,

          ///horizontal divider
          Container(
            width: double.infinity,
            height: 0.2,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
