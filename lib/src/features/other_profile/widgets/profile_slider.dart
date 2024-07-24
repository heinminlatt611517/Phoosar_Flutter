import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OtherUserProfileSlider extends StatelessWidget {
  const OtherUserProfileSlider({
    super.key,
    required this.profileImages,
  });

  final List<String> profileImages;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          height: MediaQuery.of(context).size.height * 0.5),
      items: profileImages.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return CachedNetworkImage(
              imageUrl: i,
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
