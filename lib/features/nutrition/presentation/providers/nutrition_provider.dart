import 'package:flutter/material.dart';
import '../../data/models/meal.dart';
import '../../data/models/nutrition_summary.dart';
import '../../data/repositories/mock_meal_repository.dart';

class NutritionProvider extends ChangeNotifier {
  final MockMealRepository _repo = MockMealRepository();

  DateTime _selectedDate = DateTime(2026, 8, 13);
  bool isLoading = false;
  String? error;
  List<Meal> meals = [];

  DateTime get selectedDate => _selectedDate;

  Future<void> loadForDate(DateTime date) async {
    _selectedDate = DateTime(date.year, date.month, date.day);
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      meals = await _repo.loadMealsForDate(_selectedDate);
    } catch (e) {
      error = e.toString();
      meals = [];
    }
    isLoading = false;
    notifyListeners();
  }

  NutritionSummary calculateSummary() {
    int calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    for (final m in meals) {
      for (final f in m.foods) {
        calories += f.calories;
        protein += f.protein;
        carbs += f.carbs;
        fat += f.fat;
      }
    }
    return NutritionSummary(date: _selectedDate, calories: calories, protein: protein, carbs: carbs, fat: fat);
  }

  void addFoodToMeal(Meal meal, dynamic food) async {
    meal.foods.add(food as dynamic);
    await _repo.saveMeal(meal);
    notifyListeners();
  }

  void deleteFoodFromMeal(Meal meal, String foodId) async {
    meal.foods.removeWhere((f) => f.id == foodId);
    await _repo.saveMeal(meal);
    notifyListeners();
  }

  void updateFoodInMeal(Meal meal, dynamic newFood) async {
    final idx = meal.foods.indexWhere((f) => f.id == newFood.id);
    if (idx >= 0) meal.foods[idx] = newFood;
    await _repo.saveMeal(meal);
    notifyListeners();
  }
}
