const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const UserModel = require('../models/userModel');
require('dotenv').config();

class AuthService {
  // Register new user
  static async register(userData) {
    const { name, email, nic, password, repeatPassword } = userData;

    // Validation
    if (!name || !email || !nic || !password || !repeatPassword) {
      throw { status: 400, message: 'All fields are required' };
    }

    if (password !== repeatPassword) {
      throw { status: 400, message: 'Passwords do not match' };
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      throw { status: 400, message: 'Invalid email format' };
    }

    const nicRegex = /^(\d{9}[vVxX]|\d{12})$/;
    if (!nicRegex.test(nic)) {
      throw { status: 400, message: 'Invalid NIC format' };
    }

    if (password.length < 6) {
      throw { status: 400, message: 'Password must be at least 6 characters' };
    }

    if (UserModel.emailExists(email)) {
      throw { status: 409, message: 'Email already registered' };
    }

    if (UserModel.nicExists(nic)) {
      throw { status: 409, message: 'NIC already registered' };
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const newUser = UserModel.createUser({
      name,
      email,
      nic,
      password: hashedPassword
    });

    // Generate JWT token
    const token = this.generateToken(newUser.id);

    return {
      message: 'Registration successful',
      token,
      user: {
        id: newUser.id,
        name: newUser.name,
        email: newUser.email,
        nic: newUser.nic,
        role: newUser.role
      }
    };
  }

  // Login user
  static async login(credentials) {
    const { email, password } = credentials;

    if (!email || !password) {
      throw { status: 400, message: 'Email and password are required' };
    }

    const user = UserModel.findByEmail(email);
    if (!user) {
      throw { status: 401, message: 'Invalid email or password' };
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw { status: 401, message: 'Invalid email or password' };
    }

    const token = this.generateToken(user.id);

    return {
      message: 'Login successful',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        nic: user.nic,
        role: user.role
      }
    };
  }

  // Generate JWT token
  static generateToken(userId) {
    return jwt.sign(
      { userId },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
  }

  // Verify JWT token
  static verifyToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      throw { status: 401, message: 'Invalid or expired token' };
    }
  }
}

module.exports = AuthService;