import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/response/package_list_response.dart';
import 'package:phoosar/src/features/payment/payment.dart';
import 'package:phoosar/src/features/user_setting/widgets/selectable_card.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';

import '../../common/widgets/phoosar_premium_carousel_widget.dart';

class PhoosarPremiumScreen extends ConsumerStatefulWidget {
  @override
  _PhoosarPremiumScreenState createState() => _PhoosarPremiumScreenState();
}

class _PhoosarPremiumScreenState extends ConsumerState<PhoosarPremiumScreen> {
  int selectedIndex = -1;
  PackageData? selectedPackageData;

  @override
  Widget build(BuildContext context) {
    var packageList = ref.watch(packageListProvider(context));
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        backgroundColor: whitePaleColor,
        centerTitle: true,
        title: Text('Phoosar Premium'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginLarge,vertical: kMarginMedium2),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(10),),
                  child: PhoosarPremiumCarouselWidget(),
                )),
            20.vGap,
            packageList.when(
              data: (data) => Container(
                height: 140,
                width: context.widthPx,
                child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectableCard(
                        duration: data[index].name ?? '',
                        price: "${data[index].value} kyats" ?? '',
                        label: '',
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedPackageData = data[index];
                          });
                        },
                        isSelected: selectedIndex == index,
                      );
                    }),
              ),
              error: (error, stack) => Text(error.toString()),
              loading: () => CircularProgressIndicator(),
            ),
            SizedBox(height: 32),
            Visibility(
              visible: selectedPackageData != null,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue button press
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                              planType: selectedPackageData?.name ?? '',
                              planTypeId:
                                  selectedPackageData?.id.toString() ?? '',
                              amount: selectedPackageData?.value ?? '')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(horizontal: 64, vertical: 12),
                ),
                child: Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
