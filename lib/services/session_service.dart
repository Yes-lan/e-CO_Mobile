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

      print('🔍 SessionService.getSessions - Chargement...');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/sessions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(ApiConfig.receiveTimeout);

      print('🔍 SessionService.getSessions - Status: ${response.statusCode}');
      print('🔍 SessionService.getSessions - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // L'API retourne {"courses": [...]}
        if (data == null) {
          print('⚠️ SessionService.getSessions - Data null');
          return [];
        }

        final sessions = data['courses'] as List?;
        if (sessions == null) {
          print('⚠️ SessionService.getSessions - courses null');
          return [];
        }

        print(
          '✅ SessionService.getSessions - ${sessions.length} sessions trouvées',
        );

        final sessionsList = sessions
            .map((json) => Session.fromJson(json))
            .toList();

        // Debug chaque session
        for (var session in sessionsList) {
          print(
            '📍 Session: ${session.sessionName}, Start: ${session.sessionStart}, End: ${session.sessionEnd}, isActive: ${session.isActive}',
          );
        }

        return sessionsList;
      } else {
        throw Exception('Erreur lors de la récupération des sessions');
      }
    } catch (e) {
      print('❌ Erreur SessionService.getSessions: $e');
      return []; // Retourner une liste vide au lieu de crash
    }
  }

  // Récupérer uniquement les sessions actives (en cours)
  Future<List<Session>> getActiveSessions() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🔍 SessionService.getActiveSessions - Chargement...');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/sessions/active'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(ApiConfig.receiveTimeout);

      print(
        '🔍 SessionService.getActiveSessions - Status: ${response.statusCode}',
      );
      print('🔍 SessionService.getActiveSessions - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data == null) {
          print('⚠️ SessionService.getActiveSessions - Data null');
          return [];
        }

        final sessions = data['courses'] as List?;
        if (sessions == null) {
          print('⚠️ SessionService.getActiveSessions - courses null');
          return [];
        }

        print(
          '✅ SessionService.getActiveSessions - ${sessions.length} sessions actives',
        );

        final sessionsList = sessions
            .map((json) => Session.fromJson(json))
            .toList();

        // Debug chaque session active
        for (var session in sessionsList) {
          print(
            '🟢 Active Session: ${session.sessionName}, Start: ${session.sessionStart}, End: ${session.sessionEnd}',
          );
        }

        return sessionsList;
      } else {
        throw Exception('Erreur lors de la récupération des sessions actives');
      }
    } catch (e) {
      print('❌ Erreur SessionService.getActiveSessions: $e');
      return [];
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

      final response = await http
          .post(
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
          )
          .timeout(ApiConfig.connectionTimeout);

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

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/sessions/$id'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(ApiConfig.receiveTimeout);

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

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/sessions/$sessionId/close'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(ApiConfig.connectionTimeout);

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
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}${ApiConfig.sessionsEndpoint}?qr=$qrCode',
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.receiveTimeout);

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
  Future<Session?> getSessionForParticipant(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/sessions/$id'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        return Session.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('❌ getSessionForParticipant: $e');
      return null;
    }
  }

  // Terminer une session
  Future<bool> endSession(int sessionId) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      print('🛑 Terminaison session: $sessionId');

      final response = await http
          .patch(
            Uri.parse('${ApiConfig.baseUrl}/api/sessions/$sessionId/end'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
            },
          )
          .timeout(ApiConfig.receiveTimeout);

      print('📡 Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Session terminée');
        return true;
      } else {
        print('❌ Erreur: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Erreur SessionService.endSession: $e');
      return false;
    }
  }
}
