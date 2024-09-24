import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/app_provider.dart';
import '../../utils/colors.dart';

class BlockUserScreen extends ConsumerStatefulWidget {
  const BlockUserScreen({super.key});

  @override
  ConsumerState<BlockUserScreen> createState() => _BlockUserScreenState();
}

class _BlockUserScreenState extends ConsumerState<BlockUserScreen> {
  @override
  Widget build(BuildContext context) {
    var blockUserData = ref.watch(blockedUserDataProvider(context));
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: whitePaleColor,
          title: Text('Blocked List'),
          centerTitle: true,
        ),
        backgroundColor: whitePaleColor,
        body: blockUserData.when(
            data: (data) {
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: data[index].profile?.profileImages?[0] ??
                                  errorImageUrl,
                              errorWidget: (context, url, error) =>
                                  Image.network(errorImageUrl)),
                        ),
                      ),
                      ///unlock button
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () async{
                            await ref.read(repositoryProvider).saveProfileReact(
                              jsonEncode({
                                "reacted_user_id": data[index].profile?.id.toString(),
                                "reacted_type": "unlock"
                              }),
                              context,
                            );
                            ref.invalidate(blockedUserDataProvider);
                          },
                          child: IntrinsicHeight(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: kMarginMedium2),
                              padding: EdgeInsets.symmetric(
                                  horizontal: kMarginMedium,
                                  vertical: kMarginSmall),
                              decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Unblock',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1/1.2
                ),
              );
            },
            error: (error, stack) => Container(),
            loading: () => SpinKitThreeBounce(
                  color: Colors.pinkAccent,
                )));
  }
}
