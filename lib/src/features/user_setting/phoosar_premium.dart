import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/user_setting/user_setting_screen.dart';
import 'package:phoosar/src/features/user_setting/widgets/selectable_card.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:sized_context/sized_context.dart';

class PhoosarPremiumScreen extends ConsumerStatefulWidget {
  @override
  _PhoosarPremiumScreenState createState() => _PhoosarPremiumScreenState();
}

class _PhoosarPremiumScreenState extends ConsumerState<PhoosarPremiumScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var packageList = ref.watch(packageListProvider(context));
    return Scaffold(
      appBar: AppBar(
        title: Text('Phoosar Premium'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                child: PhoosarPremiumView()),
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
                        price: data[index].value ?? '',
                        label: '',
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
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
            ElevatedButton(
              onPressed: () {
                // Handle continue button press
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
          ],
        ),
      ),
    );
  }
}
