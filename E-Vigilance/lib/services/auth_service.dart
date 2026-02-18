import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL - Change this based on where you're testing
  // For Android Emulator: use 10.0.2.2
  // For Physical Device: use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String nic,
    required String password,
    required String repeatPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'nic': nic,
          'password': password,
          'repeatPassword': repeatPassword,
        }),
      );

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }

  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}'
      };
    }
  }
}