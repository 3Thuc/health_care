import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/meal_repository.dart';
import '../models/meal.dart';
import '../models/food.dart';
import '../models/meal_type.dart';

class MockMealRepository implements MealRepository {
  final Map<String, List<Meal>> _storage = {};
  final _uuid = const Uuid();

  MockMealRepository() {
    _seed();
  }

  void _seed() {
    // create several dates
    final base = DateTime(2026, 8, 13);
    for (var i = -3; i <= 3; i++) {
      final d = DateTime(base.year, base.month, base.day + i);
      final key = _key(d);
      _storage[key] = [
        Meal(id: _uuid.v4(), date: d, mealType: MealType.breakfast, foods: [
          Food(id: _uuid.v4(), name: 'Chicken sandwich', quantity: 1, unit: 'serving', calories: 420, protein: 28, carbs: 42, fat: 14, imageUrl: null),
        ]),
        Meal(id: _uuid.v4(), date: d, mealType: MealType.lunch, foods: [
          Food(id: _uuid.v4(), name: 'Salmon bowl', quantity: 1, unit: 'serving', calories: 560, protein: 34, carbs: 48, fat: 22),
        ]),
        Meal(id: _uuid.v4(), date: d, mealType: MealType.dinner, foods: [
          Food(id: _uuid.v4(), name: 'Pasta primavera', quantity: 1, unit: 'serving', calories: 620, protein: 24, carbs: 78, fat: 18),
        ]),
        Meal(id: _uuid.v4(), date: d, mealType: MealType.extras, foods: [
          Food(id: _uuid.v4(), name: 'Iced coffee', quantity: 1, unit: 'cup', calories: 180, protein: 1, carbs: 15, fat: 8),
        ]),
      ];
    }
  }

  String _key(DateTime d) => '${d.year}-${d.month}-${d.day}';

  @override
  Future<List<Meal>> loadMealsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final key = _key(date);
    final list = _storage[key];
    if (list != null) return List.from(list);
    // return default empty 4 sections
    return [
      Meal(id: _uuid.v4(), date: date, mealType: MealType.breakfast),
      Meal(id: _uuid.v4(), date: date, mealType: MealType.lunch),
      Meal(id: _uuid.v4(), date: date, mealType: MealType.dinner),
      Meal(id: _uuid.v4(), date: date, mealType: MealType.extras),
    ];
  }

  @override
  Future<void> saveMeal(Meal meal) async {
    final key = _key(meal.date);
    final list = _storage[key] ?? [];
    final idx = list.indexWhere((m) => m.mealType == meal.mealType);
    if (idx >= 0) {
      list[idx] = meal;
    } else {
      list.add(meal);
    }
    _storage[key] = list;
  }

  @override
  Future<void> deleteFood(String mealId, String foodId) async {
    for (final entry in _storage.entries) {
      for (final m in entry.value) {
        if (m.id == mealId) {
          m.foods.removeWhere((f) => f.id == foodId);
        }
      }
    }
  }

  @override
  Future<void> addFood(String mealId, dynamic food) async {
    for (final entry in _storage.entries) {
      for (final m in entry.value) {
        if (m.id == mealId) {
          m.foods.add(food as Food);
          return;
        }
      }
    }
  }
}
