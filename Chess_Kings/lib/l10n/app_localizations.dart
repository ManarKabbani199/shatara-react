import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('hi'),
    Locale('ru')
  ];

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome To'**
  String get welcomeTo;

  /// No description provided for @pleaseLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please Login To Continue'**
  String get pleaseLoginToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterCorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Correct Email'**
  String get pleaseEnterCorrectEmail;

  /// No description provided for @passwordMustContainUppercaseAndLowercaseLettersAndNumbers.
  ///
  /// In en, this message translates to:
  /// **'Password Must Contain Upper Case And Lower Case Letters And Numbers'**
  String get passwordMustContainUppercaseAndLowercaseLettersAndNumbers;

  /// No description provided for @lOGIN.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get lOGIN;

  /// No description provided for @dontHaveAnAccountClickMe.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have An Account? Click Me'**
  String get dontHaveAnAccountClickMe;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In With Google'**
  String get signInWithGoogle;

  /// No description provided for @errorInEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Error In Email Or Password'**
  String get errorInEmailOrPassword;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @onlyAlphabetsAreAllowedInAUsername.
  ///
  /// In en, this message translates to:
  /// **'Only Alphabets Are Allowed In A Username'**
  String get onlyAlphabetsAreAllowedInAUsername;

  /// No description provided for @someErrorHappen.
  ///
  /// In en, this message translates to:
  /// **'Some Error Happen'**
  String get someErrorHappen;

  /// No description provided for @playingWithTheComputer.
  ///
  /// In en, this message translates to:
  /// **'Playing With The Computer'**
  String get playingWithTheComputer;

  /// No description provided for @playNow.
  ///
  /// In en, this message translates to:
  /// **'Play Now'**
  String get playNow;

  /// No description provided for @numberOfTimesYouLoginToSite.
  ///
  /// In en, this message translates to:
  /// **'Number Of Times You Login To Site'**
  String get numberOfTimesYouLoginToSite;

  /// No description provided for @numberOfTimesYouPlayWithTheComputer.
  ///
  /// In en, this message translates to:
  /// **'Number Of Times You Play With The Computer'**
  String get numberOfTimesYouPlayWithTheComputer;

  /// No description provided for @numberOfWinsOverTheComputer.
  ///
  /// In en, this message translates to:
  /// **'Number Of Wins Over The Computer'**
  String get numberOfWinsOverTheComputer;

  /// No description provided for @playWithSomeone.
  ///
  /// In en, this message translates to:
  /// **'Play With Some One'**
  String get playWithSomeone;

  /// No description provided for @loginPage.
  ///
  /// In en, this message translates to:
  /// **'Login Page'**
  String get loginPage;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @existingUser.
  ///
  /// In en, this message translates to:
  /// **'Existing User ?'**
  String get existingUser;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions, contact us'**
  String get phone;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'Or contact us via WhatsApp'**
  String get whatsapp;

  /// No description provided for @playOverTheNetwork.
  ///
  /// In en, this message translates to:
  /// **'Play over the network'**
  String get playOverTheNetwork;
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
      <String>['ar', 'en', 'fa', 'hi', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'hi':
      return AppLocalizationsHi();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
