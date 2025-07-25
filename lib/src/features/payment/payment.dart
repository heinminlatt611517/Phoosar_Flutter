import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/response/payment_success_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';
import '../../localization/app_localizations.dart';

import '../../utils/fonts.dart';


class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen(
      {super.key,
      required this.planType,
      required this.planTypeId,
      required this.amount});

  final String planType;
  final String planTypeId;
  final String amount;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentSuccessResponse? paymentSuccessResponse;
  String? qrCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final response = await ref.watch(repositoryProvider).ezPayment(
          jsonEncode({
            "plan_type": widget.planType,
            "plan_type_id": widget.planTypeId,
            "amount": widget.amount,
          }),
          context);
      if (response.statusCode.toString().startsWith('2')) {
        setState(() {
          paymentSuccessResponse =
              PaymentSuccessResponse.fromJson(jsonDecode(response.body));
          qrCode = paymentSuccessResponse?.data?.qrCode ?? '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)!.kPayment.toUpperCase(),
          style: TextStyle(fontFamily: kFontGibsonBold,color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: qrCode != null
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child:Image.asset(
                              'assets/images/ez_dinger.png',
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  20.vGap,
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                      padding: EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Image.memory(base64Decode(qrCode!))),
                            20.vGap,
                            Text(
                              '1. ${AppLocalizations.of(context)!.kFindNearestShop}',
                              style: TextStyle(color: Colors.grey,fontSize: 10),
                            ),
                            10.vGap,
                            Text(
                              '2. ${AppLocalizations.of(context)!.kProvideQrCode}',
                              style: TextStyle(color: Colors.grey,fontSize: 10),
                            ),
                            10.vGap,
                            Text(
                              '3. ${AppLocalizations.of(context)!.kMakePayment}',
                              style: TextStyle(color: Colors.grey,fontSize: 10),
                            ),
                          ],
                        ),
                      )),
                ]
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
