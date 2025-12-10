# 🌍 Système d'Internationalisation - Vue d'ensemble visuelle

## 📱 Interface utilisateur

```
┌─────────────────────────────────────┐
│  eCO Mobile                    🇫🇷 ▼ │  ← Bouton de sélection avec drapeau
├─────────────────────────────────────┤
│                                     │
│                                     │
│              [LOGO]                 │
│                                     │
│          ✨ Bienvenue ✨            │  ← Traduit en FR/EN/EU
│                                     │
│      Choisissez votre profil        │  ← Traduit en FR/EN/EU
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🎓 Professeur              │   │  ← Textes traduits
│  │    Gérer les parcours      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏃 Participant             │   │  ← Textes traduits
│  │    Rejoindre une course    │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

## 🎨 Menu de sélection de langue

```
┌────────────────────┐
│ 🇫🇷 Français      │  ← Français
├────────────────────┤
│ 🇬🇧 English       │  ← Anglais
├────────────────────┤
│ 🇪🇸 Euskera       │  ← Basque
└────────────────────┘
```

---

## 🔄 Flux de changement de langue

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  Utilisateur clique sur le bouton de langue (🇫🇷)      │
│                   ↓                                      │
│            Menu déroulant s'ouvre                       │
│                   ↓                                      │
│     Utilisateur sélectionne une langue (🇬🇧)          │
│                   ↓                                      │
│    LocalizationProvider.setLanguage('en')              │
│                   ↓                                      │
│       Provider notifie tous les listeners               │
│                   ↓                                      │
│    MaterialApp se reconstruit avec new Locale           │
│                   ↓                                      │
│  AppLocalizations change et retourne les traductions EN │
│                   ↓                                      │
│    L'interface affiche le texte en anglais              │
│                                                          │
│  "Bienvenue" → "Welcome"                                │
│  "Choisissez votre profil" → "Choose your profile"      │
│  "Professeur" → "Teacher"                               │
│  "Participant" → "Participant"                          │
│  "Gérer les parcours" → "Manage courses"                │
│  "Rejoindre une course" → "Join a race"                 │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 🏗️ Architecture du système

```
                    ┌──────────────────┐
                    │   MaterialApp    │
                    │                  │
                    │  + locale: FR    │
                    │  + delegates: ✅ │
                    │  + Provider: ✅  │
                    └────────┬─────────┘
                             │
                    ┌────────▼──────────┐
                    │ChoiceScreen      │
                    │                  │
                    │  ┌─────────────┐ │
                    │  │Lan.Selector │ │  ← 🇫🇷 ▼
                    │  └────┬────────┘ │
                    │       │          │
                    │  ┌────▼────────┐ │
                    │  │ Text(l10n.  │ │
                    │  │   welcome)  │ │  ← "Bienvenue"
                    │  └─────────────┘ │
                    │                  │
                    └──────────────────┘
