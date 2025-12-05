import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/log_session.dart';

class LogSessionService {
  // Enregistrer un scan de balise
  Future<bool> logBeaconScan({
    required int runnerId,
    required String beaconQr,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logSessionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'beacon_scan',
          'time': DateTime.now().toIso8601String(),
          'latitude': latitude,
          'longitude': longitude,
          'additionalData': jsonEncode({'beaconQr': beaconQr}),
          'runner': '/api/runners/$runnerId',
        }),
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 201;
    } catch (e) {
      print('Erreur LogSessionService.logBeaconScan: $e');
      return false;
    }
  }

  // Récupérer les logs d'un participant
  Future<List<LogSession>> getRunnerLogs(int runnerId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logSessionsEndpoint}?runner=$runnerId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final logs = (data['hydra:member'] as List)
            .map((json) => LogSession.fromJson(json))
            .toList();
        return logs;
      }
      return [];
    } catch (e) {
      print('Erreur LogSessionService.getRunnerLogs: $e');
      return [];
    }
  }
}
