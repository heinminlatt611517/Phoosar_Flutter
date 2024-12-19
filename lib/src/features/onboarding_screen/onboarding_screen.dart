import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../common/widgets/selectable_button.dart';
import '../../data/request/question_save_request.dart';
import '../../data/response/questions_response.dart';
import '../../providers/app_provider.dart';
import '../../utils/dimens.dart';
import '../home/home.dart';
import 'all_set_screen.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<Color> indicatorColors = [];
  Map<int, Questions> selectedQuestionsMap = {};
  Map<int, bool> pageSelectionStatus = {}; // Track selection status per page
  var isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var questionList = ref.watch(questionListProvider(context));
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/bg_image_4.jpg',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Image.asset(
                'assets/images/phoosar_img.png',
                height: 40,
              ),
            ),
            body: questionList.when(
              data: (data) {
                if (indicatorColors.length != data.length) {
                  indicatorColors = List.generate(
                    data.length,
                    (_) => Colors.grey.withOpacity(0.4),
                  );
                  indicatorColors.first = Colors.blue;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Body view
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        child: Center(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                                updateIndicatorColors();
                              });
                            },
                            children: data
                                .asMap()
                                .map((index, questions) => MapEntry(
                                      index,
                                      QuestionWidgetView(
                                        questionData: (questionsData) {
                                          setState(() {
                                            selectedQuestionsMap[index] =
                                                questionsData;
                                          });
                                        },
                                        data: questions,
                                        selectedQuestion:
                                            selectedQuestionsMap[index],
                                        onSelectionChanged: (hasSelection) {
                                          setState(() {
                                            pageSelectionStatus[index] =
                                                hasSelection;
                                          });
                                        },
                                      ),
                                    ))
                                .values
                                .toList(),
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

                    // Continue button
                    _buildContinueButton(_currentPage, data.length),

                    SizedBox(height: 30),

                    /// Build horizontal indicator
                    buildPageIndicator(data),

                    SizedBox(height: 10),

                    ///skip for now button
                    Visibility(
                      visible: ref
                                  .watch(sharedPrefProvider)
                                  .getString(kSkipQuestion) ==
                              "0"
                          ? false
                          : true,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Skip For now',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                decoration: TextDecoration.underline),
                          )),
                    ),

                    SizedBox(height: 10),
                  ],
                );
              },
              error: (error, stack) => Container(),
              loading: () => Center(
                child: SpinKitThreeBounce(
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build page indicator
  Widget buildPageIndicator(List<QuestionData> questionList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        questionList.length,
        (index) => buildIndicator(index),
      ),
    );
  }

  /// Build indicator
  Widget buildIndicator(int index) {
    return Container(
      width: 22,
      height: 4,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: indicatorColors[index],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Update the indicator colors based on the current page
  void updateIndicatorColors() {
    setState(() {
      indicatorColors = List.generate(
        indicatorColors.length,
        (index) =>
            index <= _currentPage ? primaryColor : Colors.grey.withOpacity(0.4),
      );
    });
  }

  /// Continue button
  Widget _buildContinueButton(int index, int pageLength) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: CommonButton(
        containerVPadding: 10,
        text: AppLocalizations.of(context)!.kContinueLabel,
        isLoading: isLoading,
        fontSize: 18,
        onTap: () async {
          FocusScope.of(context).unfocus();
          ref.read(questionSaveRequestProvider).questions =
              selectedQuestionsMap.values.toList();
          if (pageSelectionStatus[_currentPage] ?? false) {
            if (index == pageLength - 1) {
              setState(() {
                isLoading = true;
              });
              var request = ref.read(questionSaveRequestProvider);
              var response = await ref
                  .read(repositoryProvider)
                  .saveUserQA(request, context);
              if (response.statusCode.toString().startsWith('2')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AllSetScreen()),
                );
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            } else {
              setState(() {
                isLoading = true;
              });
              var request = ref.read(questionSaveRequestProvider);
              var response = await ref
                  .read(repositoryProvider)
                  .saveUserQA(request, context);
              if (response.statusCode.toString().startsWith('2')) {
                setState(() {
                  isLoading = false;
                });
                _pageController.animateToPage(
                  index + 1,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                );
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(index == 0
                      ? 'Please enter description before continuing'
                      : 'Please make a selection before continuing.')),
            );
          }
        },
        bgColor: primaryColor,
      ),
    );
  }
}




class QuestionWidgetView extends StatefulWidget {
  final QuestionData data;
  final Function(Questions) questionData;
  final Questions? selectedQuestion;
  final Function(bool) onSelectionChanged; // Callback for selection

  const QuestionWidgetView({
    super.key,
    required this.data,
    required this.questionData,
    this.selectedQuestion,
    required this.onSelectionChanged, // Initialize this callback
  });

  @override
  State<QuestionWidgetView> createState() => _QuestionWidgetViewState();
}

class _QuestionWidgetViewState extends State<QuestionWidgetView> {
  late String selectedText;
  TextEditingController shortDescriptionTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedText = widget.selectedQuestion?.answerText ?? "";
    shortDescriptionTextController.text =
        widget.selectedQuestion?.answerText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    bool hasSelection = widget.data.answerType.toString() == "1"
        ? shortDescriptionTextController.text.isNotEmpty
        : selectedText.isNotEmpty;

    // Avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged(hasSelection);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.data.question ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 30),
                widget.data.answerType.toString() == "1"
                    ? Column(
                        children: [
                          TextFormField(
                            maxLines: 10,
                            controller: shortDescriptionTextController,
                            onChanged: (value) {
                              var craftQuestionVo = Questions(
                                id: widget.data.id,
                                answerId: "",
                                answerText: value,
                              );
                              widget.questionData(craftQuestionVo);
                              // Notify parent about selection change
                              widget.onSelectionChanged(value.isNotEmpty);
                            },
                            decoration: InputDecoration(
                              hintMaxLines: 2,
                              hintStyle: TextStyle(
                                fontSize: kTextRegular,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                              hintText: AppLocalizations.of(context)!
                                  .kHowWouldYourFamilyOrBestFriendDescribeYou,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .kTipKeepItShortAndSweetLabel,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ))
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SelectableButton(
                              label: widget.data.answers?[index].answer ?? "",
                              isSelected: selectedText ==
                                  widget.data.answers?[index].answer,
                              onTapButton: (value) {
                                var craftQuestionVo = Questions(
                                  id: widget.data.id,
                                  answerId:
                                      widget.data.answers?[index].id.toString(),
                                  answerText: widget.data.answers?[index].answer
                                      .toString(),
                                );
                                widget.questionData(craftQuestionVo);
                                setState(() {
                                  selectedText = value;
                                });
                                // Notify parent about selection change
                                widget.onSelectionChanged(value.isNotEmpty);
                              },
                            ),
                          );
                        },
                        itemCount: widget.data.answers?.length ?? 0,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
