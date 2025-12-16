// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get chooseProfile => 'Choose your profile';

  @override
  String get teacher => 'Teacher';

  @override
  String get teacherDescription => 'Manage courses and races';

  @override
  String get participant => 'Participant';

  @override
  String get participantDescription => 'Join a race';

  @override
  String get appTitle => 'eCO - Orienteering Race';

  @override
  String get french => 'French';

  @override
  String get english => 'English';

  @override
  String get basque => 'Basque';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get teacherLoginTitle => 'Teacher Login';

  @override
  String get teacherLoginSubtitle => 'Access your courses and sessions';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must contain at least 6 characters';

  @override
  String get loginButton => 'Log in';

  @override
  String get loginError => 'Login error';

  @override
  String error(Object message) {
    return 'Error: $message';
  }

  @override
  String get teacherHomeTitle => 'Teacher Space';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Do you really want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get coursesTab => 'Races';

  @override
  String get routesTab => 'Routes';

  @override
  String get activeSessionsTab => 'Active';

  @override
  String get finishRace => 'Finish race';

  @override
  String finishRaceConfirm(Object sessionName) {
    return 'Finish race \"$sessionName\"?';
  }

  @override
  String get raceFinished => 'Race finished';

  @override
  String get errorGeneric => 'Error';

  @override
  String get view => 'View';

  @override
  String get noActiveSessions => 'No active races';

  @override
  String get createNewSessionToStart => 'Create a new race to start';

  @override
  String get noDate => 'No date';

  @override
  String get sessionClosed => '✅ Session closed';

  @override
  String get closeSessionError => 'Error while closing';

  @override
  String get noCompletedSessions => 'No completed races';

  @override
  String participants(Object count) {
    return '$count participant(s)';
  }

  @override
  String duration(Object hours, Object minutes) {
    return 'Duration: ${hours}h ${minutes}min';
  }

  @override
  String get createSession => 'Create a race';

  @override
  String get closeSession => 'Close session';

  @override
  String closeSessionConfirm(Object name) {
    return 'Do you really want to close the session \"$name\"?\n\nThis action is irreversible.';
  }

  @override
  String get close => 'Close';

  @override
  String get noCourses => 'No routes';

  @override
  String get draft => 'Draft';

  @override
  String get placementInProgress => 'Placement in progress';

  @override
  String get ready => 'Ready';

  @override
  String get inProgress => 'In progress';

  @override
  String get completed => 'Completed';

  @override
  String get archived => 'Archived';

  @override
  String get createSessionTitle => 'Create a race';

  @override
  String get sessionName => 'Race name';

  @override
  String get sessionNameHint => 'Ex: December 9th race';

  @override
  String get selectRoute => 'Select a route';

  @override
  String get readyRoutes => 'Ready routes (most recent first)';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get pleaseSelectRoute => 'Please select a route';

  @override
  String get noReadyRoutes => 'No ready routes';

  @override
  String get needToPlaceBeacons =>
      'You must first create and place\nthe beacons for a route';

  @override
  String get back => 'Back';

  @override
  String get noDescription => 'No description';

  @override
  String get createAndLaunch => 'Create and launch race';

  @override
  String get creating => 'Creating...';

  @override
  String get creationError => 'Error during creation';

  @override
  String beaconsPlaced(Object placed, Object total) {
    return '$placed/$total beacons placed';
  }

  @override
  String get scanner => 'Scan';

  @override
  String get beacons => 'Beacons';

  @override
  String get start => 'Start';

  @override
  String get finish => 'Finish';

  @override
  String get controlBeacons => 'Control beacons';

  @override
  String get confirmPlacement => 'Confirm placement';

  @override
  String beacon(Object name) {
    return 'Beacon: $name';
  }

  @override
  String get gpsPosition => 'GPS position:';

  @override
  String get confirm => 'Confirm';

  @override
  String beaconPlaced(Object name) {
    return '✅ $name placed';
  }

  @override
  String get placementError => 'Placement error';

  @override
  String get allBeaconsPlaced => '✅ All beacons placed! Route ready.';

  @override
  String get gpsDisabled => 'GPS is disabled. Please enable it.';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String get locationPermissionDeniedForever =>
      'Location permission permanently denied.';

  @override
  String get alreadyPlaced => 'This beacon is already placed';

  @override
  String get cannotGetPreciseLocation => 'Unable to get a precise GPS position';

  @override
  String get scanQRCode => 'Scan the beacon\'s QR code';

  @override
  String get precisePositioning => 'Precise positioning in progress';

  @override
  String type(Object type) {
    return 'Type: $type';
  }

  @override
  String status(Object status) {
    return 'Status: $status';
  }

  @override
  String get placed => '✅ Placed';

  @override
  String get toPlace => '⏳ To place';

  @override
  String placedOn(Object date) {
    return 'Placed on: $date';
  }

  @override
  String get closeButton => 'Close';

  @override
  String get joinSession => 'Join a race';

  @override
  String get chooseJoinMethod => 'Choose how to join';

  @override
  String get scanQRCodeButton => 'Scan QR Code';

  @override
  String get scanStartBeacon => 'Scan the start beacon';

  @override
  String get enterCode => 'Enter code';

  @override
  String get enterSessionCode => 'Enter session code';

  @override
  String get scanBeaconTitle => 'Scan beacon';

  @override
  String get enterYourName => 'Enter your nickname';

  @override
  String get yourName => 'Your name';

  @override
  String get validate => 'Validate';

  @override
  String get placeQRCodeInFrame =>
      'Place the start beacon\'s QR code\nin the frame';

  @override
  String get notStartBeacon =>
      'This QR code does not correspond to a start beacon';

  @override
  String scanError(Object error) {
    return 'Scan error: $error';
  }

  @override
  String get enterCodeTitle => 'Enter code';

  @override
  String get enterCodeSubtitle => 'Enter the race code';

  @override
  String get sessionCode => 'Race code';

  @override
  String get sessionCodeHint => 'Ex: ABC123';

  @override
  String get yourPseudo => 'Your nickname';

  @override
  String get yourPseudoHint => 'Ex: John';

  @override
  String get pleaseEnterPseudo => 'Please enter your nickname';

  @override
  String get pleaseEnterCode => 'Please enter the code';

  @override
  String get invalidSessionCode => 'Invalid session code';

  @override
  String get join => 'Join';

  @override
  String raceTitle(Object name) {
    return 'Race - $name';
  }

  @override
  String get progress => 'Progress';

  @override
  String beaconsCount(Object scanned, Object total) {
    return '$scanned / $total beacons';
  }

  @override
  String get scanBeacon => 'Scan beacon';

  @override
  String get congratulations => '🎉 Congratulations!';

  @override
  String get raceCompleted => 'You completed the race!';

  @override
  String get alreadyScanned => 'Beacon already scanned';

  @override
  String beaconScanned(Object name) {
    return 'Beacon $name scanned ✓';
  }

  @override
  String get arrival => 'Arrival';

  @override
  String get departure => 'Departure';

  @override
  String get beaconLabel => 'Beacon';

  @override
  String get scanned => 'Scanned ✓';

  @override
  String get toScan => 'To scan';
}
