import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportService {
  // Base URL - use 10.0.2.2 for Android Emulator, localhost for Chrome
  static const String baseUrl = 'http://10.0.2.2:5000/api/reports';

  // Create new report
  static Future<Map<String, dynamic>> createReport({
    required String token,
    required Map<String, dynamic> reportData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(reportData),
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

  // Get user's reports
  static Future<Map<String, dynamic>> getUserReports({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
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

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
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