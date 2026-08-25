const authService = require('./auth.service');
const ApiResponse = require('../../common/response/api-response');

class AuthController {
  async register(req, res) {
    // DTO validation is handled by middleware before reaching here
    const result = await authService.register(req.body);
    return ApiResponse.success(res, 'User registered successfully', result, 201);
  }

  async login(req, res) {
    const result = await authService.login(req.body);
    return ApiResponse.success(res, 'User logged in successfully', result);
  }
}

module.exports = new AuthController();
