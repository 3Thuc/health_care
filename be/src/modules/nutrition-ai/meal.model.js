const mongoose = require('mongoose');

const foodSchema = new mongoose.Schema({
  foodId: { type: String }, // Optional reference to a global food database
  name: { type: String, required: true },
  quantity: { type: Number, required: true },
  unit: { type: String, required: true }, // e.g., 'g', 'ml', 'serving'
  calories: { type: Number, required: true },
  protein: { type: Number, required: true },
  carbs: { type: Number, required: true },
  fat: { type: Number, required: true },
  imageUrl: { type: String }
}, { _id: false });

const mealSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, required: true },
  mealType: { 
    type: String, 
    enum: ['BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'],
    required: true
  },
  foods: [foodSchema]
}, { timestamps: true });

module.exports = mongoose.model('Meal', mealSchema);
