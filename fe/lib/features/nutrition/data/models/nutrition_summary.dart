class NutritionSummary {
  final DateTime date;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionSummary({required this.date, required this.calories, required this.protein, required this.carbs, required this.fat});

  NutritionSummary.zero(this.date)
      : calories = 0,
        protein = 0.0,
        carbs = 0.0,
        fat = 0.0;
}
