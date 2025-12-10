// EXEMPLE D'UTILISATION DE L'INTERNATIONALISATION
// Ce fichier montre comment utiliser le système de traduction dans votre application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/localization/localization_provider.dart';

/// Exemple 1: Utilisation basique des traductions
class SimpleTranslationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenir les traductions
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.welcome),  // Utilise la traduction localisée
      ),
      body: Center(
        child: Text(l10n.chooseProfile),  // Affiche le texte dans la langue actuelle
      ),
    );
  }
}

/// Exemple 2: Réagir aux changements de langue
class ReactiveTranslationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.language),
            actions: [
              // Afficher la langue actuelle
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    localizationProvider.isFrench ? 'FR' :
                    localizationProvider.isEnglish ? 'EN' : 'EU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Text(
              'Langue actuelle: ${_getLanguageName(localizationProvider)}',
            ),
          ),
        );
      },
    );
  }

  String _getLanguageName(LocalizationProvider provider) {
    if (provider.isFrench) return 'Français';
    if (provider.isEnglish) return 'English';
    if (provider.isBasque) return 'Euskera';
    return 'Inconnu';
  }
}

/// Exemple 3: Changer de langue programmatiquement
class ProgrammaticLanguageSwitchExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectLanguage),
      ),
      body: ListView(
        children: [
          _LanguageButton(
            flag: '🇫🇷',
            language: l10n.french,
            languageCode: 'fr',
          ),
          _LanguageButton(
            flag: '🇬🇧',
            language: l10n.english,
            languageCode: 'en',
          ),
          _LanguageButton(
            flag: '🇪🇸',
            language: l10n.basque,
            languageCode: 'eu',
          ),
        ],
      ),
    );
  }
}

/// Widget interne pour bouton de changement de langue
class _LanguageButton extends StatelessWidget {
  final String flag;
  final String language;
  final String languageCode;

  const _LanguageButton({
    required this.flag,
    required this.language,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        flag,
        style: TextStyle(fontSize: 32),
      ),
      title: Text(language),
      onTap: () {
        // Changer la langue
        Provider.of<LocalizationProvider>(context, listen: false)
            .setLanguage(languageCode);
      },
    );
  }
}

/// Exemple 4: Utiliser les traductions dans des variables
class TranslationVariablesExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Les traductions peuvent être stockées dans des variables
    final welcomeMessage = l10n.welcome;
    final profileOptions = [
      l10n.teacher,
      l10n.participant,
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(welcomeMessage),
      ),
      body: ListView.builder(
        itemCount: profileOptions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(profileOptions[index]),
          );
        },
      ),
    );
  }
}

// NOTES:
// 1. Toujours utiliser `AppLocalizations.of(context)!` pour accéder aux traductions
// 2. Le `!` à la fin est sûr car MaterialApp a les localizationsDelegates configurés
// 3. Les traductions se mettent à jour automatiquement quand AppLocalizations change
// 4. Pour ajouter une nouvelle traduction, modifiez les fichiers ARB et exécutez `flutter gen-l10n`
