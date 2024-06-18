import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/constants.dart';

class OtherUserProfileSlider extends StatelessWidget {
  const OtherUserProfileSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          height: MediaQuery.of(context).size.height * 0.5),
      items: sampleProfileImages.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              i,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              fit: BoxFit.cover,
            );
          },
        );
      }).toList(),
    );
  }
}
