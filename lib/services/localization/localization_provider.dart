import 'package:flutter/material.dart';

class LocalizationProvider extends ChangeNotifier {
  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  bool get isFrench => _locale.languageCode == 'fr';
  bool get isEnglish => _locale.languageCode == 'en';
  bool get isBasque => _locale.languageCode == 'eu';

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void setLanguage(String languageCode) {
    final newLocale = Locale(languageCode);
    setLocale(newLocale);
  }

  static const List<Locale> supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('eu'),
  ];

  static const Locale fallbackLocale = Locale('fr');
}
