import 'package:flutter/material.dart';
import '../services/locale_service.dart';

/// Provider pour gérer la locale de l'application
class LocaleProvider extends ChangeNotifier {
  final LocaleService _localeService = LocaleService();
  Locale? _locale;

  /// Locales supportées par l'application
  static const List<Locale> supportedLocales = [
    Locale('fr', ''), // Français
    Locale('en', ''), // Anglais
    Locale('eu', ''), // Basque
  ];

  /// Locale par défaut (français)
  static const Locale defaultLocale = Locale('fr', '');

  Locale? get locale => _locale;

  /// Initialise la locale depuis SharedPreferences
  Future<void> loadLocale() async {
    _locale = await _localeService.getSavedLocale();
    notifyListeners();
  }

  /// Change la locale et la sauvegarde
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      return;
    }

    _locale = locale;
    await _localeService.saveLocale(locale);
    notifyListeners();
  }

  /// Réinitialise la locale à la valeur par défaut
  Future<void> resetLocale() async {
    await _localeService.clearLocale();
    _locale = null;
    notifyListeners();
  }

  /// Retourne le nom de la langue dans sa propre langue
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'eu':
        return 'Euskara';
      default:
        return locale.languageCode;
    }
  }

  /// Retourne l'emoji du drapeau correspondant à la langue
  static String getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'eu':
        return '🏴'; // Drapeau basque (approximatif)
      default:
        return '🌐';
    }
  }
}
