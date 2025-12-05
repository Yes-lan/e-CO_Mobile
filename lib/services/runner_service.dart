import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/runner.dart';

class RunnerService {
  // Créer un nouveau participant
  Future<Runner?> createRunner({
    required String name,
    required int sessionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.runnersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'departure': DateTime.now().toIso8601String(),
          'session': '/api/sessions/$sessionId',
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return Runner.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Erreur RunnerService.createRunner: $e');
      return null;
    }
  }

  // Terminer la course d'un participant
  Future<bool> finishRunner(int runnerId) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.runnersEndpoint}/$runnerId'),
        headers: {'Content-Type': 'application/merge-patch+json'},
        body: jsonEncode({
          'arrival': DateTime.now().toIso8601String(),
        }),
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur RunnerService.finishRunner: $e');
      return false;
    }
  }
}
