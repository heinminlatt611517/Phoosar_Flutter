import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/features/onboarding_screen/fill_short_description_screen.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/common_button.dart';
import '../../utils/strings.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;
  List<Color> indicatorColors = [
    Colors.grey,
    Colors.grey.withOpacity(0.4),
    Colors.grey.withOpacity(0.4),
  ];

  List<Color> indicatorTextColors = [
    Colors.grey,
    Colors.black,
    Colors.black,
  ];

  ///scroll controller
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/ic_launcher.png',
            height: 60,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            50.vGap,

            ///build horizontal indicator
            buildPageIndicator(),

            ///body view
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: Center(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        updateIndicatorColors();
                      });
                    },
                    children: [
                      FillShortDescriptionScreen(),
                      FillShortDescriptionScreen(),
                      FillShortDescriptionScreen()
                    ],
                  ),
                ),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ),

            ///continue button
            _buildContinueButton(_currentPage),

            60.vGap
          ],
        ),
      ),
    );
  }

  ///continue button
  Widget _buildContinueButton(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: CommonButton(
        containerVPadding: 10,
        text: kContinueLabel,
        fontSize: 18,
        onTap: () {
          setState(() {
            _pageController.animateToPage(
              index + 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
            );
          });
        },
        bgColor: Colors.pinkAccent,
      ),
    );
  }

  ///build page indicator
  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        indicatorColors.length,
        (index) => buildIndicator(
          index,
        ),
      ),
    );
  }

  ///build indicator
  Widget buildIndicator(int index) {
    return Container(
      width: 22,
      height: 4,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: indicatorColors[index],
      ),
    );
  }

  /// Update the indicator colors based on the current page
  void updateIndicatorColors() {
    setState(() {
      indicatorColors = List.generate(
        indicatorColors.length,
        (index) => index <= _currentPage
            ? Colors.blue
            : Colors.grey.withOpacity(0.4), // Change color condition here
      );

      indicatorTextColors = List.generate(
        indicatorTextColors.length,
        (index) => index <= _currentPage
            ? Colors.white
            : Colors.black, // Change color condition here
      );
    });
  }
}
