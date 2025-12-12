import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/session_service.dart';
import '../widgets/language_selector_widget.dart';
import '../l10n/app_localizations.dart';

class ParticipantEnterCodeScreen extends StatefulWidget {
  const ParticipantEnterCodeScreen({super.key});

  @override
  State<ParticipantEnterCodeScreen> createState() => _ParticipantEnterCodeScreenState();
}

class _ParticipantEnterCodeScreenState extends State<ParticipantEnterCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final SessionService _sessionService = SessionService();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final session = await _sessionService.getSessionByQr(_codeController.text.trim());
      
      if (!mounted) return;
      
      if (session != null) {
        // Session trouvée, démarrer la course
        context.go('/participant-race', extra: {
          'session': session,
          'runnerName': _nameController.text.trim(),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.invalidSessionCode),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.error(e)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swipe vers la droite = retour
          context.go('/participant-join');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFF6731F)),
            onPressed: () => context.go('/participant-join'),
          ),
          actions: const [
            LanguageSelectorWidget(mode: 'appBar'),
            SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Icône
                const Icon(
                  Icons.keyboard,
                  size: 80,
                  color: Color(0xFFF6731F),
                ),
                const SizedBox(height: 24),
                
                // Titre
                Text(
                  AppLocalizations.of(context)!.enterCodeTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF6731F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.enterCodeSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Champ Code
                TextFormField(
                  controller: _codeController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.sessionCode,
                    hintText: AppLocalizations.of(context)!.sessionCodeHint,
                    prefixIcon: const Icon(Icons.vpn_key, color: Color(0xFFF6731F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00609C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF6731F), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterCode;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Champ Pseudo
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.yourPseudo,
                    hintText: AppLocalizations.of(context)!.yourPseudoHint,
                    prefixIcon: const Icon(Icons.person, color: Color(0xFFF6731F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00609C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF6731F), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPseudo;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                
                // Bouton Rejoindre
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6731F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.join,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ), // Fin SafeArea
    ), // Fin Scaffold
    ); // Fin GestureDetector
  }
}
