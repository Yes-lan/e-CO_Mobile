import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../models/beacon.dart';
import '../models/session.dart';
import '../models/runner.dart';
import '../services/runner_service.dart';
import '../services/beacon_service.dart';
import '../services/log_session_service.dart';

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
  Set<String> _scannedBeacons = {};
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
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateMarkers() {
    _markers = _beacons.map((beacon) {
      final isScanned = _scannedBeacons.contains(beacon.qr);
      
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
      // Vérifier si la balise existe dans le parcours
      final beacon = _beacons.firstWhere(
        (b) => b.qr == qrCode,
        orElse: () => throw Exception('Balise non trouvée dans le parcours'),
      );
      
      if (_scannedBeacons.contains(qrCode)) {
        _showMessage('Balise déjà scannée', Colors.orange);
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
          _scannedBeacons.add(qrCode);
          _updateMarkers();
        });
        
        _showMessage('Balise ${beacon.name} scannée ✓', Colors.green);
        
        // Si c'est la balise d'arrivée, terminer la course
        if (beacon.isEnd) {
          await _finishRace();
        }
      }
    } catch (e) {
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
            title: const Text('🎉 Félicitations !'),
            content: const Text('Vous avez terminé la course !'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.go('/choice');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6731F),
                ),
                child: const Text('Terminer'),
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
        title: Text('Course - ${widget.runnerName}'),
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
        label: const Text('Scanner balise'),
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
                const Text(
                  'Progression',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  '${_scannedBeacons.length} / ${_beacons.length} balises',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Liste des balises
        const Text(
          'Balises',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._beacons.map((beacon) {
          final isScanned = _scannedBeacons.contains(beacon.qr);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                isScanned ? Icons.check_circle : Icons.circle_outlined,
                color: isScanned ? Colors.green : Colors.grey,
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
                    ? 'Départ'
                    : beacon.isEnd
                        ? 'Arrivée'
                        : 'Balise',
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
        title: const Text('Scanner la balise'),
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
