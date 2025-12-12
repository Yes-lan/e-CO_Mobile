import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class ChoiceScreen extends StatelessWidget {
  const ChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo en haut
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: 150,
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(height: 60),
                  
                  // Titre
                  Text(
                    l10n.welcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00609C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.chooseProfile,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF00609C),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Bouton Professeur
                  _buildChoiceButton(
                    context,
                    icon: Icons.school,
                    title: l10n.teacher,
                    subtitle: l10n.teacherDescription,
                    color: const Color(0xFF00609C),
                    onTap: () => context.go('/teacher-login'),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bouton Participant
                  _buildChoiceButton(
                    context,
                    icon: Icons.directions_run,
                    title: l10n.participant,
                    subtitle: l10n.participantDescription,
                    color: const Color(0xFFF6731F),
                    onTap: () => context.go('/participant-join'),
                  ),
                ],
              ),
            ),
            
            // Sélecteur de langue en haut à droite
            Positioned(
              top: 16,
              right: 16,
              child: _buildLanguageSelector(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale ?? LocaleProvider.defaultLocale;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      constraints: const BoxConstraints(minWidth: 70),
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
          icon: const SizedBox.shrink(), // Cache l'icône par défaut
          style: const TextStyle(
            color: Color(0xFF00609C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Affiche seulement le drapeau dans le bouton
          selectedItemBuilder: (BuildContext context) {
            return LocaleProvider.supportedLocales.map((Locale locale) {
              final imagePath = LocaleProvider.getFlagImagePath(locale);
              final flagEmoji = LocaleProvider.getLanguageFlag(locale);
              
              return Center(
                child: imagePath != null
                    ? Image.asset(
                        imagePath,
                        width: 24,
                        height: 24,
                      )
                    : Text(
                        flagEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
              );
            }).toList();
          },
          items: LocaleProvider.supportedLocales.map((Locale locale) {
            final imagePath = LocaleProvider.getFlagImagePath(locale);
            final flagEmoji = LocaleProvider.getLanguageFlag(locale);
            
            return DropdownMenuItem<Locale>(
              value: locale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath != null)
                    Image.asset(
                      imagePath,
                      width: 24,
                      height: 24,
                    )
                  else
                    Text(
                      flagEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
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
    );
  }

  Widget _buildChoiceButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
