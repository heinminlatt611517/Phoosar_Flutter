import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/constants.dart';

class DashboardProfileSlider extends StatefulWidget {
  const DashboardProfileSlider({
    super.key,
  });

  @override
  State<DashboardProfileSlider> createState() => _DashboardProfileSliderState();
}

class _DashboardProfileSliderState extends State<DashboardProfileSlider> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.6),
              items: sampleProfileImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.asset(
                            i,
                            width: MediaQuery.of(context).size.width - 32,
                            height: MediaQuery.of(context).size.height * 0.6,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              top: 12,
              right: 6,
              child: DotsIndicator(
                dotsCount: sampleProfileImages.length,
                position:
                    _currentIndex, // Ensure currentIndex is tracked in state
                decorator: DotsDecorator(
                  activeColor: blackColor,
                  colors: List.filled(sampleProfileImages.length, Colors.white),
                  size: const Size.square(7),
                  activeSize: const Size(8, 8),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.white, width: 2)),
                  spacing: const EdgeInsets.all(4.0),
                ),
                axis: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
