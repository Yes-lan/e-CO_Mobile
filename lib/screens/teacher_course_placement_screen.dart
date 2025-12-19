import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';
import '../models/course.dart';
import '../models/beacon.dart';
import '../services/waypoint_service.dart';
import '../services/course_service.dart';
import '../widgets/language_selector_widget.dart';
import '../l10n/app_localizations.dart';

class TeacherCoursePlacementScreen extends StatefulWidget {
  final Course course;

  const TeacherCoursePlacementScreen({super.key, required this.course});

  @override
  State<TeacherCoursePlacementScreen> createState() =>
      _TeacherCoursePlacementScreenState();
}

class _TeacherCoursePlacementScreenState
    extends State<TeacherCoursePlacementScreen> {
  final WaypointService _waypointService = WaypointService();
  final CourseService _courseService = CourseService();
  GoogleMapController? _mapController;
  List<Beacon> _beacons = [];
  Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = true;
  bool _isScanning = false;
  bool _mapReady = false;
  bool _beaconsLoaded = false;
  bool _completionShown = false; // Pour afficher le message une seule fois

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // D'abord obtenir la position GPS
    await _getCurrentLocation();
    // Puis charger les balises
    await _loadBeacons();
  }

  Future<void> _loadBeacons() async {
    setState(() => _isLoading = true);
    try {
      final beacons = await _waypointService.getWaypoints(widget.course.id);
      setState(() {
        _beacons = beacons;
        _updateMarkers();
        _isLoading = false;
        _beaconsLoaded = true;
      });

      print('✅ Balises chargées: ${_beacons.length}');

      // Tenter d'ajuster le zoom si la carte est prête
      _tryFitMapToBeacons();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showError(AppLocalizations.of(context)!.gpsDisabled);
        }
        return;
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            _showError(AppLocalizations.of(context)!.locationPermissionDenied);
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showError(
            AppLocalizations.of(context)!.locationPermissionDeniedForever,
          );
        }
        return;
      }

      // Une seule position pour l'init de la map (rapide)
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() => _currentPosition = position);
      }
    } catch (e) {
      print('❌ Erreur localisation: $e');
    }
  }

  // Point 3: Obtenir une position GPS très précise (20-30m) pour le placement
  Future<Position?> _getPreciseLocation() async {
    // Afficher le dialog de chargement
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false, // Ne pas fermer en cliquant à côté
        builder: (context) => const _GPSPrecisionDialog(),
      );
    }

    try {
      print('📍 Recherche de position GPS précise...');

      // Prendre plusieurs mesures et garder la meilleure
      List<Position> positions = [];
      int maxAttempts = 5;
      int attempt = 0;

      // Continuer jusqu'à avoir une précision ≤ 30m ou max 5 tentatives
      while (attempt < maxAttempts) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation,
        );
        positions.add(position);

        print(
          '📍 Tentative ${attempt + 1}/$maxAttempts - Précision: ${position.accuracy.toStringAsFixed(2)}m',
        );

        // Si on a une précision ≤ 30m, on s'arrête
        if (position.accuracy <= 30) {
          print(
            '✅ Précision excellente atteinte: ${position.accuracy.toStringAsFixed(2)}m',
          );

          // Fermer le dialog
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          return position;
        }

        attempt++;

        // Attendre un peu entre chaque mesure pour laisser le GPS se stabiliser
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(milliseconds: 800));
        }
      }

      // Prendre la meilleure des positions obtenues
      Position bestPosition = positions.reduce(
        (a, b) => a.accuracy < b.accuracy ? a : b,
      );

      print(
        '✅ Meilleure précision obtenue: ${bestPosition.accuracy.toStringAsFixed(2)}m',
      );

      // Fermer le dialog
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      return bestPosition;
    } catch (e) {
      print('❌ Erreur _getPreciseLocation: $e');

      // Fermer le dialog en cas d'erreur
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      return null;
    }
  }

  // Fonction qui vérifie si carte ET balises sont prêtes avant de zoomer
  Future<void> _tryFitMapToBeacons() async {
    if (_mapReady && _beaconsLoaded) {
      print('🎯 Carte ET balises prêtes, lancement du zoom');
      await Future.delayed(const Duration(milliseconds: 500));
      _fitMapToBeacons();
    } else {
      print('⏳ En attente: carte=$_mapReady, balises=$_beaconsLoaded');
    }
  }

  void _fitMapToBeacons() {
    if (_mapController == null) {
      print('⚠️ _fitMapToBeacons: MapController is null');
      return;
    }

    final placedBeacons = _beacons
        .where((b) => b.latitude != 0 && b.longitude != 0)
        .toList();

    print('📍 _fitMapToBeacons: ${placedBeacons.length} balises placées');

    if (placedBeacons.isEmpty) {
      if (_currentPosition != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            15,
          ),
        );
      }
      return;
    }

    if (placedBeacons.length == 1) {
      final beacon = placedBeacons.first;
      print('📍 Une seule balise, zoom à 19');
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(beacon.latitude, beacon.longitude),
          19,
        ),
      );
      return;
    }

    // Calculer les bounds
    double minLat = placedBeacons.first.latitude;
    double maxLat = placedBeacons.first.latitude;
    double minLng = placedBeacons.first.longitude;
    double maxLng = placedBeacons.first.longitude;

    for (var beacon in placedBeacons) {
      if (beacon.latitude < minLat) minLat = beacon.latitude;
      if (beacon.latitude > maxLat) maxLat = beacon.latitude;
      if (beacon.longitude < minLng) minLng = beacon.longitude;
      if (beacon.longitude > maxLng) maxLng = beacon.longitude;
    }

    print('📍 Bounds: lat($minLat, $maxLat), lng($minLng, $maxLng)');

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    final latDistance = (maxLat - minLat) * 111000;
    final lngDistance = (maxLng - minLng) * 111000;

    if (latDistance < 150 && lngDistance < 150) {
      print('📍 Balises proches, zoom fixe 19');
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(centerLat, centerLng), 19),
      );
      return;
    }

    final latDiff = (maxLat - minLat) * 0.15;
    final lngDiff = (maxLng - minLng) * 0.15;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - latDiff, minLng - lngDiff),
      northeast: LatLng(maxLat + latDiff, maxLng + lngDiff),
    );

    print('📍 Animation vers les bounds');
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 120));
  }

  void _updateMarkers() {
    _markers = _beacons.map((beacon) {
      Color markerColor;

      if (beacon.type == 'start') {
        markerColor = Colors.green; // Départ en vert
      } else if (beacon.type == 'finish' || beacon.type == 'end') {
        markerColor = Colors.red; // Fin en rouge
      } else {
        markerColor = beacon.isPlaced ? Colors.blue : const Color(0xFF00609C);
      }

      return Marker(
        markerId: MarkerId(beacon.id.toString()),
        position: LatLng(beacon.latitude, beacon.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          markerColor == Colors.green
              ? BitmapDescriptor.hueGreen
              : markerColor == Colors.red
              ? BitmapDescriptor.hueRed
              : markerColor == Colors.blue
              ? BitmapDescriptor.hueBlue
              : BitmapDescriptor.hueOrange,
        ),
        infoWindow: InfoWindow(
          title: beacon.name,
          snippet: beacon.isPlaced ? '✅ Placée' : '⏳ À placer',
        ),
        alpha: beacon.isPlaced ? 1.0 : 0.5,
        onTap: () => _showBeaconDialog(beacon),
      );
    }).toSet();
  }

  void _showBeaconDialog(Beacon beacon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(beacon.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.type(beacon.type)),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.status(
                beacon.isPlaced
                    ? AppLocalizations.of(context)!.placed
                    : AppLocalizations.of(context)!.toPlace,
              ),
            ),
            if (beacon.placedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.placedOn(
                  beacon.placedAt!.toLocal().toString().split('.')[0],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.closeButton),
          ),
        ],
      ),
    );
  }

  void _startScanner() {
    setState(() => _isScanning = true);
  }

  void _stopScanner() {
    setState(() => _isScanning = false);
  }

  bool _qrProcessing = false; // Éviter les scans multiples rapides

  Future<void> _onQrCodeDetected(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isEmpty || _qrProcessing) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    // Point 2: Éviter scan trop rapide - délai de 1 seconde
    _qrProcessing = true;
    await Future.delayed(const Duration(seconds: 1));

    _stopScanner();

    try {
      print('🔍 QR Code scanné (prof): $code');

      final qrData = jsonDecode(code);
      print('🔍 QR Data parsé: $qrData');

      //final qrType = qrData['type'] as String?;

      // Essayer d'abord waypointId (nouveau format)
      //int? waypointId = qrData['waypointId'] as int?;

      // Si pas de waypointId, essayer de deviner depuis le type (ancien format)
      //if (waypointId == null) {
        // Ancien format: type peut être START_COURSE, END_COURSE, etc.
        //print('🔍 Ancien format détecté, recherche par type: $qrType');

        // Chercher la balise par type
        //Beacon? beacon;
        //if (qrType == 'START_COURSE' ||
          //  qrType == 'START' ||
           // qrType == 'START_FINISH') {
          //beacon = _beacons.firstWhere(
          //  (b) => b.type == 'start',
          //  orElse: () => throw Exception('Balise de départ non trouvée'),
          //);
        //} else if (qrType == 'END_COURSE' || qrType == 'FINISH') {
        //  beacon = _beacons.firstWhere(
        //    (b) => b.type == 'finish',
        //    orElse: () => throw Exception('Balise d\'arrivée non trouvée'),
        //  );
        //} else {
        //  _showError('QR code invalide: type inconnu ($qrType)');
        //  return;
        //}

        //print(
        //  '🔍 Balise trouvée (ancien format): ${beacon.name}, isPlaced: ${beacon.isPlaced}',
        //);

        //if (beacon.isPlaced) {
        //  _showError(AppLocalizations.of(context)!.alreadyPlaced);
        //  _qrProcessing = false;
        //  return;
        //}

        // Point 3: Obtenir position GPS précise
        //final precisePosition = await _getPreciseLocation();

      //  if (precisePosition == null) {
      //    _showError(AppLocalizations.of(context)!.cannotGetPreciseLocation);
      //    _qrProcessing = false;
      //    return;
      //  }

      //  setState(() => _currentPosition = precisePosition);
      //  _confirmPlacement(beacon);
      //  _qrProcessing = false;
      //  return;
      //}

      // Nouveau format avec waypointId
      //print('🔍 WaypointId: $waypointId');
      //print('🔍 Recherche de la balise avec waypointId: $waypointId');
      print('🔍 Nombre de balises: ${_beacons.length}');

      // Afficher toutes les balises pour debug
      for (var b in _beacons) {
        try {
          final beaconData = jsonDecode(b.qr);
          print(
            '🔍 Balise ${b.name}',
          );
        } catch (e) {
          print('🔍 Erreur parsing balise ${b.name}: $e');
        }
      }

      // Chercher la balise par waypointId dans le JSON du QR code
      //final beacon = _beacons.firstWhere(
        //(b) {
          //try {
            //final beaconData = jsonDecode(b.qr);
            //return beaconData['waypointId'] == waypointId;
          //} catch (e) {
          //  return false;
          //}
        //},
        //orElse: () =>
           // throw Exception('Balise non trouvée (waypointId: $waypointId)'),
      //);

      //print('🔍 Balise trouvée: ${beacon.name}, isPlaced: ${beacon.isPlaced}');

      //if (beacon.isPlaced) {
       // _showError(AppLocalizations.of(context)!.alreadyPlaced);
       // _qrProcessing = false;
       // return;
      //}

      // Point 3: Obtenir position GPS précise
      final precisePosition = await _getPreciseLocation();

      if (precisePosition == null) {
        _showError(AppLocalizations.of(context)!.cannotGetPreciseLocation);
        _qrProcessing = false;
        return;
      }

      setState(() => _currentPosition = precisePosition);
      //_confirmPlacement(beacon);
      _qrProcessing = false;
    } catch (e, stackTrace) {
      print('❌ Erreur _onQrCodeDetected: $e');
      print('❌ Stack trace: $stackTrace');
      _showError('Erreur: $e');
      _qrProcessing = false;
    }
  }

  void _confirmPlacement(Beacon beacon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmPlacement),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.beacon(beacon.name)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.gpsPosition),
            Text('Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
            Text('Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _placeBeacon(beacon);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00609C),
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _placeBeacon(Beacon beacon) async {
    if (_currentPosition == null) return;

    setState(() => _isLoading = true);

    final success = await _waypointService.placeWaypoint(
      beacon.id,
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.beaconPlaced(beacon.name),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
      await _loadBeacons();

      // Vérifier si toutes les balises sont placées
      _checkCompletion();
    } else {
      _showError(AppLocalizations.of(context)!.placementError);
    }
  }

  Future<void> _checkCompletion() async {
    final placedCount = _beacons.where((b) => b.isPlaced).length;
    final totalCount = _beacons.length;

    if (placedCount == totalCount && !_completionShown && totalCount > 0) {
      _completionShown = true;

      // Afficher le message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.allBeaconsPlaced),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Mettre le statut du parcours à "ready"
      print('🎯 Mise à jour du statut du parcours à "ready"...');
      final success = await _courseService.updateCourseStatus(
        widget.course.id,
        'ready',
      );

      if (success) {
        print('✅ Statut du parcours mis à jour avec succès');
      } else {
        print('❌ Échec de la mise à jour du statut');
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final placedCount = _beacons.where((b) => b.isPlaced).length;
    final totalCount = _beacons.length;
    final progress = totalCount > 0 ? placedCount / totalCount : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.course.name),
            Text(
              AppLocalizations.of(
                context,
              )!.beaconsPlaced(placedCount, totalCount),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00609C),
        foregroundColor: Colors.white,
        actions: const [
          SizedBox(width: 8),
          LanguageSelectorWidget(mode: 'appBar'),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isScanning
          ? _buildScanner()
          : _buildMapView(progress, placedCount, totalCount),
      floatingActionButton: !_isScanning && progress < 1.0
          ? FloatingActionButton.extended(
              onPressed: _startScanner,
              backgroundColor: const Color(0xFFF6731F),
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(AppLocalizations.of(context)!.scanner),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildScanner() {
    return Stack(
      children: [
        MobileScanner(onDetect: _onQrCodeDetected),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            color: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.scanQRCode,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _stopScanner,
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(double progress, int placedCount, int totalCount) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentPosition != null
                ? LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  )
                : const LatLng(48.8566, 2.3522),
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) async {
            _mapController = controller;
            setState(() => _mapReady = true);
            print('🗺️ Carte prête');

            await Future.delayed(const Duration(milliseconds: 300));
            _tryFitMapToBeacons();
          },
        ),

        // Liste des balises au lieu de la barre de progression
        Positioned(
          top: 16,
          left: 16,
          right: 80, // Réduire largeur pour ne pas cacher le bouton recentrer
          child: Card(
            child: ExpansionTile(
              initiallyExpanded: progress < 1.0,
              title: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.beacons,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: progress >= 1.0 ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$placedCount/$totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: SingleChildScrollView(
                    child: Column(children: _buildBeaconsList()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBeaconsList() {
    // Grouper les balises par type
    final startBeacons = _beacons.where((b) => b.type == 'start').toList();
    final finishBeacons = _beacons
        .where((b) => b.type == 'finish' || b.type == 'end')
        .toList();
    final controlBeacons = _beacons
        .where(
          (b) => b.type != 'start' && b.type != 'finish' && b.type != 'end',
        )
        .toList();

    List<Widget> widgets = [];

    // Balises de départ
    if (startBeacons.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.start,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
      for (var beacon in startBeacons) {
        widgets.add(_buildBeaconListItem(beacon));
      }
    }

    // Balises de contrôle
    if (controlBeacons.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF00609C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.controlBeacons,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
      for (var beacon in controlBeacons) {
        widgets.add(_buildBeaconListItem(beacon));
      }
    }

    // Balises d'arrivée
    if (finishBeacons.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.finish,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
      for (var beacon in finishBeacons) {
        widgets.add(_buildBeaconListItem(beacon));
      }
    }

    return widgets;
  }

  Widget _buildBeaconListItem(Beacon beacon) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: Icon(
        beacon.isPlaced ? Icons.check_circle : Icons.radio_button_unchecked,
        color: beacon.isPlaced ? Colors.green : Colors.grey,
        size: 20,
      ),
      title: Text(
        beacon.name,
        style: TextStyle(
          fontSize: 14,
          color: beacon.isPlaced ? Colors.black87 : Colors.black54,
          decoration: beacon.isPlaced ? TextDecoration.none : null,
        ),
      ),
      onTap: () => _showBeaconDialog(beacon),
    );
  }
}

// Widget pour afficher le dialog de recherche GPS précise
class _GPSPrecisionDialog extends StatelessWidget {
  const _GPSPrecisionDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.gps_fixed, size: 56, color: Color(0xFF00609C)),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.precisePositioning,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00609C)),
            ),
          ],
        ),
      ),
    );
  }
}
