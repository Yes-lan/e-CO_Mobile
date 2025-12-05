import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/course.dart';
import 'auth_service.dart';

class CourseService {
  final AuthService _authService = AuthService();

  // Récupérer tous les parcours du professeur connecté
  Future<List<Course>> getCourses() async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.coursesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final courses = (data['hydra:member'] as List)
            .map((json) => Course.fromJson(json))
            .toList();
        return courses;
      } else {
        throw Exception('Erreur lors de la récupération des parcours');
      }
    } catch (e) {
      print('Erreur CourseService.getCourses: $e');
      rethrow;
    }
  }

  // Récupérer un parcours spécifique
  Future<Course?> getCourse(int id) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Non authentifié');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.coursesEndpoint}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        return Course.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Erreur CourseService.getCourse: $e');
      return null;
    }
  }
}
