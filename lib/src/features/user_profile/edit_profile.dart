import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/common/widgets/selectable_button.dart';
import 'package:phoosar/src/data/response/more_details_question_response.dart';
import 'package:phoosar/src/features/dashboard/widgets/unlock_coin_dialog.dart';
import 'package:phoosar/src/features/user_profile/add_interests_screen.dart';
import 'package:phoosar/src/features/user_profile/more_details_screen.dart';
import 'package:phoosar/src/features/user_profile/widgets/self_information.dart';
import 'package:phoosar/src/list_items/interest_list_item_view.dart';
import 'package:phoosar/src/list_items/more_deatils_list_item_view.dart';
import 'package:phoosar/src/providers/data_providers.dart';
import 'package:phoosar/src/utils/colors.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';

import '../../common/widgets/drop_down_widget.dart';
import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import 'more_details_writing_prompt_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  var isSmoke = "";

  var selectedDay = "";
  var selectedMonth = "";
  var selectedYear = "";
  List<String> days = List.generate(31, (i) => (i + 1).toString());
  int currentYear = DateTime.now().year;
  List<String> years = [];

  @override
  void initState() {
    super.initState();
    days.insert(0, 'Day');
    years = List.generate(61, (i) => (currentYear - i).toString());
    years.insert(0, 'Year');
  }

  @override
  Widget build(BuildContext context) {
    var profileData = ref.watch(profileDataProvider(context));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whitePaleColor,
          title: Text('Edit Profile'),
          centerTitle: true,
        ),
        backgroundColor: whitePaleColor,
        body: profileData.when(data: (data) {
          isSmoke = data?.smoke ?? "no";
          return ListView(
            children: [
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: data?.profileImages?[index] ?? "",
                                    errorWidget: (context, url, error) =>
                                       Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiQc9dZn33Wnk-j0sXZ19f8NiMZpJys7nTlA&s')
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CommonIconButton(
                                  onTap: () {},
                                  backgroundColor: blueColor,
                                  icon: Icon(
                                    Icons.delete,
                                    color: whiteColor,
                                    size: 18,
                                  ),
                                  padding: 4,
                                ),
                              )
                            ],
                          );
                  } else {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: index == 1 || index == 2
                            ? Icon(
                                Icons.add,
                                color: blackColor,
                                size: 24,
                              )
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => UnlockCoinDialog(
                                            coinCount: "10",
                                          ));
                                },
                                child: CoinCount(
                                  width: 54,
                                  coinCount: '10',
                                ),
                              ),
                      ),
                    );
                  }
                },
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 8.0, // spacing between rows
                  crossAxisSpacing: 8.0, // spacing between columns
                ),
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              SelfInformation(
                title: 'Name',
                description: data?.name ?? "",
                onChangeDescription: (value) async{
                  var request = {"name": value};
                  var response = await ref
                      .read(repositoryProvider)
                      .saveProfile(request, context);
                  if (response.statusCode
                      .toString()
                      .startsWith('2')) {
                    ref.invalidate(profileDataProvider);
                  }
                },
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Birthday',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              12.vGap,

              ///birthday
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///day button
                      Flexible(
                        child: DropDownWidget(
                            items: days,
                            onSelect: (value) async{
                              var selectedDayBirthDate =
                                  "$value, ${DateFormat("MMMM").format(DateTime.parse(data?.birthdate))}, ${DateTime.parse(data?.birthdate).year.toString()}";
                              var request = {"birthdate": DateFormat('yyyy-MM-dd').format(
                                  DateFormat('d, MMMM, yyyy')
                                      .parse(selectedDayBirthDate))};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            },
                            initValue:
                                DateTime.parse(data?.birthdate).day.toString()),
                      ),
                      10.hGap,

                      ///Month
                      Flexible(
                        child: DropDownWidget(
                            items: months,
                            onSelect: (value) async{
                              var selectedMonthBirthDate =
                                  "${DateTime.parse(data?.birthdate).day.toString()}, ${value}, ${DateTime.parse(data?.birthdate).year.toString()}";
                              var request = {"birthdate": DateFormat('yyyy-MM-dd').format(
                                  DateFormat('d, MMMM, yyyy')
                                      .parse(selectedMonthBirthDate))};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            },
                            initValue: DateFormat("MMMM")
                                .format(DateTime.parse(data?.birthdate))),
                      ),
                      10.hGap,

                      ///Year
                      Flexible(
                        child: DropDownWidget(
                            items: years,
                            onSelect: (value) async{
                              var selectedMonthBirthDate =
                                  "${DateTime.parse(data?.birthdate).day.toString()}, ${DateFormat("MMMM")
                                  .format(DateTime.parse(data?.birthdate))}, ${value}";
                              var request = {"birthdate": DateFormat('yyyy-MM-dd').format(
                                  DateFormat('d, MMMM, yyyy')
                                      .parse(selectedMonthBirthDate))};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            },
                            initValue: DateTime.parse(data?.birthdate)
                                .year
                                .toString()),
                      ),
                    ],
                  ),
                ),
              ),
              12.vGap,
              SelfInformation(
                title: 'About ${data?.name ?? ""}',
                description: data?.about ?? "",
                onChangeDescription: (value) async{
                  var request = {"about": value};
                  var response = await ref
                      .read(repositoryProvider)
                      .saveProfile(request, context);
                  if (response.statusCode
                      .toString()
                      .startsWith('2')) {
                    ref.invalidate(profileDataProvider);
                  }
                },
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              SelfInformation(
                title: 'Job Title',
                description: data?.jobTitle ?? "",
                onChangeDescription: (value) async{
                  var request = {"job_title": value};
                  var response = await ref
                      .read(repositoryProvider)
                      .saveProfile(request, context);
                  if (response.statusCode
                      .toString()
                      .startsWith('2')) {
                    ref.invalidate(profileDataProvider);
                  }
                },
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              SelfInformation(
                title: 'School',
                description: data?.school ?? "",
                onChangeDescription: (value) async{
                  var request = {"school": value};
                  var response = await ref
                      .read(repositoryProvider)
                      .saveProfile(request, context);
                  if (response.statusCode
                      .toString()
                      .startsWith('2')) {
                    ref.invalidate(profileDataProvider);
                  }
                },
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),
              12.vGap,
              SelfInformation(
                title: 'Living In',
                description: '${data?.city ?? ""}, ${data?.city ?? ""}',
              ),
              24.vGap,

              ///smoke view
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Smoke?',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              20.vGap,
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    SizedBox(
                        width: 100,
                        child: SelectableButton(
                            label: 'Yes',
                            bgColor:
                                isSmoke == "yes" ? primaryColor : Colors.grey,
                            isSelected: isSmoke == "yes" ? true : false,
                            onTapButton: (value) async {
                              var request = {"smoke": true};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            })),
                    20.hGap,
                    SizedBox(
                        width: 100,
                        child: SelectableButton(
                            label: 'No',
                            bgColor:
                                isSmoke == "no" ? primaryColor : Colors.grey,
                            isSelected: isSmoke == "no" ? true : false,
                            onTapButton: (value) async {
                              var request = {"smoke": false};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            })),
                  ],
                ),
              ),

              20.vGap,

              ///interests view
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Interests',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return InterestListItemView(
                    onTapDelete: (value) async {
                      var request = {"interest_name": value};
                      var response = await ref
                          .read(repositoryProvider)
                          .deleteInterest(request, context);
                      if (response.statusCode.toString().startsWith('2')) {
                        ref.invalidate(profileDataProvider);
                      }
                    },
                    isShowDeleteIcon: true,
                    value: data?.interests?[index],
                  );
                },
                itemCount: data?.interests?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // number of items in each row
                    mainAxisSpacing: 0.0, // spacing between rows
                    crossAxisSpacing: 100.0,
                    childAspectRatio: 2 / 1 // spacing between columns
                    ),
              ),

              ///add interest button
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Add Interests',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: kTextRegular2x,
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Spacer(),
                    CommonIconButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddInterestsScreen(),
                          ),
                        );
                      },
                      backgroundColor: greyColor,
                      icon: Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 18,
                      ),
                      padding: 4,
                    ),
                  ],
                ),
              ),

              20.vGap,

              ///more details
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'More details',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              20.vGap,

              ///more details list
              Container(
                color: Colors.white,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data?.moreDetails?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        var questionAnswerData = QuestionAnswerData(
                            id: data?.moreDetails?[index].id,
                            question: data?.moreDetails?[index].question,
                            answerText: data?.moreDetails?[index].answerText);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MoreDetailsWritingPromptScreen(
                                questionAnswerData: questionAnswerData,
                              ),
                            ));
                      },
                      child: MoreDetailsListItemView(
                        id: data?.moreDetails?[index].id.toString() ?? "",
                        title: data?.moreDetails?[index].question ?? "",
                        description: data?.moreDetails?[index].answerText ?? "",
                        onTapDelete: (id) async {
                          var request = {"question_id": id};
                          var response = await ref
                              .read(repositoryProvider)
                              .deleteMoreDetailsAnswer(request, context);
                          if (response.statusCode.toString().startsWith('2')) {
                            ref.invalidate(profileDataProvider);
                          }
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                ),
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),

              ///add more details button
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'Add More Details',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: kTextRegular2x,
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Spacer(),
                    CommonIconButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreDetailsScreen(),
                          ),
                        );
                      },
                      backgroundColor: greyColor,
                      icon: Icon(
                        Icons.add,
                        color: whiteColor,
                        size: 18,
                      ),
                      padding: 4,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),

              20.vGap,

              ///gender view
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Gender?',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              20.vGap,
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    SizedBox(
                        width: 100,
                        child: SelectableButton(
                            label: 'Male',
                            bgColor: primaryColor,
                            isSelected:
                                data?.gender.toString() == "1" ? true : false,
                            onTapButton: (value) async {
                              var request = {"gender": "1"};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            })),
                    20.hGap,
                    SizedBox(
                        width: 100,
                        child: SelectableButton(
                            label: 'Female',
                            bgColor: primaryColor,
                            isSelected:
                                data?.gender.toString() == "2" ? true : false,
                            onTapButton: (value) async {
                              var request = {"gender": "2"};
                              var response = await ref
                                  .read(repositoryProvider)
                                  .saveProfile(request, context);
                              if (response.statusCode
                                  .toString()
                                  .startsWith('2')) {
                                ref.invalidate(profileDataProvider);
                              }
                            })),
                  ],
                ),
              ),

              20.vGap,

              ///control profile view
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Control Your Profile',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: kTextRegular2x,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              ///dont show age view
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Dont Show My Age',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: kTextRegular2x,
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Spacer(),
                    CoinCount(coinCount: "10")
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: greyColor,
              ),

              ///distance invisible view
              Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Text(
                      'Make my distance invisible',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        fontSize: kTextRegular2x,
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Spacer(),
                    CoinCount(coinCount: "10")
                  ],
                ),
              ),
              50.vGap,
            ],
          );
        }, error: (error, stack) {
          return Container(
            child: Text(error.toString()),
          );
        }, loading: () {
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.pinkAccent,
            ),
          );
        }));
  }
}
