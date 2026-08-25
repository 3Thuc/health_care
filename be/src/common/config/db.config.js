const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGO_URI || 'mongodb+srv://thuctran200411_db_user:VFedIYmiRgztjBtO@cluster0thucdev.qqmhhjq.mongodb.net/Health_care?appName=Cluster0ThucDev';
    await mongoose.connect(mongoURI);
    console.log('[DB] MongoDB Connected Successfully');
  } catch (error) {
    console.error('[DB] MongoDB Connection Failed:', error.message);
    process.exit(1);
  }
};

module.exports = connectDB;
