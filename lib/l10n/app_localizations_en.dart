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
}
