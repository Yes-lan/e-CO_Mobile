import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fr.dart';

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
    Locale('en'),
    Locale('eu'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'eCO - Course d\'Orientation'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get welcome;

  /// No description provided for @chooseProfile.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre profil'**
  String get chooseProfile;

  /// No description provided for @teacher.
  ///
  /// In fr, this message translates to:
  /// **'Professeur'**
  String get teacher;

  /// No description provided for @manageCourses.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les parcours et courses'**
  String get manageCourses;

  /// No description provided for @participant.
  ///
  /// In fr, this message translates to:
  /// **'Participant'**
  String get participant;

  /// No description provided for @joinCourse.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une course'**
  String get joinCourse;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @basque.
  ///
  /// In fr, this message translates to:
  /// **'Euskera'**
  String get basque;

  /// No description provided for @selectLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner la langue'**
  String get selectLanguage;

  /// No description provided for @teacherLogin.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Professeur'**
  String get teacherLogin;

  /// No description provided for @accessCourses.
  ///
  /// In fr, this message translates to:
  /// **'Accédez à vos parcours et sessions'**
  String get accessCourses;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In fr, this message translates to:
  /// **'exemple@mail.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre email'**
  String get invalidEmail;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get invalidEmailFormat;

  /// No description provided for @emptyPassword.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer votre mot de passe'**
  String get emptyPassword;

  /// No description provided for @shortPassword.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get shortPassword;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get login;

  /// No description provided for @participantJoin.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une course'**
  String get participantJoin;

  /// No description provided for @chooseHowToJoin.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez comment rejoindre'**
  String get chooseHowToJoin;

  /// No description provided for @scanQrCode.
  ///
  /// In fr, this message translates to:
  /// **'Scanner le QR Code'**
  String get scanQrCode;

  /// No description provided for @scanBeaconStart.
  ///
  /// In fr, this message translates to:
  /// **'Scannez la balise de départ'**
  String get scanBeaconStart;

  /// No description provided for @enterCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrer le code'**
  String get enterCode;

  /// No description provided for @enterSessionCode.
  ///
  /// In fr, this message translates to:
  /// **'Saisir le code de session'**
  String get enterSessionCode;

  /// No description provided for @enterYourNickname.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre pseudo'**
  String get enterYourNickname;

  /// No description provided for @yourNickname.
  ///
  /// In fr, this message translates to:
  /// **'Votre pseudo'**
  String get yourNickname;

  /// No description provided for @yourNicknameHint.
  ///
  /// In fr, this message translates to:
  /// **'ex: Jean'**
  String get yourNicknameHint;

  /// No description provided for @scanStartBeacon.
  ///
  /// In fr, this message translates to:
  /// **'Scanner la balise'**
  String get scanStartBeacon;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @sessionCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de course'**
  String get sessionCode;

  /// No description provided for @sessionCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: ABC123'**
  String get sessionCodeHint;

  /// No description provided for @invalidSessionCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de session invalide'**
  String get invalidSessionCode;

  /// No description provided for @enterTheCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrer le code'**
  String get enterTheCode;

  /// No description provided for @selectYourCode.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code de la course'**
  String get selectYourCode;

  /// No description provided for @joinRace.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get joinRace;

  /// No description provided for @races.
  ///
  /// In fr, this message translates to:
  /// **'Courses'**
  String get races;

  /// No description provided for @courses.
  ///
  /// In fr, this message translates to:
  /// **'Parcours'**
  String get courses;

  /// No description provided for @teacherHome.
  ///
  /// In fr, this message translates to:
  /// **'Mes courses'**
  String get teacherHome;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get confirmLogoutMessage;

  /// No description provided for @noCompletedRaces.
  ///
  /// In fr, this message translates to:
  /// **'Aucune course terminée'**
  String get noCompletedRaces;

  /// No description provided for @participants.
  ///
  /// In fr, this message translates to:
  /// **'participant(s)'**
  String get participants;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get duration;

  /// No description provided for @gpsDisabled.
  ///
  /// In fr, this message translates to:
  /// **'Le GPS est désactivé. Veuillez l\'activer.'**
  String get gpsDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Permission de localisation refusée'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In fr, this message translates to:
  /// **'Permission de localisation refusée définitivement.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @createRace.
  ///
  /// In fr, this message translates to:
  /// **'Créer une course'**
  String get createRace;

  /// No description provided for @raceName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la course'**
  String get raceName;

  /// No description provided for @raceNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: Course du 9 décembre'**
  String get raceNameHint;

  /// No description provided for @selectCourse.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un parcours'**
  String get selectCourse;

  /// No description provided for @noCourseReady.
  ///
  /// In fr, this message translates to:
  /// **'Aucun parcours prêt'**
  String get noCourseReady;

  /// No description provided for @mustCreatePlaceBefore.
  ///
  /// In fr, this message translates to:
  /// **'Vous devez d\'abord créer et placer\nles balises d\'un parcours'**
  String get mustCreatePlaceBefore;

  /// No description provided for @back.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// No description provided for @noReady.
  ///
  /// In fr, this message translates to:
  /// **'Aucun parcours prêt'**
  String get noReady;

  /// No description provided for @beaconsPlaced.
  ///
  /// In fr, this message translates to:
  /// **'balises placées'**
  String get beaconsPlaced;
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
      <String>['en', 'eu', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'eu':
      return AppLocalizationsEu();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
