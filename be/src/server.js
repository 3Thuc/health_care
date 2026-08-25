require('dotenv').config();
const app = require('./app');
const connectDB = require('./common/config/db.config');

const PORT = process.env.PORT || 5000;

const startServer = async () => {
  // Connect to Database
  await connectDB();

  // Start Express server
  app.listen(PORT, () => {
    console.log(`[Server] Running on port ${PORT}`);
  });
};

startServer();