```

---

## 📂 Hiérarchie des fichiers

```
PROJECT ROOT
│
├── 📋 Configuration
│   ├── l10n.yaml ...................... (Configuration de génération)
│   └── pubspec.yaml ................... (generate: true)
│
├── 🌐 Traductions (assets/l10n/)
│   ├── app_fr.arb ..................... (Français - Template)
│   ├── app_en.arb ..................... (Anglais)
│   └── app_eu.arb ..................... (Basque)
│
├── 🔧 Code généré (lib/generated/l10n/)
│   ├── app_localizations.dart ......... (Classe principale)
│   ├── app_localizations_fr.dart ...... (Implémentation FR)
│   ├── app_localizations_en.dart ...... (Implémentation EN)
│   └── app_localizations_eu.dart ...... (Implémentation EU)
│
├── 🎮 Gestion d'état (lib/services/localization/)
│   ├── localization_provider.dart ..... (ChangeNotifier)
│   ├── localization_persistence.dart .. (Sauvegarde optionnelle)
│   └── app_strings.dart .............. (Helper optionnel)
│
├── 🎨 Interface (lib/widgets/)
│   └── language_selector.dart ......... (Bouton avec menu)
│
├── 📱 Écrans mis à jour (lib/screens/)
│   ├── choice_screen.dart ............. (Écran d'accueil)
│   └── (à mettre à jour progressivement)
│
└── 📚 Documentation
    ├── GETTING_STARTED.md ............ (Démarrage rapide)
    ├── LOCALIZATION_GUIDE.md ......... (Guide complet)
    ├── IMPLEMENTATION_SUMMARY.md ..... (Résumé technique)
    ├── CHECKLIST.md .................. (Liste des tâches)
    ├── SNIPPETS.md ................... (Code rapide)
    └── ARCHITECTURE.md ............... (Architecture détaillée)
```

---

## 🔀 Processus de traduction

```
┌────────────────────┐
│  Fichiers ARB      │  (JSON avec clés et valeurs)
│  (app_*.arb)       │
└────────┬───────────┘
         │
         │ flutter gen-l10n
         ▼
┌────────────────────┐
│  Code généré       │  (Dart - AppLocalizations)
│  (app_localizations │
│   .dart)           │
└────────┬───────────┘
         │
         │ AppLocalizations.of(context)
         ▼
┌────────────────────┐
│  Traductions dans  │  (Affichées dans l'UI)
│  l'application     │
└────────────────────┘
```

---

## 💾 Types de données

```
ARB (JSON)
─────────────
{
  "key": "Valeur texte",
  "key2": "Autre valeur"
}
      ↓
      └─ flutter gen-l10n
            ↓
         Dart (generated)
         ──────────────
         class AppLocalizations {
           String get key => "Valeur texte"
           String get key2 => "Autre valeur"
         }
```

---

## 🎯 Points d'entrée clés

```
┌─ main.dart
│  ├─ ChangeNotifierProvider<LocalizationProvider>
│  └─ MaterialApp.router
│     ├─ locale: localizationProvider.locale
│     ├─ localizationsDelegates: [AppLocalizations.delegate, ...]
│     └─ supportedLocales: AppLocalizations.supportedLocales
│
├─ choice_screen.dart
│  ├─ AppBar avec LanguageSelector
│  └─ Text(AppLocalizations.of(context)!.welcome)
│
└─ language_selector.dart
   └─ PopupMenuButton avec options FR/EN/EU
      └─ Provider.of<LocalizationProvider>().setLanguage()
```

---

## 📊 État de la locale

```
LocalizationProvider
├── locale: Locale('fr')        ← La locale actuelle
├── isFrench: bool              ← Vérifier si FR
├── isEnglish: bool             ← Vérifier si EN
├── isBasque: bool              ← Vérifier si EU
│
└── Méthodes:
    ├── setLocale(Locale)       ← Définir la locale directement
    ├── setLanguage(code)       ← Définir par code ('fr', 'en', 'eu')
    └── notifyListeners()       ← Notifier les changements
```

---

## 🎓 Exemple complet de flux

```
1. Application démarre
   └─ LocalizationProvider() créé avec locale = Locale('fr')

2. MaterialApp affiche ChoiceScreen
   ├─ AppLocalizations.of(context) retourne impl. française
   └─ Textes affichés en français

3. Utilisateur clique sur 🇬🇧
   ├─ LanguageSelector détecte le click
   └─ setLanguage('en') appelé

4. Provider notifie les listeners
   └─ locale change à Locale('en')

5. MaterialApp se reconstruit
   ├─ AppLocalizations.of(context) retourne impl. anglaise
   └─ Tous les textes se mettent à jour

6. Interface affiche l'anglais
   ├─ "Bienvenue" → "Welcome"
   ├─ "Professeur" → "Teacher"
   └─ etc.
```

---

## ✅ Vérification du système

```
□ ARB files exist and are valid JSON
   app_fr.arb, app_en.arb, app_eu.arb

□ flutter gen-l10n has been run
   lib/generated/l10n/ created with .dart files

□ LocalizationProvider is provided
   ChangeNotifierProvider in main.dart

□ AppLocalizations configured
   localizationsDelegates in MaterialApp

□ LanguageSelector works
   Can switch languages with 🇫🇷 button

□ Translations appear
   Text displays in selected language
```

---

**Généré le:** 10 décembre 2025  
**Format:** Diagrammes ASCII pour faciliter la compréhension  
**Statut:** ✅ Implémentation complète
