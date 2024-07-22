import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/data_providers.dart';

class WhatsNewScreen extends ConsumerWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var whatsNewList = ref.watch(whatsNewProvider(context));
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s New'),
      ),
      body: whatsNewList.when(
        data: (data) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(data[0].titleEn ?? ''),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text(error.toString()),
      ),
    );
  }
}
