const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true
  },
  profile: {
    height: Number,
    weight: Number,
    goal: String
  },
  muscleScores: {
    type: Map,
    of: new mongoose.Schema({
      score: { type: Number, default: 0 },
      tier: { 
        type: String, 
        enum: ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND', 'MASTER', 'CHALLENGER'],
        default: 'BRONZE'
      }
    }, { _id: false })
  }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
