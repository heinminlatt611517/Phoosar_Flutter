import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phoosar/src/common/widgets/coin_count.dart';
import 'package:phoosar/src/common/widgets/icon_button.dart';
import 'package:phoosar/src/common/widgets/selectable_button.dart';
import 'package:phoosar/src/data/response/more_details_question_response.dart';
import 'package:phoosar/src/data/response/profile.dart';
import 'package:phoosar/src/data/response/self_profile_response.dart';
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
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../common/widgets/common_dialog.dart';
import '../../common/widgets/drop_down_widget.dart';
import '../../common/widgets/select_photo_options_widget.dart';
import '../../providers/app_provider.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../dashboard/widgets/unlock_success_dailog.dart';
import 'more_details_writing_prompt_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeAbout = FocusNode();
  final FocusNode _focusNodeJobTitle = FocusNode();
  final FocusNode _focusNodeSchool = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController livingInController = TextEditingController();
  String _nameText = '';
  String _aboutText = '';
  String _jobTitleText = '';
  String _schoolText = '';

  @override
  void initState() {
    super.initState();
    days.insert(0, 'Day');
    years = List.generate(61, (i) => (currentYear - i).toString());
    years.insert(0, 'Year');

    _focusNodeName.addListener(() {
      if (!_focusNodeName.hasFocus) {
        _onFieldNameFocusLost();
      }
    });

    _focusNodeAbout.addListener(() {
      if (!_focusNodeAbout.hasFocus) {
        _onFieldAboutFocusLost();
      }
    });

    _focusNodeJobTitle.addListener(() {
      if (!_focusNodeAbout.hasFocus) {
        _onFieldJobTitleFocusLost();
      }
    });

    _focusNodeSchool.addListener(() {
      if (!_focusNodeSchool.hasFocus) {
        _onFieldSchoolFocusLost();
      }
    });
  }

  void _onFieldNameFocusLost() {
    if (nameController.text != _nameText) {
      var request = {"name": nameController.text};
       callSaveProfile(request, context);
      _nameText = nameController.text;
    }
  }

  void _onFieldAboutFocusLost() {
    if (aboutController.text != _aboutText) {
      var request = {"about": aboutController.text};
      callSaveProfile(request, context);
      _aboutText = aboutController.text;
    }
  }
  void _onFieldJobTitleFocusLost() {
    if (jobTitleController.text != _jobTitleText) {
      var request = {"job_title": jobTitleController.text};
      callSaveProfile(request, context);
      _jobTitleText = jobTitleController.text;
    }
  }
  void _onFieldSchoolFocusLost() {
    if (schoolController.text != _schoolText) {
      var request = {"school": schoolController.text};
      callSaveProfile(request, context);
      _schoolText = schoolController.text;
    }
  }

  ///cropImage
  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    var profileData = ref.watch(profileDataProvider(context));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whitePaleColor,
          title: Text(
            AppLocalizations.of(context)!.kEditProfileLowerCase,
          ),
          centerTitle: true,
        ),
        backgroundColor: whitePaleColor,
        body: profileData.when(data: (data) {
          isSmoke = data?.smoke ?? "no";
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    if (data?.uploadPhotoData?[index].canUpload == true) {
                      return data?.uploadPhotoData?[index].url.toString() == ""
                          ? InkWell(
                              onTap: () {
                                showChooseImageBottomSheet(context, data, index);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: greyColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                    child: Icon(
                                  Icons.add,
                                  color: blackColor,
                                  size: 24,
                                )),
                              ),
                            )
                          : Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageUrl: data
                                                ?.uploadPhotoData?[index].url
                                                .toString() ??
                                            "",
                                        errorWidget: (context, url, error) =>
                                            Image.network(errorImageUrl)),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CommonIconButton(
                                    onTap: () async {
                                      var request = {
                                        "image_id": data
                                            ?.uploadPhotoData?[index].id
                                            .toString()
                                      };
                                      var response = await ref
                                          .read(repositoryProvider)
                                          .deleteUploadPhoto(request, context);
                                      if (response.statusCode
                                          .toString()
                                          .startsWith('2')) {
                                        ref.invalidate(profileDataProvider);
                                      }
                                    },
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
                          child: InkWell(
                            onTap: () async{
                              _handleAction(context);
                            },
                            child: CoinCount(
                              width: 80,
                              coinCount: '10',
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  itemCount: data?.uploadPhotoData?.length,
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
                  descriptionController : nameController,
                  title: AppLocalizations.of(context)!.kNameLabel,
                  description: data?.name ?? "",
                  focusNode: _focusNodeName,
                  onChangeDescription: (value) async {
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
                    AppLocalizations.of(context)!.kBirthdayLabel,
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
                              onSelect: (value) async {
                                var selectedDayBirthDate =
                                    "$value, ${DateFormat("MMMM").format(DateTime.parse(data?.birthdate))}, ${DateTime.parse(data?.birthdate).year.toString()}";
                                var request = {
                                  "birthdate": DateFormat('yyyy-MM-dd').format(
                                      DateFormat('d, MMMM, yyyy')
                                          .parse(selectedDayBirthDate))
                                };
                                await callSaveProfile(request, context);
                              },
                              initValue:
                                  DateTime.parse(data?.birthdate).day.toString()),
                        ),
                        10.hGap,

                        ///Month
                        Flexible(
                          child: DropDownWidget(
                              items: months,
                              onSelect: (value) async {
                                var selectedMonthBirthDate =
                                    "${DateTime.parse(data?.birthdate).day.toString()}, ${value}, ${DateTime.parse(data?.birthdate).year.toString()}";
                                var request = {
                                  "birthdate": DateFormat('yyyy-MM-dd').format(
                                      DateFormat('d, MMMM, yyyy')
                                          .parse(selectedMonthBirthDate))
                                };
                                await callSaveProfile(request, context);
                              },
                              initValue: DateFormat("MMMM")
                                  .format(DateTime.parse(data?.birthdate))),
                        ),
                        10.hGap,

                        ///Year
                        Flexible(
                          child: DropDownWidget(
                              items: years,
                              onSelect: (value) async {
                                var selectedMonthBirthDate =
                                    "${DateTime.parse(data?.birthdate).day.toString()}, ${DateFormat("MMMM").format(DateTime.parse(data?.birthdate))}, ${value}";
                                var request = {
                                  "birthdate": DateFormat('yyyy-MM-dd').format(
                                      DateFormat('d, MMMM, yyyy')
                                          .parse(selectedMonthBirthDate))
                                };
                                await callSaveProfile(request, context);
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
                  focusNode: _focusNodeAbout,
                  descriptionController : aboutController,
                  title:
                      '${AppLocalizations.of(context)!.kAboutLabel}',
                  description: data?.about ?? "",
                  onChangeDescription: (value) async {
                  },
                ),
                Divider(
                  height: 1,
                  color: greyColor,
                ),
                12.vGap,
                SelfInformation(
                  descriptionController: jobTitleController,
                  focusNode: _focusNodeJobTitle,
                  title: AppLocalizations.of(context)!.kJobTitleLabel,
                  description: data?.jobTitle ?? "",
                  onChangeDescription: (value) async {
                  },
                ),
                Divider(
                  height: 1,
                  color: greyColor,
                ),
                12.vGap,
                SelfInformation(
                  descriptionController: schoolController,
                  focusNode: _focusNodeSchool,
                  title: AppLocalizations.of(context)!.kSchoolLabel,
                  description: data?.school ?? "",
                  onChangeDescription: (value) async {
                  },
                ),
                Divider(
                  height: 1,
                  color: greyColor,
                ),
                12.vGap,
                SelfInformation(
                  descriptionController: livingInController,
                  title: AppLocalizations.of(context)!.kLivingInLabel,
                  description: '${data?.city ?? ""}, ${data?.city ?? ""}',
                ),
                24.vGap,

                ///smoke view
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.kSmokeLabel,
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
                    AppLocalizations.of(context)!.kInterestLabel,
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
                  physics: NeverScrollableScrollPhysics(),
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
                        AppLocalizations.of(context)!.kAddInterestLabel,
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
                    AppLocalizations.of(context)!.kMoreDetailsLabel,
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
                        AppLocalizations.of(context)!.kAddMoreDetailsLabel,
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
                    AppLocalizations.of(context)!.kGenderLabel,
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
                              label: AppLocalizations.of(context)!.kMaleLabel,
                              bgColor: primaryColor,
                              isSelected:
                                  data?.gender.toString() == "1" ? true : false,
                              onTapButton: (value) async {
                                var request = {"gender": "1"};
                                await callSaveProfile(request, context);
                              })),
                      20.hGap,
                      SizedBox(
                          width: 100,
                          child: SelectableButton(
                              label: AppLocalizations.of(context)!.kFemaleLabel,
                              bgColor: primaryColor,
                              isSelected:
                                  data?.gender.toString() == "2" ? true : false,
                              onTapButton: (value) async {
                                var request = {"gender": "2"};
                                await callSaveProfile(request, context);
                              })),
                    ],
                  ),
                ),

                20.vGap,

                ///control profile view
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.of(context)!.kControlYourProfileLabel,
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
                        AppLocalizations.of(context)!.kDontShowMyAgeLabel,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontSize: kTextRegular2x,
                          color: blackColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Spacer(),
                      Visibility(
                        visible: !data!.showAge!.showAgeStatus!,
                        child: InkWell(
                          onTap: () async{
                            var response = await ref.watch(repositoryProvider).buySettingWithPoint(
                                jsonEncode({"setting_type" : "profile_show_age",}), context);

                            if (response.statusCode.toString().startsWith("2")) {
                              showDialog(
                                  context: context,
                                  builder: (context) => UnlockSuccessDailog());
                              ref.invalidate(profileDataProvider);
                              await updateSeftProfileData();
                            }
                          },
                            child: CoinCount(coinCount: data.showAge?.pointProfileShowAge.toString() ?? "",)),
                      ),
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
                        AppLocalizations.of(context)!.kMakeDistanceInvisibleLabel,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontSize: kTextRegular2x,
                          color: blackColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Spacer(),
                      Visibility(
                        visible: !data.distanceInvisible!.distanceInvisibleStatus!,
                        child: InkWell(
                          onTap: () async{
                            var response = await ref.watch(repositoryProvider).buySettingWithPoint(
                                jsonEncode({"setting_type" : "profile_distance_invisible",}), context);

                            if (response.statusCode.toString().startsWith("2")) {
                              showDialog(
                                  context: context,
                                  builder: (context) => UnlockSuccessDailog());
                              ref.invalidate(profileDataProvider);
                              await updateSeftProfileData();
                            }
                          },
                            child: CoinCount(coinCount: data.distanceInvisible?.pointDistanceInvisible.toString() ?? "",)),
                      )
                    ],
                  ),
                ),
                50.vGap,
              ],
            ),
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

  Future<void> callSaveProfile(Map<String, String> request, BuildContext context) async {
    debugPrint("CallSaveProfileApi>>>>>>>>>>>>");
    var response = await ref
        .read(repositoryProvider)
        .saveProfile(request, context);
    if (response.statusCode.toString().startsWith('2')) {
      ref.invalidate(profileDataProvider);
    }
  }

  void showChooseImageBottomSheet(
      BuildContext context, ProfileData? data, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsWidget(
                onTap: (source) async {
                  Navigator.of(context).pop();
                  try {
                    final image = await ImagePicker(
                            // imageQuality: 25,
                            )
                        .pickImage(
                      source: source,
                    );
                    if (image == null) return;
                    File? img = File(image.path);
                    img = await _cropImage(imageFile: img);
                    var base64ImageString =
                        base64Encode(File(image.path).readAsBytesSync());
                    var request = {
                      "image_id": data?.uploadPhotoData?[index].id.toString(),
                      "image_data": base64ImageString
                    };
                    var response = await ref
                        .read(repositoryProvider)
                        .uploadPhoto(request, context);
                    if (response.statusCode.toString().startsWith('2')) {
                      ref.invalidate(profileDataProvider);
                      final profileRes = await ref
                          .watch(repositoryProvider)
                          .getProfile(jsonEncode({}), context);
                      var data = SelfProfileResponse.fromJson(
                          jsonDecode(profileRes.body));
                      ref.read(selfProfileProvider.notifier).state = data;
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
              ),
            );
          }),
    );
  }


  void _handleAction(BuildContext context) {
    _showDialog(context);
  }

  void _showDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return  CommonDialog(
          title: AppLocalizations.of(context)!.kUnlockFeatureLabel,
          width: 400,
          isExpand: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.vGap,
                Center(
                  child: Container(
                    width: 80,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/coin.png',
                          height: 16,
                          fit: BoxFit.cover,
                        ),
                        4.hGap,
                        Text(
                          '10',
                          style: GoogleFonts.roboto(
                            fontSize: normalFontSize,
                            color: whiteColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.vGap,
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.kUnlockLabel.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: mediumFontSize,
                      color: blueColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      _callApi();
    }
  }

  void _callApi() async {
    try {
      var response = await ref.watch(repositoryProvider).buySettingWithPoint(
          jsonEncode({"setting_type" : "profile_image",}), context);

      if (response.statusCode.toString().startsWith("2")) {
        showDialog(
            context: context,
            builder: (context) => UnlockSuccessDailog());
        ref.invalidate(profileDataProvider);

        await updateSeftProfileData();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateSeftProfileData() async {
     final repository = ref.watch(repositoryProvider);
    final response = await repository.getProfile(jsonEncode({}), context);
    var data = SelfProfileResponse.fromJson(jsonDecode(response.body));
    ref.read(selfProfileProvider.notifier).state = data;
  }
}
