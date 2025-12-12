// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get welcome => 'Ongi etorri';

  @override
  String get chooseProfile => 'Aukeratu zure profila';

  @override
  String get teacher => 'Irakaslea';

  @override
  String get teacherDescription => 'Kudeatu ibilbideak eta lasaiketa-probak';

  @override
  String get participant => 'Parte-hartzailea';

  @override
  String get participantDescription => 'Probara batu';

  @override
  String get appTitle => 'eCO - Orientazio Lasterketa';

  @override
  String get french => 'Frantsesa';

  @override
  String get english => 'Ingelesa';

  @override
  String get basque => 'Euskara';

  @override
  String get selectLanguage => 'Hizkuntza hautatu';

  @override
  String get teacherLoginTitle => 'Irakaslearen saioa hasi';

  @override
  String get teacherLoginSubtitle => 'Sartu zure ibilbide eta lasterketetara';

  @override
  String get email => 'E-posta';

  @override
  String get emailHint => 'adibidea@posta.eus';

  @override
  String get password => 'Pasahitza';

  @override
  String get pleaseEnterEmail => 'Mesedez, sartu zure e-posta';

  @override
  String get invalidEmail => 'E-posta baliogabea';

  @override
  String get pleaseEnterPassword => 'Mesedez, sartu zure pasahitza';

  @override
  String get passwordMinLength =>
      'Pasahitzak gutxienez 6 karaktere izan behar ditu';

  @override
  String get loginButton => 'Saioa hasi';

  @override
  String get loginError => 'Saioa hasteko errorea';

  @override
  String error(Object message) {
    return 'Errorea: $message';
  }

  @override
  String get teacherHomeTitle => 'Irakaslearen gunea';

  @override
  String get logout => 'Saioa itxi';

  @override
  String get logoutConfirmTitle => 'Saioa itxi';

  @override
  String get logoutConfirmMessage => 'Benetan saioa itxi nahi duzu?';

  @override
  String get cancel => 'Ezeztatu';

  @override
  String get coursesTab => 'Probak';

  @override
  String get routesTab => 'Ibilbideak';

  @override
  String get sessionClosed => '✅ Saioa itxita';

  @override
  String get closeSessionError => 'Errorea ixtean';

  @override
  String get noCompletedSessions => 'Ez dago amaitutako probarik';

  @override
  String participants(Object count) {
    return '$count parte-hartzaile';
  }

  @override
  String duration(Object hours, Object minutes) {
    return 'Iraupena: ${hours}h ${minutes}min';
  }

  @override
  String get createSession => 'Proba sortu';

  @override
  String get closeSession => 'Saioa itxi';

  @override
  String closeSessionConfirm(Object name) {
    return 'Benetan \"$name\" saioa itxi nahi duzu?\n\nEkintza hau itzulezina da.';
  }

  @override
  String get close => 'Itxi';

  @override
  String get noCourses => 'Ez dago ibilbiderik';

  @override
  String get draft => 'Zirriborroa';

  @override
  String get placementInProgress => 'Kokapena abian';

  @override
  String get ready => 'Prest';

  @override
  String get inProgress => 'Abian';

  @override
  String get completed => 'Amaituta';

  @override
  String get archived => 'Artxibatuta';

  @override
  String get createSessionTitle => 'Proba sortu';

  @override
  String get sessionName => 'Probaren izena';

  @override
  String get sessionNameHint => 'Ad: Abenduaren 9ko proba';

  @override
  String get selectRoute => 'Ibilbidea hautatu';

  @override
  String get readyRoutes => 'Ibilbide prest (berriena lehenik)';

  @override
  String get pleaseEnterName => 'Mesedez, sartu izena';

  @override
  String get pleaseSelectRoute => 'Mesedez, hautatu ibilbidea';

  @override
  String get noReadyRoutes => 'Ez dago ibilbiderik prest';

  @override
  String get needToPlaceBeacons =>
      'Lehenik ibilbide baten\nbalizak sortu eta kokatu behar dituzu';

  @override
  String get back => 'Atzera';

  @override
  String get noDescription => 'Deskribapenik ez';

  @override
  String get createAndLaunch => 'Proba sortu eta abiarazi';

  @override
  String get creating => 'Sortzen...';

  @override
  String get creationError => 'Errorea sortzean';

  @override
  String beaconsPlaced(Object placed, Object total) {
    return '$placed/$total baliza kokatuak';
  }

  @override
  String get scanner => 'Eskaneatu';

  @override
  String get beacons => 'Balizak';

  @override
  String get start => 'Abiapuntua';

  @override
  String get finish => 'Amaitu';

  @override
  String get controlBeacons => 'Kontrol balizak';

  @override
  String get confirmPlacement => 'Kokapen berretsi';

  @override
  String beacon(Object name) {
    return 'Baliza: $name';
  }

  @override
  String get gpsPosition => 'GPS kokapena:';

  @override
  String get confirm => 'Berretsi';

  @override
  String beaconPlaced(Object name) {
    return '✅ $name kokatuta';
  }

  @override
  String get placementError => 'Errorea kokatzean';

  @override
  String get allBeaconsPlaced => '✅ Baliza guztiak kokatuak! Ibilbidea prest.';

  @override
  String get gpsDisabled => 'GPSa desaktibatuta dago. Mesedez, aktibatu ezazu.';

  @override
  String get locationPermissionDenied => 'Kokapen baimena ukatuta';

  @override
  String get locationPermissionDeniedForever =>
      'Kokapen baimena behin betiko ukatuta.';

  @override
  String get alreadyPlaced => 'Baliza hau dagoeneko kokatuta dago';

  @override
  String get cannotGetPreciseLocation => 'Ezin da GPS kokapen zehatza lortu';

  @override
  String get scanQRCode => 'Eskaneatu balizaren QR kodea';

  @override
  String get precisePositioning => 'Kokapen zehatza abian';

  @override
  String type(Object type) {
    return 'Mota: $type';
  }

  @override
  String status(Object status) {
    return 'Egoera: $status';
  }

  @override
  String get placed => '✅ Kokatuta';

  @override
  String get toPlace => '⏳ Kokatzeko';

  @override
  String placedOn(Object date) {
    return 'Kokatuta: $date';
  }

  @override
  String get closeButton => 'Itxi';

  @override
  String get joinSession => 'Probara batu';

  @override
  String get chooseJoinMethod => 'Aukeratu nola batu';

  @override
  String get scanQRCodeButton => 'QR kodea eskaneatu';

  @override
  String get scanStartBeacon => 'Abiapuntuko baliza eskaneatu';

  @override
  String get enterCode => 'Kodea sartu';

  @override
  String get enterSessionCode => 'Sesio kodea sartu';

  @override
  String get scanBeaconTitle => 'Baliza eskaneatu';

  @override
  String get enterYourName => 'Sartu zure ezizena';

  @override
  String get yourName => 'Zure izena';

  @override
  String get validate => 'Balioztatu';

  @override
  String get placeQRCodeInFrame =>
      'Jarri abiapuntuko balizaren\nQR kodea esparru honetan';

  @override
  String get notStartBeacon =>
      'QR kode hau ez dator bat abiapuntuko balizarekin';

  @override
  String scanError(Object error) {
    return 'Errorea eskaneatzerakoan: $error';
  }

  @override
  String get enterCodeTitle => 'Kodea sartu';

  @override
  String get enterCodeSubtitle => 'Sartu probaren kodea';

  @override
  String get sessionCode => 'Probaren kodea';

  @override
  String get sessionCodeHint => 'Ad: ABC123';

  @override
  String get yourPseudo => 'Zure ezizena';

  @override
  String get yourPseudoHint => 'Ad: Jon';

  @override
  String get pleaseEnterPseudo => 'Mesedez, sartu zure ezizena';

  @override
  String get pleaseEnterCode => 'Mesedez, sartu kodea';

  @override
  String get invalidSessionCode => 'Saio kode baliogabea';

  @override
  String get join => 'Batu';

  @override
  String raceTitle(Object name) {
    return 'Proba - $name';
  }

  @override
  String get progress => 'Aurrerapena';

  @override
  String beaconsCount(Object scanned, Object total) {
    return '$scanned / $total baliza';
  }

  @override
  String get scanBeacon => 'Baliza eskaneatu';

  @override
  String get congratulations => '🎉 Zorionak!';

  @override
  String get raceCompleted => 'Proba osatu duzu!';

  @override
  String get alreadyScanned => 'Baliza dagoeneko eskaneatuta';

  @override
  String beaconScanned(Object name) {
    return '$name baliza eskaneatuta ✓';
  }

  @override
  String get arrival => 'Helmuga';

  @override
  String get departure => 'Abiapuntua';

  @override
  String get beaconLabel => 'Baliza';

  @override
  String get scanned => 'Eskaneatuta ✓';

  @override
  String get toScan => 'Eskaneatzeko';
}
