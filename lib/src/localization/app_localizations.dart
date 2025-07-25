import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'phoosar'**
  String get appTitle;

  /// No description provided for @kSignInLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get kSignInLabel;

  /// No description provided for @kSignUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get kSignUpLabel;

  /// No description provided for @kEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get kEmailLabel;

  /// No description provided for @kUserNameLabel.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get kUserNameLabel;

  /// No description provided for @kPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get kPasswordLabel;

  /// No description provided for @kConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get kConfirmPasswordLabel;

  /// No description provided for @kForgotPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get kForgotPasswordLabel;

  /// No description provided for @kDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get kDontHaveAccount;

  /// No description provided for @kAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get kAlreadyHaveAccount;

  /// No description provided for @kContinueLabel.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get kContinueLabel;

  /// No description provided for @kIamLabel.
  ///
  /// In en, this message translates to:
  /// **'I am'**
  String get kIamLabel;

  /// No description provided for @kCurrentLocateIn.
  ///
  /// In en, this message translates to:
  /// **'I\'m currently located in'**
  String get kCurrentLocateIn;

  /// No description provided for @kWantMyMatch.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get kWantMyMatch;

  /// No description provided for @kUploadYourProfileImage.
  ///
  /// In en, this message translates to:
  /// **'Upload your profile image'**
  String get kUploadYourProfileImage;

  /// No description provided for @kChooseImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get kChooseImageLabel;

  /// No description provided for @kHelpUsGetToKnowLabel.
  ///
  /// In en, this message translates to:
  /// **'Help us get to know you better!'**
  String get kHelpUsGetToKnowLabel;

  /// No description provided for @kAnswerFollowingQuestionToFindPerfectMatch.
  ///
  /// In en, this message translates to:
  /// **'Answer the following questions to find the perfect match.'**
  String get kAnswerFollowingQuestionToFindPerfectMatch;

  /// No description provided for @kWhatAreYouLookingForInARelationship.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for in a relationship?'**
  String get kWhatAreYouLookingForInARelationship;

  /// No description provided for @kShortDescriptionAboutYou.
  ///
  /// In en, this message translates to:
  /// **'Short Description About You'**
  String get kShortDescriptionAboutYou;

  /// No description provided for @kHowWouldYourFamilyOrBestFriendDescribeYou.
  ///
  /// In en, this message translates to:
  /// **'How would your family or your best friend describe you?'**
  String get kHowWouldYourFamilyOrBestFriendDescribeYou;

  /// No description provided for @kCasualDatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Casual Dating'**
  String get kCasualDatingLabel;

  /// No description provided for @kMarriageLabel.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get kMarriageLabel;

  /// No description provided for @kDoYouBelieveHoroscopes.
  ///
  /// In en, this message translates to:
  /// **'Do you believe in horoscopes?'**
  String get kDoYouBelieveHoroscopes;

  /// No description provided for @kYesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get kYesLabel;

  /// No description provided for @kNoLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get kNoLabel;

  /// No description provided for @kDoYouSmokeLabel.
  ///
  /// In en, this message translates to:
  /// **'Do you smoke?'**
  String get kDoYouSmokeLabel;

  /// No description provided for @kDoYouDrinkAlcoholLabel.
  ///
  /// In en, this message translates to:
  /// **'Do you drink alcohol?'**
  String get kDoYouDrinkAlcoholLabel;

  /// No description provided for @kDoYouCareBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Do you care about birthdates?'**
  String get kDoYouCareBirthdate;

  /// No description provided for @kDoYouCarePartnerReligion.
  ///
  /// In en, this message translates to:
  /// **'Do you care about your\npartner\'s religion?'**
  String get kDoYouCarePartnerReligion;

  /// No description provided for @kWhereWouldYouLikeToMeet.
  ///
  /// In en, this message translates to:
  /// **'Where would you like to meet\nyour potential match?'**
  String get kWhereWouldYouLikeToMeet;

  /// No description provided for @kAtAParkLabel.
  ///
  /// In en, this message translates to:
  /// **'At a park'**
  String get kAtAParkLabel;

  /// No description provided for @kAtACoffeeShop.
  ///
  /// In en, this message translates to:
  /// **'At a coffee shop'**
  String get kAtACoffeeShop;

  /// No description provided for @kWhatTypeOfPersonAreYou.
  ///
  /// In en, this message translates to:
  /// **'What type of person are you?'**
  String get kWhatTypeOfPersonAreYou;

  /// No description provided for @kClamAndCollected.
  ///
  /// In en, this message translates to:
  /// **'Clam and Collected'**
  String get kClamAndCollected;

  /// No description provided for @kChillAndLaidBack.
  ///
  /// In en, this message translates to:
  /// **'Chill and Laidback'**
  String get kChillAndLaidBack;

  /// No description provided for @kFunAndUnSerious.
  ///
  /// In en, this message translates to:
  /// **'Fun and Unserious'**
  String get kFunAndUnSerious;

  /// No description provided for @kYourAreAllSetLabel.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get kYourAreAllSetLabel;

  /// No description provided for @kFindYourMatch.
  ///
  /// In en, this message translates to:
  /// **'Now let\'s find your match.'**
  String get kFindYourMatch;

  /// No description provided for @kLetGoLabel.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get kLetGoLabel;

  /// No description provided for @kPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get kPhoneNumberLabel;

  /// No description provided for @kConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get kConfirmLabel;

  /// No description provided for @kResendOTPLabel.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get kResendOTPLabel;

  /// No description provided for @kBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get kBirthdayLabel;

  /// No description provided for @kDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get kDayLabel;

  /// No description provided for @kMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get kMonthLabel;

  /// No description provided for @kYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get kYearLabel;

  /// No description provided for @kISpeakLabel.
  ///
  /// In en, this message translates to:
  /// **'I speak'**
  String get kISpeakLabel;

  /// No description provided for @kAddLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add language'**
  String get kAddLanguage;

  /// No description provided for @kErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select data to proceed!'**
  String get kErrorMessage;

  /// No description provided for @kGetMoreCoinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Get More Coins'**
  String get kGetMoreCoinsLabel;

  /// No description provided for @kBuyNowLabel.
  ///
  /// In en, this message translates to:
  /// **'BUY NOW'**
  String get kBuyNowLabel;

  /// No description provided for @kYourCoinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Coins'**
  String get kYourCoinsLabel;

  /// No description provided for @kSettingUpperCaseLabel.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get kSettingUpperCaseLabel;

  /// No description provided for @kEditProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get kEditProfileLabel;

  /// No description provided for @kSettingLowerCaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get kSettingLowerCaseLabel;

  /// No description provided for @kAccountSettingLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get kAccountSettingLabel;

  /// No description provided for @kLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get kLocationLabel;

  /// No description provided for @kActiveSubscriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Subscription'**
  String get kActiveSubscriptionLabel;

  /// No description provided for @kBillingLabel.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get kBillingLabel;

  /// No description provided for @kPurchaseHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get kPurchaseHistoryLabel;

  /// No description provided for @kPrivacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get kPrivacyLabel;

  /// No description provided for @kBlockingLabel.
  ///
  /// In en, this message translates to:
  /// **'Blocking'**
  String get kBlockingLabel;

  /// No description provided for @kNotificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get kNotificationLabel;

  /// No description provided for @kPushNotificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get kPushNotificationLabel;

  /// No description provided for @kHelpAndSupportLabel.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get kHelpAndSupportLabel;

  /// No description provided for @kTermAndConditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get kTermAndConditionLabel;

  /// No description provided for @kWhatNewLabel.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get kWhatNewLabel;

  /// No description provided for @kLogoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get kLogoutLabel;

  /// No description provided for @kDeleteAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get kDeleteAccountLabel;

  /// No description provided for @kNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get kNameLabel;

  /// No description provided for @kAboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get kAboutLabel;

  /// No description provided for @kJobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get kJobTitleLabel;

  /// No description provided for @kSchoolLabel.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get kSchoolLabel;

  /// No description provided for @kLivingInLabel.
  ///
  /// In en, this message translates to:
  /// **'Living In'**
  String get kLivingInLabel;

  /// No description provided for @kSmokeLabel.
  ///
  /// In en, this message translates to:
  /// **'Smoke?'**
  String get kSmokeLabel;

  /// No description provided for @kInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get kInterestLabel;

  /// No description provided for @kAddInterestLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Interests'**
  String get kAddInterestLabel;

  /// No description provided for @kMoreDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get kMoreDetailsLabel;

  /// No description provided for @kAddMoreDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Add More Details'**
  String get kAddMoreDetailsLabel;

  /// No description provided for @kGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender?'**
  String get kGenderLabel;

  /// No description provided for @kControlYourProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Control Your Profile'**
  String get kControlYourProfileLabel;

  /// No description provided for @kDontShowMyAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Show My Age'**
  String get kDontShowMyAgeLabel;

  /// No description provided for @kMakeDistanceInvisibleLabel.
  ///
  /// In en, this message translates to:
  /// **'Make my distance invisible'**
  String get kMakeDistanceInvisibleLabel;

  /// No description provided for @kSaveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get kSaveLabel;

  /// No description provided for @kEditProfileLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get kEditProfileLowerCase;

  /// No description provided for @kMatchesLabel.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get kMatchesLabel;

  /// No description provided for @kLikedYouLabel.
  ///
  /// In en, this message translates to:
  /// **'Liked You'**
  String get kLikedYouLabel;

  /// No description provided for @kLikedProfilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Liked Profiles'**
  String get kLikedProfilesLabel;

  /// No description provided for @kUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get kUnlockLabel;

  /// No description provided for @kUnlockFeatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlock Feature'**
  String get kUnlockFeatureLabel;

  /// No description provided for @kOkLabel.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get kOkLabel;

  /// No description provided for @kLastProfile.
  ///
  /// In en, this message translates to:
  /// **'You have reached the last profile!'**
  String get kLastProfile;

  /// No description provided for @kStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get kStartOver;

  /// No description provided for @kOnlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get kOnlineLabel;

  /// No description provided for @kOfflineLabel.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get kOfflineLabel;

  /// No description provided for @kMaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get kMaleLabel;

  /// No description provided for @kFemaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get kFemaleLabel;

  /// No description provided for @kTipKeepItShortAndSweetLabel.
  ///
  /// In en, this message translates to:
  /// **'Tip :Keep it short and sweet.'**
  String get kTipKeepItShortAndSweetLabel;

  /// No description provided for @kCanWeGetYorNumber.
  ///
  /// In en, this message translates to:
  /// **'Can we get your number?'**
  String get kCanWeGetYorNumber;

  /// No description provided for @kWeOnlyUsePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'We only use phone numbers to\nmake sure everyone on Phoosar is real'**
  String get kWeOnlyUsePhoneNumber;

  /// No description provided for @kNoProblem.
  ///
  /// In en, this message translates to:
  /// **'Opps... but no problem'**
  String get kNoProblem;

  /// No description provided for @kEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to\nrecovery your password'**
  String get kEnterYourPhoneNumber;

  /// No description provided for @kEnter8Characters.
  ///
  /// In en, this message translates to:
  /// **'Enter a password 8 characters or longer'**
  String get kEnter8Characters;

  /// No description provided for @kMakeItMemorable.
  ///
  /// In en, this message translates to:
  /// **'Make it memorable'**
  String get kMakeItMemorable;

  /// No description provided for @kYourCodeIsComing.
  ///
  /// In en, this message translates to:
  /// **'Your code is coming'**
  String get kYourCodeIsComing;

  /// No description provided for @kCheckYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your message and enter\nthe 6 digits code'**
  String get kCheckYourMessage;

  /// No description provided for @kInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get kInterests;

  /// No description provided for @kPickOneToSix.
  ///
  /// In en, this message translates to:
  /// **'Pick 1 to 6'**
  String get kPickOneToSix;

  /// No description provided for @kSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip For Now'**
  String get kSkipForNow;

  /// No description provided for @kFindStrongerMatches.
  ///
  /// In en, this message translates to:
  /// **'Find stronger matches!'**
  String get kFindStrongerMatches;

  /// No description provided for @kAnswerTheFollowingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Answer the following questions to\ncomplete your profile.'**
  String get kAnswerTheFollowingQuestion;

  /// No description provided for @kSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get kSend;

  /// No description provided for @kWriteShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Write a short description that best describes you.'**
  String get kWriteShortDescription;

  /// No description provided for @kPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get kPayment;

  /// No description provided for @kFindNearestShop.
  ///
  /// In en, this message translates to:
  /// **'Find the nearest shop'**
  String get kFindNearestShop;

  /// No description provided for @kProvideQrCode.
  ///
  /// In en, this message translates to:
  /// **'Provide the QR code to the agent'**
  String get kProvideQrCode;

  /// No description provided for @kMakePayment.
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get kMakePayment;

  /// No description provided for @kConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get kConfirmation;

  /// No description provided for @kSureWantToReport.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to report?'**
  String get kSureWantToReport;

  /// No description provided for @kCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get kCancel;

  /// No description provided for @kOk.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get kOk;

  /// No description provided for @kProfileReportSaveSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile Report save\nsuccessfully'**
  String get kProfileReportSaveSuccessfully;

  /// No description provided for @kContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get kContinue;

  /// No description provided for @kTypeInOneInterest.
  ///
  /// In en, this message translates to:
  /// **'Type in one interest at a time hit the  \' + \'  icon.'**
  String get kTypeInOneInterest;

  /// No description provided for @kTapHereToAddInterest.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add an interest'**
  String get kTapHereToAddInterest;

  /// No description provided for @kUseTheseWritingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Use these writing prompt to make your profile even better! Click on a prompt to add it to your profile.'**
  String get kUseTheseWritingPrompt;

  /// No description provided for @kAllDone.
  ///
  /// In en, this message translates to:
  /// **'All Done!'**
  String get kAllDone;

  /// No description provided for @kYourProfileIsComplete.
  ///
  /// In en, this message translates to:
  /// **'Your profile is complete'**
  String get kYourProfileIsComplete;

  /// No description provided for @kFindMatches.
  ///
  /// In en, this message translates to:
  /// **'Find Matches'**
  String get kFindMatches;

  /// No description provided for @theConnectionLookingFor.
  ///
  /// In en, this message translates to:
  /// **'Connection I\'m looking for'**
  String get theConnectionLookingFor;

  /// No description provided for @doYouWantToLogoutFromTheApp.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout from the app?'**
  String get doYouWantToLogoutFromTheApp;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @doYouWantToDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your account? This action cannot be undone'**
  String get doYouWantToDeleteAccount;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New Password'**
  String get enterNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @gaining.
  ///
  /// In en, this message translates to:
  /// **'Gaining'**
  String get gaining;

  /// No description provided for @forFirstSignUp.
  ///
  /// In en, this message translates to:
  /// **'FOR THE\nFIRST SIGN-UP'**
  String get forFirstSignUp;

  /// No description provided for @vpnDescription.
  ///
  /// In en, this message translates to:
  /// **'TURN ON YOUR VPN TO\nMAKE SURE NOTHING\nSTANDS IN YOUR WAY!'**
  String get vpnDescription;

  /// No description provided for @locationDescription.
  ///
  /// In en, this message translates to:
  /// **'Your location is used for better matching and will never be shared with anyone.'**
  String get locationDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'my':
      return AppLocalizationsMy();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
