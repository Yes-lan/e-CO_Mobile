import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../models/beacon.dart';
import '../models/session.dart';
import '../models/runner.dart';
import '../services/runner_service.dart';
import '../services/beacon_service.dart';
import '../services/log_session_service.dart';
import '../l10n/app_localizations.dart';

class ParticipantRaceScreen extends StatefulWidget {
  final Beacon? beacon;
  final Session? session;
  final String runnerName;

  const ParticipantRaceScreen({
    super.key,
    this.beacon,
    this.session,
    required this.runnerName,
  });

  @override
  State<ParticipantRaceScreen> createState() => _ParticipantRaceScreenState();
}

class _ParticipantRaceScreenState extends State<ParticipantRaceScreen> {
  final RunnerService _runnerService = RunnerService();
  final BeaconService _beaconService = BeaconService();
  final LogSessionService _logSessionService = LogSessionService();
  
  Runner? _runner;
  List<Beacon> _beacons = [];
  final Set<String> _scannedBeacons = {};
  bool _showMap = false;
  bool _isLoading = true;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeRace();
  }

  Future<void> _initializeRace() async {
    setState(() => _isLoading = true);
    
    try {
      // Créer le runner
      int sessionId = widget.session?.id ?? 1; // À adapter selon votre logique
      final runner = await _runnerService.createRunner(
        name: widget.runnerName,
        sessionId: sessionId,
      );
      
      if (runner != null) {
        setState(() => _runner = runner);
        
        // Charger les balises du parcours
        // Note: Il faudra récupérer le courseId de la session
        if (widget.session?.courseId != null) {
          final beacons = await _beaconService.getBeaconsByCourse(
            widget.session!.courseId!,
          );
          setState(() {
            _beacons = beacons;
            _updateMarkers();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error(e)), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMarkers() {
    _markers = _beacons.map((beacon) {
      // Extraire le waypointId du QR code JSON
      int? waypointId;
      try {
        final beaconData = jsonDecode(beacon.qr);
        waypointId = beaconData['waypointId'] as int?;
      } catch (e) {
        waypointId = beacon.id;
      }
      
      final isScanned = _scannedBeacons.contains(waypointId.toString());
      
      return Marker(
        markerId: MarkerId(beacon.id.toString()),
        position: LatLng(beacon.latitude, beacon.longitude),
        icon: beacon.isStart
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            : beacon.isEnd
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        alpha: isScanned ? 0.5 : 1.0,
        infoWindow: InfoWindow(
          title: beacon.name,
          snippet: isScanned ? 'Scannée ✓' : 'À scanner',
        ),
      );
    }).toSet();
  }

  Future<void> _scanBeacon() async {
    // Ouvrir le scanner QR
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const _QRScannerView(),
      ),
    );
    
    if (result != null) {
      await _handleBeaconScanned(result);
    }
  }

  Future<void> _handleBeaconScanned(String qrCode) async {
    try {
      print('QR Code scanné (brut): $qrCode');
      
      // Parser le QR code scanné
      final scannedData = jsonDecode(qrCode);
      print('QR Code parsé: $scannedData');
      
      final scannedWaypointId = scannedData['waypointId'] as int?;
      final scannedType = scannedData['type'] as String?;
      
      print('WaypointId: $scannedWaypointId, Type: $scannedType');
      
      if (scannedWaypointId == null) {
        _showMessage('QR code invalide: waypointId manquant', Colors.red);
        return;
      }
      
      print('Nombre de balises chargées: ${_beacons.length}');
      
      // Afficher toutes les balises pour debug
      for (var b in _beacons) {
        try {
          final beaconData = jsonDecode(b.qr);
          print('Balise ${b.name}: waypointId=${beaconData['waypointId']}, type=${b.type}');
        } catch (e) {
          print('Erreur parsing balise ${b.name}: $e');
        }
      }
      
      // Chercher la balise correspondante par waypointId
      final beacon = _beacons.firstWhere(
        (b) {
          try {
            final beaconData = jsonDecode(b.qr);
            return beaconData['waypointId'] == scannedWaypointId;
          } catch (e) {
            return false;
          }
        },
        orElse: () => throw Exception('Balise non trouvée dans le parcours (waypointId: $scannedWaypointId)'),
      );
      
      print('Balise trouvée: ${beacon.name}');
      
      if (_scannedBeacons.contains(scannedWaypointId.toString())) {
        _showMessage(AppLocalizations.of(context)!.alreadyScanned, Colors.orange);
        return;
      }
      
      // Enregistrer le scan
      final position = await Geolocator.getCurrentPosition();
      final success = await _logSessionService.logBeaconScan(
        runnerId: _runner!.id,
        beaconQr: qrCode,
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      if (success) {
        setState(() {
          _scannedBeacons.add(scannedWaypointId.toString());
          _updateMarkers();
        });
        
        _showMessage(AppLocalizations.of(context)!.beaconScanned(beacon.name), Colors.green);
        
        // Si c'est la balise d'arrivée, terminer la course
        if (beacon.isEnd || scannedType == 'FINISH' || scannedType == 'START_FINISH') {
          await _finishRace();
        }
      }
    } catch (e, stackTrace) {
      print('Erreur handleBeaconScanned: $e');
      print('Stack trace: $stackTrace');
      _showMessage('Erreur: $e', Colors.red);
    }
  }

  Future<void> _finishRace() async {
    if (_runner != null) {
      await _runnerService.finishRunner(_runner!.id);
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.congratulations),
            content: Text(AppLocalizations.of(context)!.raceCompleted),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.go('/choice');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6731F),
                ),
                child: Text(AppLocalizations.of(context)!.finish),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.raceTitle(widget.runnerName)),
        backgroundColor: const Color(0xFFF6731F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () {
              setState(() => _showMap = !_showMap);
            },
          ),
        ],
      ),
      body: _showMap ? _buildMapView() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanBeacon,
        backgroundColor: const Color(0xFFF6731F),
        icon: const Icon(Icons.qr_code_scanner),
        label: Text(AppLocalizations.of(context)!.scanBeacon),
      ),
    );
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _beacons.isNotEmpty
            ? LatLng(_beacons.first.latitude, _beacons.first.longitude)
            : const LatLng(48.8566, 2.3522),
        zoom: 15,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (controller) => _mapController = controller,
    );
  }

  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Progression
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.progress,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _beacons.isEmpty
                      ? 0
                      : _scannedBeacons.length / _beacons.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF6731F)),
                  minHeight: 10,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.beaconsCount(_scannedBeacons.length, _beacons.length),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Liste des balises
        Text(
          AppLocalizations.of(context)!.beacons,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._beacons.map((beacon) {
          final isScanned = _scannedBeacons.contains(beacon.qr);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                isScanned ? Icons.check_circle : Icons.circle_outlined,
                color: isScanned ? Colors.green : const Color(0xFF00609C),
                size: 32,
              ),
              title: Text(
                beacon.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: isScanned ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                beacon.isStart
                    ? AppLocalizations.of(context)!.departure
                    : beacon.isEnd
                        ? AppLocalizations.of(context)!.arrival
                        : AppLocalizations.of(context)!.beaconLabel,
              ),
              trailing: isScanned
                  ? const Icon(Icons.done, color: Colors.green)
                  : null,
            ),
          );
        }),
      ],
    );
  }
}

// Vue du scanner QR
class _QRScannerView extends StatefulWidget {
  const _QRScannerView();

  @override
  State<_QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<_QRScannerView> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? code = barcodes.first.rawValue;
    if (code != null) {
      controller.dispose();
      context.pop(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanBeaconTitle),
        backgroundColor: const Color(0xFFF6731F),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _onDetect,
      ),
    );
  }
}
