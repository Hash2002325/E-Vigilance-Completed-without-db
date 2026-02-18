// Simple in-memory token storage
// In production, use flutter_secure_storage or shared_preferences

class TokenStorage {
  static String? _token;
  static Map<String, dynamic>? _user;

  // Save token and user data
  static void saveToken(String token, Map<String, dynamic> user) {
    _token = token;
    _user = user;
  }

  // Get token
  static String? getToken() {
    return _token;
  }

  // Get user data
  static Map<String, dynamic>? getUser() {
    return _user;
  }

  // Check if logged in
  static bool isLoggedIn() {
    return _token != null;
  }

  // Clear token (logout)
  static void clearToken() {
    _token = null;
    _user = null;
  }
}