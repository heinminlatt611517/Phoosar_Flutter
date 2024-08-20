import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/icon_button.dart';
import '../../utils/colors.dart';

class BlockUserScreen extends StatelessWidget {
  const BlockUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: whitePaleColor,
        title: Text('Blocked List'),
        centerTitle: true,
      ),
      backgroundColor: whitePaleColor,
      body: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                    imageUrl:
                        'https://reputationtoday.in/wp-content/uploads/2019/11/110-1102775_download-empty-profile-hd-png-download.jpg',
                    errorWidget: (context, url, error) => Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiQc9dZn33Wnk-j0sXZ19f8NiMZpJys7nTlA&s')),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: kMarginMedium2),
                    padding: EdgeInsets.symmetric(horizontal: kMarginMedium,vertical: kMarginSmall),
                    decoration: BoxDecoration(color: Colors.pinkAccent,borderRadius: BorderRadius.circular(12),),
                    child: Center(child: Text('Unlock',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 6,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // number of items in each row
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 12,
        ),
      ),
    );
  }
}
