import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_provider.dart';

/// Extension pour sauvegarder et charger la langue préférée
extension LocalizationPersistence on LocalizationProvider {
  static const String _languageKey = 'selected_language';

  /// Charger la langue sauvegardée depuis SharedPreferences
  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? 'fr';
      setLanguage(savedLanguage);
    } catch (e) {
      print('Erreur lors du chargement de la langue sauvegardée: $e');
      // Utiliser la langue par défaut en cas d'erreur
      setLanguage('fr');
    }
  }

  /// Sauvegarder la langue actuelle dans SharedPreferences
  Future<void> saveLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      print('Erreur lors de la sauvegarde de la langue: $e');
    }
  }
}
