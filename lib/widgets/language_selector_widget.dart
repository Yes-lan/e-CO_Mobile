import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

/// Widget réutilisable pour le sélecteur de langue
/// Peut être utilisé en mode "floating" (positionné) ou "appBar" (intégré)
class LanguageSelectorWidget extends StatelessWidget {
  /// Mode d'affichage : "floating" pour un positionnement absolu avec ombre,
  /// "appBar" pour une intégration dans l'AppBar
  final String mode;
  
  const LanguageSelectorWidget({
    super.key,
    this.mode = 'floating',
  });

  /// Widget pour afficher le drapeau (emoji ou image selon la langue)
  Widget _buildFlagWidget(Locale locale, {double size = 18}) {
    final flagImagePath = LocaleProvider.getFlagImagePath(locale);
    
    if (flagImagePath != null) {
      // Afficher l'image du drapeau
      return SizedBox(
        width: size,
        height: size,
        child: Image.asset(flagImagePath),
      );
    } else {
      // Afficher l'emoji du drapeau
      return Text(
        LocaleProvider.getLanguageFlag(locale),
        style: TextStyle(fontSize: size),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale ?? LocaleProvider.defaultLocale;
    
    // Mode AppBar : version compacte pour l'intégration dans les actions de l'AppBar
    if (mode == 'appBar') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: currentLocale,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF00609C),
              size: 20,
            ),
            style: const TextStyle(
              color: Color(0xFF00609C),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            items: LocaleProvider.supportedLocales.map((Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFlagWidget(locale, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      LocaleProvider.getLanguageName(locale),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                localeProvider.setLocale(newLocale);
              }
            },
          ),
        ),
      );
    }
    
    // Mode Floating : version complète avec positionnement absolu
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00609C), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: currentLocale,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF00609C),
            ),
            style: const TextStyle(
              color: Color(0xFF00609C),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            items: LocaleProvider.supportedLocales.map((Locale locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFlagWidget(locale, size: 20),
                    const SizedBox(width: 8),
                    Text(LocaleProvider.getLanguageName(locale)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                localeProvider.setLocale(newLocale);
              }
            },
          ),
        ),
      ),
    );
  }
}
