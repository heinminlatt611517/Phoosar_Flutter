import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../../utils/dimens.dart';

class SelectableCoinCard extends StatefulWidget {
  final String duration;
  final String price;
  final String label;
  final String point;
  final bool isSelected;
  final Function onTap;
  final bool? isPopular;

  const SelectableCoinCard({
    Key? key,
    required this.duration,
    required this.price,
    required this.label,
    required this.point,
    required this.isSelected,
    required this.onTap,
    this.isPopular = false
  }) : super(key: key);

  @override
  _SelectableCoinCardState createState() => _SelectableCoinCardState();
}

class _SelectableCoinCardState extends State<SelectableCoinCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: widget.isSelected ? Colors.pinkAccent : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.isSelected ? Colors.pinkAccent : Colors.grey,
                  width: 0.5,
                ),
              ),
              child: Center(
                child: FittedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CoinCount(coinCount: widget.point),
                      8.vGap,
                      Text(
                        "${widget.price} Kyat",
                        style: TextStyle(
                          fontSize: 18,
                          color: widget.isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      8.vGap,
                      Text(
                        kBuyNowLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isSelected ? Colors.white : Colors.pinkAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ///is popular container
          Visibility(
            visible: widget.isPopular ?? false,
            child: Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: kMarginMedium2),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(12)),
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(child: Text('MOST POPULAR',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 11),)),
                ),),),
            ),
          )
        ],
      ),
    );
  }
}
