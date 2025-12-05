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
        final sessions = (data['hydra:member'] as List)
            .map((json) => Session.fromJson(json))
            .toList();
        return sessions;
      } else {
        throw Exception('Erreur lors de la récupération des sessions');
      }
    } catch (e) {
      print('Erreur SessionService.getSessions: $e');
      rethrow;
    }
  }

  // Créer une nouvelle session
  Future<Session?> createSession({
    required String sessionName,
    required int courseId,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sessionsEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'sessionName': sessionName,
          'nbRunner': 0,
          'course': '/api/courses/$courseId',
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return Session.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Erreur SessionService.createSession: $e');
      return null;
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
