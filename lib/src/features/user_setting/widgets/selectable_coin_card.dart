import 'package:flutter/material.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

class SelectableCoinCard extends StatefulWidget {
  final String duration;
  final String price;
  final String label;
  final String point;
  final bool isSelected;
  final Function onTap;

  const SelectableCoinCard({
    Key? key,
    required this.duration,
    required this.price,
    required this.label,
    required this.point,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _SelectableCoinCardState createState() => _SelectableCoinCardState();
}

class _SelectableCoinCardState extends State<SelectableCoinCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.pinkAccent : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.isSelected ? Colors.pinkAccent : Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
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
    );
  }
}
