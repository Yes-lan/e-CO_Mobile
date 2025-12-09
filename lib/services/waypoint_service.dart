import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/beacon.dart';
import 'auth_service.dart';

class WaypointService {
  final AuthService _authService = AuthService();

  /// Récupérer les waypoints/balises d'un parcours
  Future<List<Beacon>> getWaypoints(int courseId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🔍 WaypointService.getWaypoints - CourseID: $courseId');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/parcours/$courseId/waypoints'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.receiveTimeout);

      print('🔍 WaypointService.getWaypoints - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data == null || data['waypoints'] == null) return [];
        
        final waypoints = (data['waypoints'] as List)
            .map((json) => Beacon.fromJson(json))
            .toList();
        
        print('✅ WaypointService.getWaypoints - ${waypoints.length} balises trouvées');
        return waypoints;
      } else {
        print('❌ WaypointService.getWaypoints - Erreur ${response.statusCode}');
        throw Exception('Erreur lors de la récupération des balises');
      }
    } catch (e) {
      print('❌ Erreur WaypointService.getWaypoints: $e');
      return [];
    }
  }

  /// Placer une balise avec sa position GPS
  Future<bool> placeWaypoint(int waypointId, double latitude, double longitude) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🔍 WaypointService.placeWaypoint - ID: $waypointId, Lat: $latitude, Lng: $longitude');

      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/api/waypoints/$waypointId/place'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      print('🔍 WaypointService.placeWaypoint - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ WaypointService.placeWaypoint - ${data['message']}');
        return data['success'] == true;
      } else {
        print('❌ WaypointService.placeWaypoint - Erreur ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur WaypointService.placeWaypoint: $e');
      return false;
    }
  }

  /// Marquer le parcours comme prêt (toutes les balises placées)
  Future<bool> markCourseReady(int courseId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🔍 WaypointService.markCourseReady - CourseID: $courseId');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/parcours/$courseId/mark-ready'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.connectionTimeout);

      print('🔍 WaypointService.markCourseReady - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ WaypointService.markCourseReady - ${data['message']}');
        return data['success'] == true;
      } else {
        final data = jsonDecode(response.body);
        print('❌ WaypointService.markCourseReady - ${data['error']}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur WaypointService.markCourseReady: $e');
      return false;
    }
  }
}
