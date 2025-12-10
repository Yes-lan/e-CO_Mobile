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
}
