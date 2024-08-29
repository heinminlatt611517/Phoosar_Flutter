import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/response/payment_success_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/gap.dart';

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
        backgroundColor: whitePaleColor,
        title: Text('Payment'),
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
                              color: Colors.pinkAccent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              'EZ Dinger',
                              style: TextStyle(color: Colors.pinkAccent),
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
                              '1.Find the nearest shop',
                              style: TextStyle(color: Colors.grey,fontSize: 10),
                            ),
                            10.vGap,
                            Text(
                              '2.Provide the QR code to the agent',
                              style: TextStyle(color: Colors.grey,fontSize: 10),
                            ),
                            10.vGap,
                            Text(
                              '3.Make Payment',
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
