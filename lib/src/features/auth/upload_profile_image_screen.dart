import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phoosar/src/common/widgets/select_photo_options_widget.dart';
import 'package:phoosar/src/features/auth/help_us_screen.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:phoosar/src/utils/strings.dart';

import '../../common/widgets/common_button.dart';
import '../../providers/app_provider.dart';
import '../../providers/data_providers.dart';
import '../../utils/dimens.dart';

class UploadProfileImageScreen extends ConsumerStatefulWidget {
  const UploadProfileImageScreen({super.key});

  @override
  ConsumerState<UploadProfileImageScreen> createState() =>
      _UploadProfileImageScreenState();
}

class _UploadProfileImageScreenState
    extends ConsumerState<UploadProfileImageScreen> {
  var base64ImageString = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
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
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              'assets/images/phoosar_img.png',
              height: 40,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(kMarginLarge),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.kUploadYourProfileImage,
                      style:
                          TextStyle(color: Colors.grey, fontSize: kTextRegular24),
                    ),

                    20.vGap,

                    ///choose image view
                    ChooseImageView(
                      base64ImageString: (value) {
                        setState(() {
                          base64ImageString = value;
                        });
                      },
                    ),

                    60.vGap,

                    ///continue button
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CommonButton(
                        containerVPadding: 10,
                        isLoading: _isLoading,
                        text: AppLocalizations.of(context)!.kContinueLabel,
                        fontSize: 18,
                        onTap: () async {
                          ref.read(profileSaveRequestProvider).profileImages = [
                            base64ImageString
                          ];
                          if (base64ImageString == "") {
                            context.showErrorSnackBar(
                                message:
                                    AppLocalizations.of(context)!.kErrorMessage);
                          } else {
                            var request = ref.read(profileSaveRequestProvider);
                            debugPrint(
                                "UserBirthday:::${ref.read(profileSaveRequestProvider.notifier).state.profileImages?.length}");
                            setState(() {
                              _isLoading = true;
                            });
                            var response = await ref
                                .read(repositoryProvider)
                                .saveProfile(request, context);
                            if (response.statusCode.toString().startsWith('2')) {
                              ref
                                  .watch(sharedPrefProvider)
                                  .setString(kRecentOnboardingKey, kQuestionStatus);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HelpUsScreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        bgColor: Colors.pinkAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///choose image container view
class ChooseImageView extends ConsumerStatefulWidget {
  Function(String) base64ImageString;
  ChooseImageView({super.key, required this.base64ImageString});

  @override
  ConsumerState<ChooseImageView> createState() => _ChooseImageViewState();
}

class _ChooseImageViewState extends ConsumerState<ChooseImageView> {
  File? _image;

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

    return Column(
      children: [
        ///user image view
        Stack(
          children: [
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(color: Colors.transparent,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _image != null
                  ? ClipRRect(
                   borderRadius: BorderRadius.circular(120),
                    child: Image.file(
                        _image ?? File(""),
                        height: 240,
                        width: 240,
                        fit: BoxFit.cover,
                      ),
                  )
                  // : Image.asset(
                  //     ref.read(profileSaveRequestProvider.notifier)
                  //         .state
                  //         .gender == "2" ? 'assets/images/female.png' :
                  //     'assets/images/upload_profile_img.png',
                  //     height: 240,
                  //     width: 240,
                  //   ),
              : Container(height: 240,
                width: 240,decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle),
              child: Center(child: Icon(Icons.camera_alt_outlined,color: Colors.grey,
              size: 70,),),)
            )
          ],
        ),

        26.vGap,

        ///choose image button
        CommonButton(
          containerVPadding: 10,
          text: AppLocalizations.of(context)!.kChooseImageLabel,
          fontSize: 18,
          onTap: () {
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
                            setState(() {
                              _image = img;
                              widget.base64ImageString(base64Encode(
                                  File(image.path).readAsBytesSync()));
                            });
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    );
                  }),
            );
          },
          bgColor: Colors.grey.withOpacity(0.5),
        ),
      ],
    );
  }
}
