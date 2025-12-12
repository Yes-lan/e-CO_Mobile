import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/language_selector_widget.dart';
import '../l10n/app_localizations.dart';

class ParticipantJoinScreen extends StatelessWidget {
  const ParticipantJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swipe vers la droite = retour
          context.go('/choice');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF6731F)),
            onPressed: () => context.go('/choice'),
          ),
          actions: const [
            LanguageSelectorWidget(mode: 'appBar'),
            SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône
              const Icon(
                Icons.directions_run,
                size: 100,
                color: Color(0xFFF6731F),
              ),
              const SizedBox(height: 24),
              
              // Titre
              Text(
                AppLocalizations.of(context)!.joinSession,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6731F),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.chooseJoinMethod,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 60),
              
              // Bouton Scanner QR
              _buildJoinButton(
                context,
                icon: Icons.qr_code_scanner,
                title: AppLocalizations.of(context)!.scanQRCodeButton,
                subtitle: AppLocalizations.of(context)!.scanStartBeacon,
                onTap: () => context.go('/participant-scan'),
              ),
              
              const SizedBox(height: 24),
              
              // Bouton Entrer code
              _buildJoinButton(
                context,
                icon: Icons.keyboard,
                title: AppLocalizations.of(context)!.enterCode,
                subtitle: AppLocalizations.of(context)!.enterSessionCode,
                onTap: () => context.go('/participant-enter-code'),
              ),
            ],
          ),
        ),
      ), // Fin SafeArea
    ), // Fin Scaffold
    ); // Fin GestureDetector
  }

  Widget _buildJoinButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
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
            border: Border.all(color: const Color(0xFFF6731F), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6731F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: const Color(0xFFF6731F),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF6731F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00609C),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFF6731F),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
