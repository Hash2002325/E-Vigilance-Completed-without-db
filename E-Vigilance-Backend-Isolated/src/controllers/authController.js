const AuthService = require('../services/authService');

class AuthController {
  // Register endpoint
  static async register(req, res) {
    try {
      const result = await AuthService.register(req.body);
      res.status(201).json({ success: true, ...result });
    } catch (error) {
      console.error('Registration error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Registration failed'
      });
    }
  }

  // Login endpoint
  static async login(req, res) {
    try {
      const result = await AuthService.login(req.body);
      res.status(200).json({ success: true, ...result });
    } catch (error) {
      console.error('Login error:', error);
      res.status(error.status || 500).json({
        success: false,
        message: error.message || 'Login failed'
      });
    }
  }
}

module.exports = AuthController;