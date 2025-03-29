import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../utils/fonts.dart';

class PurchaseHistory extends ConsumerWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var purchaseHistory = ref.watch(purchaseHistoryProvider(context));
    return Scaffold(
      backgroundColor: whitePaleColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 20,)),
        title: Text(
          'PURCHASE HISTORY',
          style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text(
                      'Description',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.pink),
                    )),
                Expanded(
                    child: Text(
                  'Date',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink),
                )),
                12.hGap,
                Expanded(
                    flex: 2,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.pink),
                    )),
                Expanded(
                    child: Text(
                  'Status',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.pink),
                )),
              ],
            ),
            20.vGap,
            Divider(height: 1,color: greyColor,),
            20.vGap,
            Expanded(
              child: purchaseHistory.when(
                data: (data) => ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.vGap,
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(data[index].description ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13))),
                            Expanded(
                                child: Text(data[index].date.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13))),
                            12.hGap,
                            Expanded(
                                flex: 2,
                                child: Text(data[index].amount.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13))),
                            Expanded(
                                child: Text(data[index].status ?? '',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13))),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1,
                        )
                      ],
                    );
                  },
                ),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
