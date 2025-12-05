import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../models/course.dart';
import '../models/beacon.dart';
import '../services/beacon_service.dart';

class TeacherCoursePlacementScreen extends StatefulWidget {
  final Course course;
  
  const TeacherCoursePlacementScreen({
    super.key,
    required this.course,
  });

  @override
  State<TeacherCoursePlacementScreen> createState() => _TeacherCoursePlacementScreenState();
}

class _TeacherCoursePlacementScreenState extends State<TeacherCoursePlacementScreen> {
  final BeaconService _beaconService = BeaconService();
  GoogleMapController? _mapController;
  List<Beacon> _beacons = [];
  Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBeacons();
    _getCurrentLocation();
  }

  Future<void> _loadBeacons() async {
    setState(() => _isLoading = true);
    try {
      final beacons = await _beaconService.getBeaconsByCourse(widget.course.id);
      setState(() {
        _beacons = beacons;
        _updateMarkers();
        _isLoading = false;
      });
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
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
    } catch (e) {
      print('Erreur localisation: $e');
    }
  }

  void _updateMarkers() {
    _markers = _beacons.map((beacon) {
      BitmapDescriptor icon;
      
      if (beacon.isStart) {
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else if (beacon.isEnd) {
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      } else {
        icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      }
      
      return Marker(
        markerId: MarkerId(beacon.id.toString()),
        position: LatLng(beacon.latitude, beacon.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: beacon.name,
          snippet: beacon.isPlaced ? 'Placée' : 'Non placée',
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
            Text('Type: ${beacon.type}'),
            const SizedBox(height: 8),
            Text('Statut: ${beacon.isPlaced ? "Placée" : "Non placée"}'),
            const SizedBox(height: 8),
            if (beacon.description != null) Text(beacon.description!),
          ],
        ),
        actions: [
          if (!beacon.isPlaced && _currentPosition != null)
            TextButton(
              onPressed: () => _placeBeacon(beacon),
              child: const Text('Placer ici'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _placeBeacon(Beacon beacon) async {
    if (_currentPosition == null) return;
    
    context.pop(); // Fermer le dialogue
    
    final success = await _beaconService.updateBeaconPosition(
      beaconId: beacon.id,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Balise placée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _loadBeacons(); // Recharger les balises
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du placement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        backgroundColor: const Color(0xFF00609C),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                        : const LatLng(48.8566, 2.3522), // Paris par défaut
                    zoom: 15,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) => _mapController = controller,
                ),
                
                // Légende
                Positioned(
                  top: 16,
                  left: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _legendItem(Colors.green, 'Départ'),
                          _legendItem(Colors.red, 'Arrivée'),
                          _legendItem(Colors.blue, 'Balise'),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Liste des balises non placées
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: _buildUnplacedBeaconsList(),
                ),
              ],
            ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildUnplacedBeaconsList() {
    final unplacedBeacons = _beacons.where((b) => !b.isPlaced).toList();
    
    if (unplacedBeacons.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Balises à placer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...unplacedBeacons.map((beacon) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• ${beacon.name}', style: const TextStyle(fontSize: 12)),
            )),
          ],
        ),
      ),
    );
  }
}
