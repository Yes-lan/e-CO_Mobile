import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/session.dart';
import 'auth_service.dart';

class SessionService {
  final AuthService _authService = AuthService();

  // Récupérer toutes les sessions
  Future<List<Session>> getSessions() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sessionsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Gérer le cas où hydra:member n'existe pas ou est null
        if (data == null) return [];
        
        final member = data['hydra:member'];
        if (member == null) return [];
        
        final sessions = (member as List)
            .map((json) => Session.fromJson(json))
            .toList();
        return sessions;
      } else {
        throw Exception('Erreur lors de la récupération des sessions');
      }
    } catch (e) {
      print('Erreur SessionService.getSessions: $e');
      return []; // Retourner une liste vide au lieu de crash
    }
  }

  // Créer et démarrer une nouvelle session
  Future<Session?> createSession({
    required String sessionName,
    required int courseId,
    bool autoStart = true,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🎯 Creating session: $sessionName for course: $courseId');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/sessions/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'sessionName': sessionName,
          'parcoursId': courseId,
          'nbRunners': 0,
          'autoStart': autoStart,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      print('🎯 Response status: ${response.statusCode}');
      print('🎯 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['id'] != null) {
          // Récupérer la session complète
          return getSession(data['id']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Erreur SessionService.createSession: $e');
      return null;
    }
  }

  // Récupérer une session par ID
  Future<Session?> getSession(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/sessions/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        return Session.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('❌ Erreur SessionService.getSession: $e');
      return null;
    }
  }

  // Clôturer une session
  Future<bool> closeSession(int sessionId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🔒 Closing session: $sessionId');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/sessions/$sessionId/close'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.connectionTimeout);

      print('🔒 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Erreur SessionService.closeSession: $e');
      return false;
    }
  }

  // Récupérer une session par code QR (pour participants)
  Future<Session?> getSessionByQr(String qrCode) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sessionsEndpoint}?qr=$qrCode'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessions = data['hydra:member'] as List;
        if (sessions.isNotEmpty) {
          return Session.fromJson(sessions.first);
        }
      }
      return null;
    } catch (e) {
      print('Erreur SessionService.getSessionByQr: $e');
      return null;
    }
  }
}
