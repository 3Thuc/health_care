const mongoose = require('mongoose');

const workoutSetSchema = new mongoose.Schema({
  setNumber: { type: Number, required: true },
  status: { 
    type: String, 
    enum: ['NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED'],
    default: 'NOT_STARTED'
  },
  setType: { type: String, enum: ['PLANNED', 'EXTRA'], default: 'PLANNED' },
  plannedReps: { type: Number },
  actualReps: { type: Number },
  plannedWeight: { type: Number },
  actualWeight: { type: Number },
  additionalWeight: { type: Number }, // For BODYWEIGHT
  unit: { type: String, default: 'kg' },
  completedAt: { type: Date },
  restSeconds: { type: Number }
}, { _id: false });

const scheduledExerciseSchema = new mongoose.Schema({
  exerciseId: { type: String, required: true, ref: 'Exercise' },
  exerciseType: { 
    type: String, 
    enum: ['STRENGTH', 'CARDIO', 'BODYWEIGHT', 'TIME_BASED'],
    required: true 
  },
  targetDurationSeconds: { type: Number },
  actualDurationSeconds: { type: Number },
  notes: { type: String, default: '' },
  targetDistanceKm: { type: Number },
  completed: { type: Boolean, default: false },
  sets: [workoutSetSchema]
}, { _id: false });

const workoutSessionSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, required: true },
  name: { type: String, required: true },
  status: { 
    type: String, 
    enum: ['PLANNED', 'IN_PROGRESS', 'COMPLETED', 'PARTIALLY_COMPLETED', 'CANCELLED'],
    default: 'PLANNED'
  },
  startedAt: { type: Date },
  completedAt: { type: Date },
  plannedDurationMinutes: { type: Number },
  actualDurationMinutes: { type: Number },
  exercises: [scheduledExerciseSchema]
}, { timestamps: true });

module.exports = mongoose.model('WorkoutSession', workoutSessionSchema);
