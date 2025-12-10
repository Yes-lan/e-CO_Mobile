import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Classe pour accéder aux strings traduites
class AppStrings {
  static String get appTitle => Intl.message(
        'eCO - Course d\'Orientation',
        name: 'appTitle',
        locale: Intl.getCurrentLocale(),
      );

  static String get welcome => Intl.message(
        'Bienvenue',
        name: 'welcome',
        locale: Intl.getCurrentLocale(),
      );

  static String get chooseProfile => Intl.message(
        'Choisissez votre profil',
        name: 'chooseProfile',
        locale: Intl.getCurrentLocale(),
      );

  static String get teacher => Intl.message(
        'Professeur',
        name: 'teacher',
        locale: Intl.getCurrentLocale(),
      );

  static String get manageCourses => Intl.message(
        'Gérer les parcours et courses',
        name: 'manageCourses',
        locale: Intl.getCurrentLocale(),
      );

  static String get participant => Intl.message(
        'Participant',
        name: 'participant',
        locale: Intl.getCurrentLocale(),
      );

  static String get joinCourse => Intl.message(
        'Rejoindre une course',
        name: 'joinCourse',
        locale: Intl.getCurrentLocale(),
      );

  static String get language => Intl.message(
        'Langue',
        name: 'language',
        locale: Intl.getCurrentLocale(),
      );

  static String get french => Intl.message(
        'Français',
        name: 'french',
        locale: Intl.getCurrentLocale(),
      );

  static String get english => Intl.message(
        'English',
        name: 'english',
        locale: Intl.getCurrentLocale(),
      );

  static String get basque => Intl.message(
        'Euskera',
        name: 'basque',
        locale: Intl.getCurrentLocale(),
      );

  static String get selectLanguage => Intl.message(
        'Sélectionner la langue',
        name: 'selectLanguage',
        locale: Intl.getCurrentLocale(),
      );
}
