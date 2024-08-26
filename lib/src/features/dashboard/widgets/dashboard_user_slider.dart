import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:phoosar/src/utils/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class DashboardProfileSlider extends StatefulWidget {
  const DashboardProfileSlider({
    super.key,
    required this.profileImages,
    required this.score
  });
  final List<String> profileImages;
  final int score;

  @override
  State<DashboardProfileSlider> createState() => _DashboardProfileSliderState();
}

class _DashboardProfileSliderState extends State<DashboardProfileSlider> {
  int _currentIndex = 0;
  int stepSize = 10;
  int totalScore = 100;
  int maxScore = 100;
  int desiredSteps = 10;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double arcFraction = widget.score / totalScore;
    double startingAngle = -math.pi * 2 / 3;
    double arcSize = 2 * math.pi * arcFraction;
    double stepSize = maxScore / desiredSteps;
    int maxSteps = (widget.score / stepSize).ceil();
    maxSteps = maxSteps > desiredSteps ? desiredSteps : maxSteps;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            carousel_slider.CarouselSlider(
              options: carousel_slider.CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.62),
              items: widget.profileImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: i,
                            width: MediaQuery.of(context).size.width - 32,
                            height: MediaQuery.of(context).size.height * 0.62,
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
                          Positioned(
                            left: 20,
                            top: 20,
                            child: Stack(
                              children: [
                                CircularStepProgressIndicator(
                                totalSteps: maxSteps,
                                currentStep: maxSteps,
                                stepSize: stepSize.toDouble(),
                                selectedColor: Colors.red,
                                unselectedColor: Colors.purple[400],
                                padding: math.pi / 100,
                                width: 60,
                                height: 60,
                                  startingAngle: startingAngle,
                                  arcSize: arcSize,
                                gradientColor: LinearGradient(
                                  colors: [Colors.pinkAccent, Colors.pinkAccent.withOpacity(0.3)],
                                ),
                                                            ),
                                Positioned(
                                  top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Center(child: Text("${widget.score.toString()} %",style: TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold),)))
                              ],
                            ),)
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
                dotsCount: widget.profileImages.length < 1
                    ? 1
                    : widget.profileImages.length,
                position:
                    _currentIndex, // Ensure currentIndex is tracked in state
                decorator: DotsDecorator(
                  activeColor: blackColor,
                  colors:
                      List.filled(widget.profileImages.length, Colors.white),
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
