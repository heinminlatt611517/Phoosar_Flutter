import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/data/response/payment_success_response.dart';
import 'package:phoosar/src/providers/app_provider.dart';

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
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: qrCode != null
            ? Image.memory(base64Decode(qrCode!))
            : CircularProgressIndicator(),
      ),
    );
  }
}
