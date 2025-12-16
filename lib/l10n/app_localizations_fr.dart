// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcome => 'Bienvenue';

  @override
  String get chooseProfile => 'Choisissez votre profil';

  @override
  String get teacher => 'Professeur';

  @override
  String get teacherDescription => 'Gérer les parcours et courses';

  @override
  String get participant => 'Participant';

  @override
  String get participantDescription => 'Rejoindre une course';

  @override
  String get appTitle => 'eCO - Course d\'Orientation';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get basque => 'Basque';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get teacherLoginTitle => 'Connexion Professeur';

  @override
  String get teacherLoginSubtitle => 'Accédez à vos parcours et sessions';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'exemple@mail.com';

  @override
  String get password => 'Mot de passe';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer votre email';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginError => 'Erreur de connexion';

  @override
  String error(Object message) {
    return 'Erreur: $message';
  }

  @override
  String get teacherHomeTitle => 'Espace Professeur';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirmTitle => 'Déconnexion';

  @override
  String get logoutConfirmMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get coursesTab => 'Courses';

  @override
  String get routesTab => 'Parcours';

  @override
  String get activeSessionsTab => 'En cours';

  @override
  String get finishRace => 'Terminer la course';

  @override
  String finishRaceConfirm(Object sessionName) {
    return 'Terminer la course \"$sessionName\" ?';
  }

  @override
  String get raceFinished => 'Course terminée';

  @override
  String get errorGeneric => 'Erreur';

  @override
  String get view => 'Voir';

  @override
  String get noActiveSessions => 'Aucune course en cours';

  @override
  String get createNewSessionToStart =>
      'Créez une nouvelle course pour commencer';

  @override
  String get noDate => 'Pas de date';

  @override
  String get sessionClosed => '✅ Session clôturée';

  @override
  String get closeSessionError => 'Erreur lors de la clôture';

  @override
  String get noCompletedSessions => 'Aucune course terminée';

  @override
  String participants(Object count) {
    return '$count participant(s)';
  }

  @override
  String duration(Object hours, Object minutes) {
    return 'Durée: ${hours}h ${minutes}min';
  }

  @override
  String get createSession => 'Créer une course';

  @override
  String get closeSession => 'Clôturer la session';

  @override
  String closeSessionConfirm(Object name) {
    return 'Voulez-vous vraiment clôturer la session \"$name\" ?\n\nCette action est irréversible.';
  }

  @override
  String get close => 'Clôturer';

  @override
  String get noCourses => 'Aucun parcours';

  @override
  String get draft => 'Brouillon';

  @override
  String get placementInProgress => 'Placement en cours';

  @override
  String get ready => 'Prêt';

  @override
  String get inProgress => 'En cours';

  @override
  String get completed => 'Terminé';

  @override
  String get archived => 'Archivé';

  @override
  String get createSessionTitle => 'Créer une course';

  @override
  String get sessionName => 'Nom de la course';

  @override
  String get sessionNameHint => 'Ex: Course du 9 décembre';

  @override
  String get selectRoute => 'Sélectionner un parcours';

  @override
  String get readyRoutes => 'Parcours prêts (plus récents en premier)';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get pleaseSelectRoute => 'Veuillez sélectionner un parcours';

  @override
  String get noReadyRoutes => 'Aucun parcours prêt';

  @override
  String get needToPlaceBeacons =>
      'Vous devez d\'abord créer et placer\nles balises d\'un parcours';

  @override
  String get back => 'Retour';

  @override
  String get noDescription => 'Pas de description';

  @override
  String get createAndLaunch => 'Créer et lancer la course';

  @override
  String get creating => 'Création...';

  @override
  String get creationError => 'Erreur lors de la création';

  @override
  String beaconsPlaced(Object placed, Object total) {
    return '$placed/$total balises placées';
  }

  @override
  String get scanner => 'Scanner';

  @override
  String get beacons => 'Balises';

  @override
  String get start => 'Départ';

  @override
  String get finish => 'Terminer';

  @override
  String get controlBeacons => 'Balises de contrôle';

  @override
  String get confirmPlacement => 'Confirmer le placement';

  @override
  String beacon(Object name) {
    return 'Balise: $name';
  }

  @override
  String get gpsPosition => 'Position GPS:';

  @override
  String get confirm => 'Confirmer';

  @override
  String beaconPlaced(Object name) {
    return '✅ $name placée';
  }

  @override
  String get placementError => 'Erreur lors du placement';

  @override
  String get allBeaconsPlaced =>
      '✅ Toutes les balises sont placées ! Parcours prêt.';

  @override
  String get gpsDisabled => 'Le GPS est désactivé. Veuillez l\'activer.';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée';

  @override
  String get locationPermissionDeniedForever =>
      'Permission de localisation refusée définitivement.';

  @override
  String get alreadyPlaced => 'Cette balise est déjà placée';

  @override
  String get cannotGetPreciseLocation =>
      'Impossible d\'obtenir une position GPS précise';

  @override
  String get scanQRCode => 'Scannez le QR code de la balise';

  @override
  String get precisePositioning => 'Positionnement précis en cours';

  @override
  String type(Object type) {
    return 'Type: $type';
  }

  @override
  String status(Object status) {
    return 'Statut: $status';
  }

  @override
  String get placed => '✅ Placée';

  @override
  String get toPlace => '⏳ À placer';

  @override
  String placedOn(Object date) {
    return 'Placée le: $date';
  }

  @override
  String get closeButton => 'Fermer';

  @override
  String get joinSession => 'Rejoindre une course';

  @override
  String get chooseJoinMethod => 'Choisissez comment rejoindre';

  @override
  String get scanQRCodeButton => 'Scanner le QR Code';

  @override
  String get scanStartBeacon => 'Scannez la balise de départ';

  @override
  String get enterCode => 'Entrer le code';

  @override
  String get enterSessionCode => 'Saisir le code de session';

  @override
  String get scanBeaconTitle => 'Scanner la balise';

  @override
  String get enterYourName => 'Entrez votre pseudo';

  @override
  String get yourName => 'Votre nom';

  @override
  String get validate => 'Valider';

  @override
  String get placeQRCodeInFrame =>
      'Placez le QR code de la balise\nde départ dans le cadre';

  @override
  String get notStartBeacon =>
      'Ce QR code ne correspond pas à une balise de départ';

  @override
  String scanError(Object error) {
    return 'Erreur lors du scan: $error';
  }

  @override
  String get enterCodeTitle => 'Entrer le code';

  @override
  String get enterCodeSubtitle => 'Saisissez le code de la course';

  @override
  String get sessionCode => 'Code de course';

  @override
  String get sessionCodeHint => 'Ex: ABC123';

  @override
  String get yourPseudo => 'Votre pseudo';

  @override
  String get yourPseudoHint => 'Ex: Jean';

  @override
  String get pleaseEnterPseudo => 'Veuillez entrer votre pseudo';

  @override
  String get pleaseEnterCode => 'Veuillez entrer le code';

  @override
  String get invalidSessionCode => 'Code de session invalide';

  @override
  String get join => 'Rejoindre';

  @override
  String raceTitle(Object name) {
    return 'Course - $name';
  }

  @override
  String get progress => 'Progression';

  @override
  String beaconsCount(Object scanned, Object total) {
    return '$scanned / $total balises';
  }

  @override
  String get scanBeacon => 'Scanner balise';

  @override
  String get congratulations => '🎉 Félicitations !';

  @override
  String get raceCompleted => 'Vous avez terminé la course !';

  @override
  String get alreadyScanned => 'Balise déjà scannée';

  @override
  String beaconScanned(Object name) {
    return 'Balise $name scannée ✓';
  }

  @override
  String get arrival => 'Arrivée';

  @override
  String get departure => 'Départ';

  @override
  String get beaconLabel => 'Balise';

  @override
  String get scanned => 'Scannée ✓';

  @override
  String get toScan => 'À scanner';
}
