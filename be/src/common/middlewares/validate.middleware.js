const ApiResponse = require('../response/api-response');
const { ZodError } = require('zod');

const validateDto = (schema) => {
  return (req, res, next) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const issues = error.issues;
        const errorDetails = issues.map(err => ({
          field: err.path.join('.'),
          message: err.message
        }));
        return ApiResponse.error(res, 'Validation failed', 400, errorDetails);
      }
      next(error);
    }
  };
};

module.exports = validateDto;
