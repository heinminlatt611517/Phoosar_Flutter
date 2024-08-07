import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/response/point_list_response.dart';
import 'package:phoosar/src/features/payment/payment.dart';
import 'package:phoosar/src/features/user_setting/widgets/selectable_coin_card.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:sized_context/sized_context.dart';

import '../../common/widgets/phoosar_premium_view.dart';

class GetMoreCoinsScreen extends ConsumerStatefulWidget {
  @override
  _GetMoreCoinsScreenState createState() => _GetMoreCoinsScreenState();
}

class _GetMoreCoinsScreenState extends ConsumerState<GetMoreCoinsScreen> {
  int selectedIndex = -1;
  PointData? selectedPointData;

  @override
  Widget build(BuildContext context) {
    var pointList = ref.watch(pointListProvider(context));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(kGetMoreCoinsLabel),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                child: PhoosarPremiumView(context, kUnlimitedLikeLabel)),
            20.vGap,
            pointList.when(
              data: (data) => Container(
                height: 160,
                width: context.widthPx,
                child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SelectableCoinCard(
                        duration: data[index].name ?? '',
                        price: data[index].value ?? '',
                        point: data[index].point ?? '',
                        label: '',
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedPointData = data[index];
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
              visible: selectedPointData != null,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue button press
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                              planType: selectedPointData?.name ?? '',
                              planTypeId:
                                  selectedPointData?.id.toString() ?? '',
                              amount: selectedPointData?.value ?? '')));
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
