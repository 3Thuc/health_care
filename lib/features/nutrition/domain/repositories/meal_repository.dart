import '../../data/models/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> loadMealsForDate(DateTime date);
  Future<void> saveMeal(Meal meal);
  Future<void> deleteFood(String mealId, String foodId);
  Future<void> addFood(String mealId, dynamic food);
}
