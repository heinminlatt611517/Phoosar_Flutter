import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/data/dummy_data/premium_slider_data.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../utils/dimens.dart';

class PhoosarPremiumCarouselWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<PhoosarPremiumCarouselWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
      CarouselSlider(
        options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            viewportFraction: 1,
            height: 140),
        items: premiumSliderData.map((i) {
          return  Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible : i['id'] == "1",
                      child: Image.asset(
                        'assets/images/phoosar_premium_img.png',
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                      ),
                    ),
                    10.vGap,
                    Text(
                      i['title'] ?? "",
                      style: TextStyle(color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontSize: kTextRegular3x),
                    ),

                    10.vGap,
                    Visibility(
                      visible : i['id'] != "1",
                      child: Text(
                        textAlign: TextAlign.center,
                        i['description'] ?? "",
                        style: TextStyle(color: Colors.grey.withOpacity(0.7),fontSize: 17),
                      ),
                    ),
                  ],
                );
        }).toList(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: premiumSliderData
            .asMap()
            .entries
            .map((entry) {
          return GestureDetector(
            child: Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme
                      .of(context)
                      .brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      ),
    ]);
  }}