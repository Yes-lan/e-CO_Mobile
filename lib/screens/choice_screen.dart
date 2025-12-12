import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../widgets/language_selector_widget.dart';

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
            const LanguageSelectorWidget(mode: 'floating'),
          ],
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
