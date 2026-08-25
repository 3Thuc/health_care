const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const authRepository = require('./auth.repository');
const AuthResponseDto = require('./dto/auth-response.dto');

class AuthService {
  async register(data) {
    // Check if user exists
    const existingUser = await authRepository.findByEmail(data.email);
    if (existingUser) {
      const error = new Error('Email already in use');
      error.statusCode = 409;
      throw error;
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(data.password, salt);

    // Create user
    const user = await authRepository.create({
      ...data,
      password: hashedPassword
    });

    // Generate token
    const token = this._generateToken(user._id);

    // Map to DTO
    return AuthResponseDto.fromEntity(user, token);
  }

  async login(data) {
    // Find user
    const user = await authRepository.findByEmail(data.email);
    if (!user) {
      const error = new Error('Invalid credentials');
      error.statusCode = 401;
      throw error;
    }

    // Check password
    const isMatch = await bcrypt.compare(data.password, user.password);
    if (!isMatch) {
      const error = new Error('Invalid credentials');
      error.statusCode = 401;
      throw error;
    }

    // Generate token
    const token = this._generateToken(user._id);

    // Map to DTO
    return AuthResponseDto.fromEntity(user, token);
  }

  _generateToken(userId) {
    const secret = process.env.JWT_SECRET || 'fallback_secret_key';
    return jwt.sign({ id: userId }, secret, { expiresIn: '30d' });
  }
}

module.exports = new AuthService();
