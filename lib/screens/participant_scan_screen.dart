import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import '../services/beacon_service.dart';
import '../models/beacon.dart';
import '../widgets/language_selector_widget.dart';
import '../l10n/app_localizations.dart';

class ParticipantScanScreen extends StatefulWidget {
  const ParticipantScanScreen({super.key});

  @override
  State<ParticipantScanScreen> createState() => _ParticipantScanScreenState();
}

class _ParticipantScanScreenState extends State<ParticipantScanScreen> {
  final BeaconService _beaconService = BeaconService();
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleQRCodeScanned(BarcodeCapture capture) {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? qrCode = barcodes.first.rawValue;
    if (qrCode == null) return;
    
    _processQRCode(qrCode);
  }

  Future<void> _processQRCode(String qrCode) async {
    setState(() => _isProcessing = true);
    
    try {
      // Vérifier si c'est une balise de départ
      final beacon = await _beaconService.getBeaconByQr(qrCode);
      
      if (beacon != null && beacon.isStart) {
        // C'est une balise de départ, demander le pseudo
        if (mounted) {
          _showNameDialog(beacon);
        }
      } else {
        _showError(AppLocalizations.of(context)!.notStartBeacon);
      }
    } catch (e) {
      _showError(AppLocalizations.of(context)!.scanError(e));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showNameDialog(Beacon beacon) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.enterYourName),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.yourName,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                context.pop();
                _startSession(beacon, name);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6731F),
            ),
            child: Text(AppLocalizations.of(context)!.validate),
          ),
        ],
      ),
    );
  }

  void _startSession(Beacon beacon, String runnerName) {
    // Navigation vers l'interface participant
    context.go('/participant-race', extra: {
      'beacon': beacon,
      'runnerName': runnerName,
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    
    // Reprendre le scan après une erreur
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
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
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.scanBeaconTitle),
          backgroundColor: const Color(0xFFF6731F),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/participant-join'),
          ),
          actions: const [
            SizedBox(width: 8),
            LanguageSelectorWidget(mode: 'appBar'),
          ],
        ),
        body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: _handleQRCodeScanned,
          ),
          
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppLocalizations.of(context)!.placeQRCodeInFrame,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          // Indicateur de traitement
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF6731F),
                ),
              ),
            ),
        ],
      ), // Fin Stack
    ), // Fin Scaffold
    ); // Fin GestureDetector
  }
}
