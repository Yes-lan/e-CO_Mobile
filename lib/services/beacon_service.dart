import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/beacon.dart';
import 'auth_service.dart';

class BeaconService {
  final AuthService _authService = AuthService();

  // Récupérer les balises d'un parcours
  Future<List<Beacon>> getBeaconsByCourse(int courseId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.beaconsEndpoint}?course=$courseId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final beacons = (data['hydra:member'] as List)
            .map((json) => Beacon.fromJson(json))
            .toList();
        return beacons;
      } else {
        throw Exception('Erreur lors de la récupération des balises');
      }
    } catch (e) {
      print('Erreur BeaconService.getBeaconsByCourse: $e');
      rethrow;
    }
  }

  // Mettre à jour la position d'une balise
  Future<bool> updateBeaconPosition({
    required int beaconId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.beaconsEndpoint}/$beaconId'),
        headers: {
          'Content-Type': 'application/merge-patch+json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'isPlaced': true,
          'placedAt': DateTime.now().toIso8601String(),
        }),
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur BeaconService.updateBeaconPosition: $e');
      return false;
    }
  }

  // Récupérer une balise par QR code
  Future<Beacon?> getBeaconByQr(String qrCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.beaconsEndpoint}?qr=$qrCode'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final beacons = data['hydra:member'] as List;
        if (beacons.isNotEmpty) {
          return Beacon.fromJson(beacons.first);
        }
      }
      return null;
    } catch (e) {
      print('Erreur BeaconService.getBeaconByQr: $e');
      return null;
    }
  }
}
