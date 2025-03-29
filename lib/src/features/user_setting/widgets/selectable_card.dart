import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/fonts.dart';

class SelectableCard extends StatefulWidget {
  final String month;
  final String price;
  final String label;
  final bool? isPopular;
  final bool isSelected;
  final Function onTap;

  const SelectableCard({
    Key? key,
    required this.month,
    required this.price,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isPopular = false
  }) : super(key: key);

  @override
  _SelectableCardState createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                  horizontal: 8, vertical: widget.isSelected ? 0 : 8),
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: widget.isSelected ? 24 : 16),
              decoration: BoxDecoration(
                color: appBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected ? Colors.cyan : Colors.grey,
                  width: 0.5,
                ),
              ),
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      widget.month,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: kFontGibsonBold,
                        color: widget.isSelected ? primaryColor : blackColor,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                     widget.month != "1" ? 'MONTHS' : "MONTH",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: kFontGibsonBold,
                        color: widget.isSelected ? primaryColor : Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.price,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isSelected ? primaryColor : Colors.black,
                      ),
                    ),
                    if (widget.label.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                decoration: BoxDecoration(color: blackColor,border: Border.all(color: whiteColor),borderRadius: BorderRadius.circular(12)),
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
