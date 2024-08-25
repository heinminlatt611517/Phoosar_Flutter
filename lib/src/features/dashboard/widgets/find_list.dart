import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/providers/data_providers.dart';

class FindListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final findListState = ref.watch(findListNotifierProvider(context));

    return findListState.when(
      data: (profiles) {
        if (profiles == null || profiles.isEmpty) {
          return Center(child: Text('No profiles found.'));
        }
        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return ListTile(
              title: Text(profile.name.toString()),
              // Add other profile details here
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
