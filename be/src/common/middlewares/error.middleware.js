const ApiResponse = require('../response/api-response');

// eslint-disable-next-line no-unused-vars
const errorHandler = (err, req, res, next) => {
  console.error('[Error]:', err);

  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  // Handle Mongoose validation errors or duplicate keys if needed
  if (err.name === 'ValidationError') {
    return ApiResponse.error(res, 'Validation Error', 400, err.errors);
  }
  
  if (err.code === 11000) {
    return ApiResponse.error(res, 'Duplicate key error', 409, err.keyValue);
  }

  return ApiResponse.error(res, message, statusCode);
};

module.exports = errorHandler;
