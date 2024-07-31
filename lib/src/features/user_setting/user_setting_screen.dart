import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phoosar/src/features/user_setting/phoosar_premium.dart';
import 'package:phoosar/src/features/user_setting/purchase_history.dart';
import 'package:phoosar/src/features/user_setting/whats_new.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/drop_down_widget.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class UserSettingScreen extends StatelessWidget {
  const UserSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: whitePaleColor,
        title: Text('Settings'),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kMarginMedium2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///phoosar premium view
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhoosarPremiumScreen()));
                },
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kMarginLarge),
                    child: PhoosarPremiumView(context)),
              ),

              16.vGap,

              ///account setting label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                child: Text(
                  "Account Settings",
                  style:
                      TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
                ),
              ),

              20.vGap,

              ///location and city dropdown with label view
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                  child: CityDropdownWithLabelView()),

              20.vGap,

              ///age range slider view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginMedium),
                child: AgeRangeSliderView(),
              ),

              20.vGap,

              ///map view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginXXLarge),
                child: MapView(),
              ),

              ///horizontal divider
              Container(
                height: 1,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                    horizontal: kMarginLarge, vertical: kMarginSmall),
                color: Colors.grey.withOpacity(0.3),
              ),

              ///Home,Message,UserProfile View
              HomeAndMessageAndUserProfileView(),

              24.vGap,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                child: Text(
                  "Billing",
                  style:
                      TextStyle(color: Colors.grey, fontSize: kTextRegular24),
                ),
              ),

              10.vGap,

              ///Billing and notification view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginXXLarge),
                child: BillingAndNotificationView(),
              ),

              20.vGap,

              ///help and what's new view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginXXLarge),
                child: HelpAndWhatNewView(),
              ),

              25.vGap,

              ///logout and delete account view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: LogoutAndDeleteAccountView(),
              ),

              10.vGap,
            ],
          ),
        ),
      ),
    );
  }
}

///Phoosar premium view
Widget PhoosarPremiumView(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: kMarginMedium),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/phoosar_premium_img.png',
          width: MediaQuery.of(context).size.width / 2,
        ),
        10.vGap,
        Text(
          "Phoosar Premium",
          style: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: kTextRegular22),
        ),
        10.vGap,
        Text(
          "Unlimited Likes & more",
          style: TextStyle(color: Colors.grey.withOpacity(0.4)),
        ),
      ],
    ),
  );
}

///City dropdown with label view
class CityDropdownWithLabelView extends StatelessWidget {
  const CityDropdownWithLabelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Location",
          style: TextStyle(
            fontSize: kTextRegular2x,
            color: Colors.grey,
          ),
        ),
        Spacer(),
        SizedBox(
          height: 60,
          width: 140,
          child: DropDownWidget(
              items: cities, onSelect: (value) {}, initValue: cities.first),
        )
      ],
    );
  }
}

///age range view
class AgeRangeSliderView extends StatelessWidget {
  const AgeRangeSliderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: kMarginMedium, horizontal: kMarginLarge),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1)),
      child: Column(
        children: [
          ///age text
          Row(
            children: [
              Text(
                "Age Range",
                style: TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
              ),
              Spacer(),
              Text(
                "18-36",
                style: TextStyle(color: Colors.grey, fontSize: kTextRegular2x),
              ),
            ],
          ),
          6.vGap,

          ///slider
          Slider(
            value: 1.0,
            min: 1.0,
            max: 3.0,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}

///map view
class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: whitePaleColor,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              topLeft: Radius.circular(12.0),
            ),
            child: Image.asset(
              'assets/images/ic_map.png',
              width: double.infinity,
              fit: BoxFit.fill,
              height: 180,
            ),
          ),

          16.vGap,

          ///maximum distance text
          Row(
            children: [
              Text(
                "Maximum Distance",
                style: TextStyle(
                  fontSize: kTextRegular,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Text(
                "80 Km",
                style: TextStyle(
                  fontSize: kTextRegular,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

///home , message , user profile icon view
class HomeAndMessageAndUserProfileView extends StatelessWidget {
  const HomeAndMessageAndUserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svgs/ic_home.svg',
              width: 22,
              height: 22,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 32,
          color: Colors.grey,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svgs/ic_chat.svg',
              width: 22,
              height: 22,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 32,
          color: Colors.grey,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svgs/ic_account.svg',
              width: 22,
              height: 22,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

///billing view
class BillingAndNotificationView extends StatelessWidget {
  const BillingAndNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///pay container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Text(
                'Pay',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),

              ///container button
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kMarginMedium2, vertical: kMarginSmall),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue),
                child: Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: kTextSmall, color: Colors.white),
                ),
              )
            ],
          ),
        ),

        20.vGap,

        ///power by and ex dinger icon

        ///billing container
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PurchaseHistory()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: kMarginMedium2, vertical: kMarginMedium2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.3))),
            child: Row(
              children: [
                Text(
                  'Purchase History',
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),

                ///arrow forward
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kMarginMedium2, vertical: kMarginSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.5)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        10.vGap,
        Row(
          children: [
            Text(
              'Powered by',
              style: TextStyle(color: Colors.grey),
            ),
            Spacer(),

            ///ez dinder icon
            Image.asset(
              'assets/images/ic_map.png',
              width: 100,
              fit: BoxFit.fill,
              height: 40,
            ),
          ],
        ),

        20.vGap,

        ///notification
        Text(
          'Notifications',
        ),

        8.vGap,

        ///notification container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Text(
                'Push notifications',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

///help and what's new view
class HelpAndWhatNewView extends StatelessWidget {
  const HelpAndWhatNewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///help container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Help &',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Spacer(),
            ],
          ),
        ),

        10.vGap,

        ///arrow container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
              ),
              Spacer(),

              ///arrow forward
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: kMarginMedium2, vertical: kMarginSmall),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.5)),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),

        10.vGap,

        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WhatsNewScreen()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: kMarginMedium2, vertical: kMarginMedium2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.3))),
            child: Row(
              children: [
                Text(
                  'What\'s New',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
                Spacer(),

                ///arrow forward
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kMarginMedium2, vertical: kMarginSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.withOpacity(0.5)),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///logout and delete account view
class LogoutAndDeleteAccountView extends StatelessWidget {
  const LogoutAndDeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///logout container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Logout',
                style: TextStyle(color: Colors.grey),
              ),
              Spacer(),
            ],
          ),
        ),

        16.vGap,

        ///app icon
        Image.asset(
          'assets/images/ic_launcher.png',
          width: 42,
        ),

        16.vGap,

        ///delete account container
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: kMarginMedium2, vertical: kMarginMedium),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))),
          child: Row(
            children: [
              Spacer(),
              Text(
                'Delete Account',
                style: TextStyle(color: Colors.red),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
