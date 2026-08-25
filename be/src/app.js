require('express-async-errors'); // Catch async errors automatically
const express = require('express');
const cors = require('cors');

const authRoutes = require('./modules/auth/auth.routes');
const errorHandler = require('./common/middlewares/error.middleware');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

// Catch-all route for 404 Not Found
app.use((req, res, next) => {
  const error = new Error(`Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
});

// Centralized Error Handling Middleware
app.use(errorHandler);

module.exports = app;
