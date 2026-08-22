class MealItem {
  const MealItem({
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String icon;
  final int color;
}
