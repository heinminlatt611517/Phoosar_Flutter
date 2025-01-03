import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phoosar/src/common/widgets/common_button.dart';
import 'package:phoosar/src/common/widgets/language_dynamic_drop_down_widget.dart';
import 'package:phoosar/src/features/auth/upload_profile_image_screen.dart';
import 'package:phoosar/src/utils/constants.dart';
import 'package:phoosar/src/utils/dimens.dart';
import 'package:phoosar/src/utils/gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/data_providers.dart';

class AddSpeakLanguageScreen extends ConsumerStatefulWidget {
  const AddSpeakLanguageScreen({super.key});

  @override
  ConsumerState<AddSpeakLanguageScreen> createState() =>
      _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends ConsumerState<AddSpeakLanguageScreen> {
  final TextEditingController _languageController = TextEditingController();
  final List<String> _languages = [];
  var dropdownItems = [
    {'name': 'Burmese'},
    {'name': 'English'},
  ];

  void _addLanguage(String value) {
    final String language = value;
    if (language.isNotEmpty && !_languages.contains(language)) {
      setState(() {
        _languages.add(language);
      });
      //_languageController.clear();
    }
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ProfileSaveData:::${ref.read(profileSaveRequestProvider)}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/ic_launcher.png',
          height: 60,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(kMarginLarge),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.kISpeakLabel,
                  style:
                      TextStyle(color: Colors.grey, fontSize: kTextRegular24),
                ),

                50.vGap,

                ///language list
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two columns
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: (2 / .4),
                  ),
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(kMarginLarge)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(kMarginSmall),
                              child: Text(
                                _languages[index],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: InkWell(
                            onTap: () {
                              _removeLanguage(index);
                            },
                            child: Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.cyanAccent),
                              child: Center(
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ),
                          left: 2,
                          top: 4,
                        ),
                      ],
                    );
                  },
                ),

                20.vGap,

                ///Add language
                // TextFormField(
                //   controller: _languageController,
                //   decoration: InputDecoration(
                //     hintText: AppLocalizations.of(context)!.kAddLanguage,
                //     suffixIcon: UnconstrainedBox(
                //       child: InkWell(
                //           onTap: () {
                //             _addLanguage();
                //           },
                //           child: Container(
                //             height: 30,
                //             width: 30,
                //             decoration: BoxDecoration(
                //                 color: Colors.grey,
                //                 borderRadius: BorderRadius.circular(15)),
                //             child: Icon(
                //               Icons.add,
                //               color: Colors.white,
                //             ),
                //           )),
                //     ),
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                Container(
                  height: 60,
                  width: double.infinity,
                  child: LanguageDynamicDropDownWidget(
                    hintText: AppLocalizations.of(context)!.kAddLanguage,
                    items: dropdownItems,
                    selectedList: _languages,
                    onSelect: (value) {
                      _addLanguage(value['name']);
                    },
                  ),
                ),

                100.vGap,

                ///continue button
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: CommonButton(
                    containerVPadding: 10,
                    text: AppLocalizations.of(context)!.kContinueLabel,
                    fontSize: 18,
                    onTap: () {
                      if (_languages.isEmpty) {
                        context.showErrorSnackBar(
                            message:
                                AppLocalizations.of(context)!.kErrorMessage);
                      } else {
                        ref
                            .read(profileSaveRequestProvider.notifier)
                            .state
                            .speakLanguages = _languages;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UploadProfileImageScreen(),
                          ),
                        );
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
    );
  }
}
