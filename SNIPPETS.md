# Snippets rapides - Internationalisation eCO Mobile

## 🚀 Démarrage rapide

### Utiliser une traduction dans un widget
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome)  // Affiche le texte dans la langue actuelle
```

### Ajouter une nouvelle traduction en 3 étapes

**Étape 1:** Modifier `assets/l10n/app_fr.arb`
```json
{
  "myNewKey": "Mon nouveau texte en français"
}
```

**Étape 2:** Faire la même chose dans `app_en.arb` et `app_eu.arb`
```json
{
  "myNewKey": "My new text in English"
}
```

**Étape 3:** Générer les fichiers
```bash
flutter gen-l10n
```

Puis utiliser dans le code:
```dart
Text(l10n.myNewKey)
```

### Changer de langue programmatiquement
```dart
Provider.of<LocalizationProvider>(context, listen: false)
  .setLanguage('en');  // 'fr', 'en', ou 'eu'
```

### Sauvegarder la langue sélectionnée
```dart
import '../services/localization/localization_persistence.dart';

// Au démarrage:
await Provider.of<LocalizationProvider>(context, listen: false)
  .loadSavedLanguage();

// Après changement de langue:
await Provider.of<LocalizationProvider>(context, listen: false)
  .saveLanguage();
```

---

## 📝 Format des fichiers ARB

```json
{
  "@@locale": "fr",
  "@@context": "eCO Mobile",
  "key1": "Valeur 1",
  "key2": "Valeur 2",
  "description": "Cette clé est utilisée pour...",
  "nestedKey": "Valeur imbriquée"
}
```

---

## 🎨 Personnaliser le LanguageSelector

Modifier `lib/widgets/language_selector.dart` pour :
- Changer les drapeaux emoji (utiliser d'autres emojis)
- Modifier les couleurs
- Ajouter des icônes au lieu de drapeaux
- Changer le style du menu

---

## 🔍 Vérifier la langue actuelle

```dart
final provider = Provider.of<LocalizationProvider>(context);

if (provider.isFrench) {
  // Faire quelque chose pour le français
}
if (provider.isEnglish) {
  // Faire quelque chose pour l'anglais
}
if (provider.isBasque) {
  // Faire quelque chose pour le basque
}
```

---

## 📲 Utiliser dans les modèles (models)

```dart
class MyModel {
  final String key;
  
  String getLocalizedName(AppLocalizations l10n) {
    switch(key) {
      case 'teacher':
        return l10n.teacher;
      case 'participant':
        return l10n.participant;
      default:
        return key;
    }
  }
}
```

---

## 🧪 Afficher le code de la langue actuelle

```dart
// Obtenir le code de la langue (fr, en, eu)
final languageCode = Localizations.localeOf(context).languageCode;

Text('Langue: $languageCode')  // Affiche: "Langue: fr"
```

---

## 📊 Liste des clés de traduction existantes

```
- appTitle
- welcome
- chooseProfile
- teacher
- manageCourses
- participant
- joinCourse
- language
- french
- english
- basque
- selectLanguage
```

---

## ⚠️ Erreurs courantes et solutions

### Erreur: "No AppLocalizations found"
**Solution:** Assurez-vous que le widget utilisant `AppLocalizations.of(context)` est enfant du `MaterialApp` avec les `localizationsDelegates` configurés.

### Erreur: "Key not found in localizations"
**Solution:** 
1. Vérifiez que la clé existe dans tous les fichiers ARB
2. Exécutez `flutter gen-l10n`
3. Redémarrez l'application

### La traduction ne change pas quand je change de langue
**Solution:** 
1. Assurez-vous que le widget utilise `AppLocalizations.of(context)!`
2. Vérifiez que le widget est dans le Consumer ou le build du MaterialApp
3. Utilisez un Consumer<LocalizationProvider> si nécessaire

### Impossible de générer les fichiers
**Solution:**
1. Vérifiez que `l10n.yaml` existe à la racine du projet
2. Vérifiez que les fichiers ARB sont dans `assets/l10n/`
3. Exécutez `flutter pub get` puis `flutter gen-l10n`

---

## 🔗 Fichiers clés à retenir

| Fichier | Fonction |
|---------|----------|
| `assets/l10n/app_*.arb` | Fichiers de traduction |
| `lib/generated/l10n/app_localizations*.dart` | Généré automatiquement |
| `lib/services/localization/localization_provider.dart` | Gestion de l'état |
| `lib/widgets/language_selector.dart` | Sélecteur de langue |
| `l10n.yaml` | Configuration de génération |
| `main.dart` | Configuration du MaterialApp |

---

## 💾 Commandes utiles

```bash
# Générer les fichiers de localisation
flutter gen-l10n

# Vérifier qu'il n'y a pas d'erreurs
flutter analyze

# Tester sur un appareil
flutter run

# Nettoyer et régénérer
flutter clean
flutter pub get
flutter gen-l10n

# Voir la locale actuelle en debug
print(Localizations.localeOf(context))
```

---

## 🌐 Ressources

- [Documentation Flutter i18n](https://docs.flutter.dev/ui/internationalization)
- [Spécification ARB](https://github.com/google/app-resource-bundle/wiki)
- [Package intl](https://pub.dev/packages/intl)
- [Package provider](https://pub.dev/packages/provider)

---

**Dernière mise à jour:** 10 décembre 2025
**Statut:** Opérationnel ✅
