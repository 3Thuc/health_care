class NutritionDayData {
  const NutritionDayData({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.meals,
  });

  final DateTime date;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final List<NutritionMealData> meals;
}

class NutritionMealData {
  const NutritionMealData({
    required this.title,
    required this.name,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final String title;
  final String name;
  final String quantity;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
}
