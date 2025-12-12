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

  /// Welcome message on the choice screen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Instruction to select a profile type
  ///
  /// In en, this message translates to:
  /// **'Choose your profile'**
  String get chooseProfile;

  /// Teacher profile option
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// Description of teacher profile features
  ///
  /// In en, this message translates to:
  /// **'Manage courses and races'**
  String get teacherDescription;

  /// Participant profile option
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get participant;

  /// Description of participant profile features
  ///
  /// In en, this message translates to:
  /// **'Join a race'**
  String get participantDescription;

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'eCO - Orienteering Race'**
  String get appTitle;

  /// French language option
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Basque language option
  ///
  /// In en, this message translates to:
  /// **'Basque'**
  String get basque;

  /// Language selector label
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @teacherLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Login'**
  String get teacherLoginTitle;

  /// No description provided for @teacherLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your courses and sessions'**
  String get teacherLoginSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(Object message);

  /// No description provided for @teacherHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Space'**
  String get teacherHomeTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @coursesTab.
  ///
  /// In en, this message translates to:
  /// **'Races'**
  String get coursesTab;

  /// No description provided for @routesTab.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routesTab;

  /// No description provided for @activeSessionsTab.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeSessionsTab;

  /// No description provided for @finishRace.
  ///
  /// In en, this message translates to:
  /// **'Finish race'**
  String get finishRace;

  /// No description provided for @finishRaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Finish race \"{sessionName}\"?'**
  String finishRaceConfirm(Object sessionName);

  /// No description provided for @raceFinished.
  ///
  /// In en, this message translates to:
  /// **'Race finished'**
  String get raceFinished;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active races'**
  String get noActiveSessions;

  /// No description provided for @createNewSessionToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a new race to start'**
  String get createNewSessionToStart;

  /// No description provided for @noDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get noDate;

  /// No description provided for @sessionClosed.
  ///
  /// In en, this message translates to:
  /// **'✅ Session closed'**
  String get sessionClosed;

  /// No description provided for @closeSessionError.
  ///
  /// In en, this message translates to:
  /// **'Error while closing'**
  String get closeSessionError;

  /// No description provided for @noCompletedSessions.
  ///
  /// In en, this message translates to:
  /// **'No completed races'**
  String get noCompletedSessions;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'{count} participant(s)'**
  String participants(Object count);

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration: {hours}h {minutes}min'**
  String duration(Object hours, Object minutes);

  /// No description provided for @createSession.
  ///
  /// In en, this message translates to:
  /// **'Create a race'**
  String get createSession;

  /// No description provided for @closeSession.
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get closeSession;

  /// No description provided for @closeSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to close the session \"{name}\"?\n\nThis action is irreversible.'**
  String closeSessionConfirm(Object name);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No routes'**
  String get noCourses;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @placementInProgress.
  ///
  /// In en, this message translates to:
  /// **'Placement in progress'**
  String get placementInProgress;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @createSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a race'**
  String get createSessionTitle;

  /// No description provided for @sessionName.
  ///
  /// In en, this message translates to:
  /// **'Race name'**
  String get sessionName;

  /// No description provided for @sessionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: December 9th race'**
  String get sessionNameHint;

  /// No description provided for @selectRoute.
  ///
  /// In en, this message translates to:
  /// **'Select a route'**
  String get selectRoute;

  /// No description provided for @readyRoutes.
  ///
  /// In en, this message translates to:
  /// **'Ready routes (most recent first)'**
  String get readyRoutes;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseSelectRoute.
  ///
  /// In en, this message translates to:
  /// **'Please select a route'**
  String get pleaseSelectRoute;

  /// No description provided for @noReadyRoutes.
  ///
  /// In en, this message translates to:
  /// **'No ready routes'**
  String get noReadyRoutes;

  /// No description provided for @needToPlaceBeacons.
  ///
  /// In en, this message translates to:
  /// **'You must first create and place\nthe beacons for a route'**
  String get needToPlaceBeacons;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @createAndLaunch.
  ///
  /// In en, this message translates to:
  /// **'Create and launch race'**
  String get createAndLaunch;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @creationError.
  ///
  /// In en, this message translates to:
  /// **'Error during creation'**
  String get creationError;

  /// No description provided for @beaconsPlaced.
  ///
  /// In en, this message translates to:
  /// **'{placed}/{total} beacons placed'**
  String beaconsPlaced(Object placed, Object total);

  /// No description provided for @scanner.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanner;

  /// No description provided for @beacons.
  ///
  /// In en, this message translates to:
  /// **'Beacons'**
  String get beacons;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @controlBeacons.
  ///
  /// In en, this message translates to:
  /// **'Control beacons'**
  String get controlBeacons;

  /// No description provided for @confirmPlacement.
  ///
  /// In en, this message translates to:
  /// **'Confirm placement'**
  String get confirmPlacement;

  /// No description provided for @beacon.
  ///
  /// In en, this message translates to:
  /// **'Beacon: {name}'**
  String beacon(Object name);

  /// No description provided for @gpsPosition.
  ///
  /// In en, this message translates to:
  /// **'GPS position:'**
  String get gpsPosition;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @beaconPlaced.
  ///
  /// In en, this message translates to:
  /// **'✅ {name} placed'**
  String beaconPlaced(Object name);

  /// No description provided for @placementError.
  ///
  /// In en, this message translates to:
  /// **'Placement error'**
  String get placementError;

  /// No description provided for @allBeaconsPlaced.
  ///
  /// In en, this message translates to:
  /// **'✅ All beacons placed! Route ready.'**
  String get allBeaconsPlaced;

  /// No description provided for @gpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'GPS is disabled. Please enable it.'**
  String get gpsDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @alreadyPlaced.
  ///
  /// In en, this message translates to:
  /// **'This beacon is already placed'**
  String get alreadyPlaced;

  /// No description provided for @cannotGetPreciseLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get a precise GPS position'**
  String get cannotGetPreciseLocation;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the beacon\'s QR code'**
  String get scanQRCode;

  /// No description provided for @precisePositioning.
  ///
  /// In en, this message translates to:
  /// **'Precise positioning in progress'**
  String get precisePositioning;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String type(Object type);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String status(Object status);

  /// No description provided for @placed.
  ///
  /// In en, this message translates to:
  /// **'✅ Placed'**
  String get placed;

  /// No description provided for @toPlace.
  ///
  /// In en, this message translates to:
  /// **'⏳ To place'**
  String get toPlace;

  /// No description provided for @placedOn.
  ///
  /// In en, this message translates to:
  /// **'Placed on: {date}'**
  String placedOn(Object date);

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @joinSession.
  ///
  /// In en, this message translates to:
  /// **'Join a race'**
  String get joinSession;

  /// No description provided for @chooseJoinMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how to join'**
  String get chooseJoinMethod;

  /// No description provided for @scanQRCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCodeButton;

  /// No description provided for @scanStartBeacon.
  ///
  /// In en, this message translates to:
  /// **'Scan the start beacon'**
  String get scanStartBeacon;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @enterSessionCode.
  ///
  /// In en, this message translates to:
  /// **'Enter session code'**
  String get enterSessionCode;

  /// No description provided for @scanBeaconTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan beacon'**
  String get scanBeaconTitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname'**
  String get enterYourName;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @placeQRCodeInFrame.
  ///
  /// In en, this message translates to:
  /// **'Place the start beacon\'s QR code\nin the frame'**
  String get placeQRCodeInFrame;

  /// No description provided for @notStartBeacon.
  ///
  /// In en, this message translates to:
  /// **'This QR code does not correspond to a start beacon'**
  String get notStartBeacon;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(Object error);

  /// No description provided for @enterCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCodeTitle;

  /// No description provided for @enterCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the race code'**
  String get enterCodeSubtitle;

  /// No description provided for @sessionCode.
  ///
  /// In en, this message translates to:
  /// **'Race code'**
  String get sessionCode;

  /// No description provided for @sessionCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: ABC123'**
  String get sessionCodeHint;

  /// No description provided for @yourPseudo.
  ///
  /// In en, this message translates to:
  /// **'Your nickname'**
  String get yourPseudo;

  /// No description provided for @yourPseudoHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: John'**
  String get yourPseudoHint;

  /// No description provided for @pleaseEnterPseudo.
  ///
  /// In en, this message translates to:
  /// **'Please enter your nickname'**
  String get pleaseEnterPseudo;

  /// No description provided for @pleaseEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the code'**
  String get pleaseEnterCode;

  /// No description provided for @invalidSessionCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid session code'**
  String get invalidSessionCode;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @raceTitle.
  ///
  /// In en, this message translates to:
  /// **'Race - {name}'**
  String raceTitle(Object name);

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @beaconsCount.
  ///
  /// In en, this message translates to:
  /// **'{scanned} / {total} beacons'**
  String beaconsCount(Object scanned, Object total);

  /// No description provided for @scanBeacon.
  ///
  /// In en, this message translates to:
  /// **'Scan beacon'**
  String get scanBeacon;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations!'**
  String get congratulations;

  /// No description provided for @raceCompleted.
  ///
  /// In en, this message translates to:
  /// **'You completed the race!'**
  String get raceCompleted;

  /// No description provided for @alreadyScanned.
  ///
  /// In en, this message translates to:
  /// **'Beacon already scanned'**
  String get alreadyScanned;

  /// No description provided for @beaconScanned.
  ///
  /// In en, this message translates to:
  /// **'Beacon {name} scanned ✓'**
  String beaconScanned(Object name);

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @beaconLabel.
  ///
  /// In en, this message translates to:
  /// **'Beacon'**
  String get beaconLabel;

  /// No description provided for @scanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned ✓'**
  String get scanned;

  /// No description provided for @toScan.
  ///
  /// In en, this message translates to:
  /// **'To scan'**
  String get toScan;
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
