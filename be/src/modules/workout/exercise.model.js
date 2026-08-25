const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema({
  _id: { type: String, required: true }, // e.g., "bench_press" (slug)
  name: { type: String, required: true },
  description: { type: String },
  targetMuscle: { type: String, required: true }, // e.g., "chest"
  difficulty: { type: String, enum: ['BEGINNER', 'INTERMEDIATE', 'ADVANCED'] },
  equipment: { type: String },
  icon: { type: String },
  type: { 
    type: String, 
    enum: ['STRENGTH', 'CARDIO', 'BODYWEIGHT', 'TIME_BASED'],
    default: 'STRENGTH'
  },
  instructions: [{ type: String }],
  tips: [{ type: String }],
  commonMistakes: [{ type: String }]
}, { timestamps: true });

module.exports = mongoose.model('Exercise', exerciseSchema);
