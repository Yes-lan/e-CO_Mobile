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

      print('🔍 CourseService.getCourses - URL: ${ApiConfig.baseUrl}${ApiConfig.coursesEndpoint}');
      print('🔍 CourseService.getCourses - Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.coursesEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.receiveTimeout);

      print('🔍 CourseService.getCourses - Status: ${response.statusCode}');
      print('🔍 CourseService.getCourses - Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Votre API retourne {"courses": [...]} au lieu de {"hydra:member": [...]}
        if (data == null) return [];
        
        final coursesData = data['courses']; // Au lieu de 'hydra:member'
        if (coursesData == null) return [];
        
        final courses = (coursesData as List)
            .map((json) => Course.fromJson(json))
            .toList();
        
        print('✅ CourseService.getCourses - ${courses.length} parcours trouvés');
        return courses;
      } else {
        print('❌ CourseService.getCourses - Erreur ${response.statusCode}: ${response.body}');
        throw Exception('Erreur lors de la récupération des parcours');
      }
    } catch (e) {
      print('❌ Erreur CourseService.getCourses: $e');
      return []; // Retourner une liste vide au lieu de crash
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
