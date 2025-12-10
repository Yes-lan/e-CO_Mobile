# Guide d'Internationalisation (i18n) - eCO Mobile

## Vue d'ensemble

L'application eCO Mobile supporte maintenant 3 langues :
- 🇫🇷 **Français** (par défaut)
- 🇬🇧 **Anglais**
- 🇪🇸 **Basque**

## Structure des fichiers

```
assets/l10n/
├── app_fr.arb          # Traductions en français (fichier de référence)
├── app_en.arb          # Traductions en anglais
└── app_eu.arb          # Traductions en basque

lib/
├── generated/l10n/     # Fichiers générés automatiquement
│   ├── app_localizations.dart       # Classe principale générée
│   ├── app_localizations_fr.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_eu.dart
├── services/localization/
│   └── localization_provider.dart   # Provider pour gérer la locale
└── widgets/
    └── language_selector.dart       # Widget de sélection de langue
```

## Comment utiliser les traductions dans votre code

### 1. Dans un Widget/Screen

```dart
import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenir les traductions localisées
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),  // Utiliser la traduction
      ),
      body: Center(
        child: Text(l10n.welcome),   // Utiliser une autre traduction
      ),
    );
  }
}
```

### 2. Changer de langue avec le sélecteur

Un widget `LanguageSelector` est disponible en haut à droite de l'écran d'accueil. 
Il permet de sélectionner facilement la langue avec les drapeaux emoji associés.

## Comment ajouter une nouvelle traduction

### 1. Ajouter le texte aux fichiers ARB

Modifiez les fichiers dans `assets/l10n/`:

**app_fr.arb :**
```json
{
  "@@locale": "fr",
  "myNewString": "Mon nouveau texte en français"
}
```

**app_en.arb :**
```json
{
  "@@locale": "en",
  "myNewString": "My new text in English"
}
```

**app_eu.arb :**
```json
{
  "@@locale": "eu",
  "myNewString": "Nire testu berria Euskeraz"
}
```

### 2. Générer les fichiers de localisation

Exécutez cette commande après avoir modifié les fichiers ARB :

```bash
flutter gen-l10n
```

Cela générera automatiquement les fichiers dans `lib/generated/l10n/`.

### 3. Utiliser la nouvelle traduction dans votre code

```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.myNewString)  // Affichera le texte localisé
```

## Architecture

### LocalizationProvider

Gère l'état de la locale sélectionnée et notifie l'application lors d'un changement.

**Méthodes principales :**
- `setLocale(Locale locale)` : Définir la locale
- `setLanguage(String languageCode)` : Définir la langue par code (fr, en, eu)
- `isFrench` / `isEnglish` / `isBasque` : Vérifier la langue actuelle

**Exemple d'utilisation :**
```dart
Provider.of<LocalizationProvider>(context, listen: false)
  .setLanguage('en');  // Changer à l'anglais
```

### LanguageSelector

Widget de sélection de langue avec menu déroulant et drapeaux emoji.

**Localisation :**
- 🇫🇷 Français
- 🇬🇧 Anglais
- 🇪🇸 Basque (représenté par le drapeau espagnol)

## Points importants

1. **Fichier de référence** : `app_fr.arb` est le template - tous les autres fichiers doivent contenir les mêmes clés.

2. **Génération automatique** : Après chaque modification des fichiers ARB, exécutez `flutter gen-l10n`.

3. **Type-safe** : Les traductions sont accessibles via des propriétés générées (ex: `l10n.welcome`) - erreur détectée à la compilation.

4. **Persistance** : Actuellement, le choix de langue n'est pas persisté. Pour persister le choix, vous pouvez utiliser `shared_preferences` (déjà dans les dépendances).

## Prochaines étapes

Pour améliorer le système :

1. **Sauvegarder la langue sélectionnée** avec SharedPreferences
2. **Ajouter plus de traductions** au fur et à mesure du développement
3. **Tester chaque langue** régulièrement
4. **Évaluer la traduction** auprès de locuteurs natifs (surtout pour le basque)

## Ressources

- Documentation Flutter i18n : https://docs.flutter.dev/ui/internationalization
- Format ARB : https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification
