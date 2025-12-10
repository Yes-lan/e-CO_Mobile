import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/localization/localization_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationProvider>(
      builder: (context, localizationProvider, _) {
        return PopupMenuButton<String>(
          onSelected: (languageCode) {
            localizationProvider.setLanguage(languageCode);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'fr',
              child: Row(
                children: [
                  const Text(
                    '🇫🇷',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Français'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: [
                  const Text(
                    '🇬🇧',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('English'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'eu',
              child: Row(
                children: [
                  const Text(
                    '🏴',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Euskera'),
                ],
              ),
            ),
          ],
          padding: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              _getFlagForLocale(localizationProvider.locale.languageCode),
              style: const TextStyle(fontSize: 28),
            ),
          ),
        );
      },
    );
  }

  String _getFlagForLocale(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return '🇫🇷';
      case 'en':
        return '🇬🇧';
      case 'eu':
        return '🏴';
      default:
        return '🇫🇷';
    }
  }
}
