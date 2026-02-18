const AuthService = require('../services/authService');
const UserModel = require('../models/userModel');

class AuthMiddleware {
  // Verify JWT token from request
  static verifyToken(req, res, next) {
    try {
      const authHeader = req.headers.authorization;
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({
          success: false,
          message: 'Access denied. No token provided.'
        });
      }

      const token = authHeader.substring(7);
      const decoded = AuthService.verifyToken(token);
      const user = UserModel.findById(decoded.userId);
      
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Invalid token. User not found.'
        });
      }

      req.user = user;
      next();
    } catch (error) {
      console.error('Token verification error:', error);
      return res.status(401).json({
        success: false,
        message: error.message || 'Invalid or expired token'
      });
    }
  }
}

module.exports = AuthMiddleware;