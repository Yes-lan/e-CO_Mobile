import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';

  // Connexion professeur
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        
        // Sauvegarder le token
        await _storage.write(key: _tokenKey, value: token);
        
        // Récupérer les infos utilisateur
        final user = await getUserInfo(token);
        if (user != null) {
          await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
        }
        
        return {'success': true, 'token': token, 'user': user};
      } else {
        return {'success': false, 'message': 'Email ou mot de passe incorrect'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // Récupérer les informations de l'utilisateur connecté
  Future<User?> getUserInfo(String token) async {
    try {
      print('🔍 getUserInfo: Calling ${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}/me');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      ).timeout(ApiConfig.receiveTimeout);

      print('📥 getUserInfo: Status code ${response.statusCode}');
      print('📥 getUserInfo: Response body ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ getUserInfo: Data parsed successfully');
        final user = User.fromJson(data);
        print('✅ User: ${user.firstName} ${user.lastName}');
        return user;
      }
      print('❌ getUserInfo: Status code not 200');
      return null;
    } catch (e) {
      print('❌ Erreur lors de la récupération des infos utilisateur: $e');
      return null;
    }
  }

  // Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Récupérer le token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Récupérer l'utilisateur sauvegardé
  Future<User?> getSavedUser() async {
    print('🔍 getSavedUser: Reading user data from storage');
    final userData = await _storage.read(key: _userKey);
    
    if (userData != null) {
      print('✅ getSavedUser: User data found in storage');
      print('📄 User data: $userData');
      final user = User.fromJson(jsonDecode(userData));
      print('✅ getSavedUser: ${user.firstName} ${user.lastName}');
      return user;
    }
    
    print('❌ getSavedUser: No user data in storage');
    return null;
  }

  // Déconnexion
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
