const express = require('express');
const router = express.Router();

const authController = require('./auth.controller');
const validateDto = require('../../common/middlewares/validate.middleware');
const { registerDto, loginDto } = require('./dto/auth-request.dto');

// Route: POST /api/auth/register
// Middleware: Validate input using Zod DTO
router.post('/register', validateDto(registerDto), authController.register);

// Route: POST /api/auth/login
// Middleware: Validate input using Zod DTO
router.post('/login', validateDto(loginDto), authController.login);

module.exports = router;
