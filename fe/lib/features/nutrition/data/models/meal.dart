import 'food.dart';
import 'meal_type.dart';

class Meal {
  final String id;
  final DateTime date; // date only portion used
  final MealType mealType;
  final List<Food> foods;

  Meal({
    required this.id,
    required this.date,
    required this.mealType,
    List<Food>? foods,
  }) : foods = foods ?? [];

  Meal copyWith({
    String? id,
    DateTime? date,
    MealType? mealType,
    List<Food>? foods,
  }) {
    return Meal(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      foods: foods ?? List.from(this.foods),
    );
  }
}
