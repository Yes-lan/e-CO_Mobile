import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Service pour gérer la persistance de la locale choisie par l'utilisateur
class LocaleService {
  static const String _localeKey = 'app_locale';

  /// Sauvegarde la locale choisie par l'utilisateur
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Récupère la locale sauvegardée
  /// Retourne null si aucune locale n'a été sauvegardée
  Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    
    if (languageCode == null) {
      return null;
    }
    
    return Locale(languageCode);
  }

  /// Supprime la locale sauvegardée
  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}
