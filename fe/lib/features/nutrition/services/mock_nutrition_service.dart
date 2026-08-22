import '../models/nutrition_day.dart';

class MockNutritionService {
  const MockNutritionService();

  List<NutritionDayData> getDays() {
    return [
      NutritionDayData(
        date: DateTime(2026, 8, 10),
        calories: 1790,
        protein: 118,
        carbs: 198,
        fat: 54,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Oatmeal Bowl', quantity: '1 bowl', calories: 360, protein: 18, carbs: 45, fat: 12),
          NutritionMealData(title: 'Lunch', name: 'Grilled Chicken', quantity: '1 serving', calories: 520, protein: 38, carbs: 35, fat: 16),
          NutritionMealData(title: 'Dinner', name: 'Rice Bowl', quantity: '1 bowl', calories: 610, protein: 24, carbs: 72, fat: 20),
          NutritionMealData(title: 'Snacks', name: 'Protein Bar', quantity: '1 bar', calories: 300, protein: 20, carbs: 24, fat: 8),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 11),
        calories: 1850,
        protein: 125,
        carbs: 210,
        fat: 55,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Chicken Sandwich', quantity: '1 serving', calories: 420, protein: 28, carbs: 42, fat: 14),
          NutritionMealData(title: 'Lunch', name: 'Salmon Bowl', quantity: '1 bowl', calories: 560, protein: 34, carbs: 48, fat: 22),
          NutritionMealData(title: 'Dinner', name: 'Pasta Primavera', quantity: '1 serving', calories: 620, protein: 24, carbs: 78, fat: 18),
          NutritionMealData(title: 'Snacks', name: 'Greek Yogurt', quantity: '1 cup', calories: 180, protein: 15, carbs: 14, fat: 8),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 12),
        calories: 1920,
        protein: 130,
        carbs: 218,
        fat: 62,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Avocado Toast', quantity: '2 slices', calories: 340, protein: 14, carbs: 30, fat: 16),
          NutritionMealData(title: 'Lunch', name: 'Turkey Wrap', quantity: '1 wrap', calories: 470, protein: 27, carbs: 46, fat: 19),
          NutritionMealData(title: 'Dinner', name: 'Salmon Rice', quantity: '1 bowl', calories: 760, protein: 32, carbs: 86, fat: 24),
          NutritionMealData(title: 'Snacks', name: 'Banana', quantity: '1 fruit', calories: 105, protein: 1, carbs: 27, fat: 0),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 13),
        calories: 1710,
        protein: 111,
        carbs: 186,
        fat: 48,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Berry Smoothie', quantity: '1 glass', calories: 280, protein: 20, carbs: 32, fat: 8),
          NutritionMealData(title: 'Lunch', name: 'Tofu Salad', quantity: '1 bowl', calories: 500, protein: 24, carbs: 38, fat: 20),
          NutritionMealData(title: 'Dinner', name: 'Steak Plate', quantity: '1 plate', calories: 740, protein: 48, carbs: 26, fat: 32),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 14),
        calories: 2010,
        protein: 139,
        carbs: 232,
        fat: 58,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Egg Omelet', quantity: '2 eggs', calories: 330, protein: 24, carbs: 8, fat: 22),
          NutritionMealData(title: 'Lunch', name: 'Chicken Pasta', quantity: '1 serving', calories: 620, protein: 35, carbs: 74, fat: 20),
          NutritionMealData(title: 'Dinner', name: 'Soba Noodles', quantity: '1 bowl', calories: 720, protein: 28, carbs: 86, fat: 24),
          NutritionMealData(title: 'Snacks', name: 'Trail Mix', quantity: '1 handful', calories: 340, protein: 12, carbs: 28, fat: 18),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 15),
        calories: 1760,
        protein: 121,
        carbs: 202,
        fat: 51,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Yogurt Parfait', quantity: '1 cup', calories: 310, protein: 16, carbs: 38, fat: 10),
          NutritionMealData(title: 'Lunch', name: 'Vegetable Soup', quantity: '1 bowl', calories: 430, protein: 18, carbs: 42, fat: 15),
          NutritionMealData(title: 'Dinner', name: 'Turkey Burger', quantity: '1 serving', calories: 720, protein: 42, carbs: 56, fat: 28),
        ],
      ),
      NutritionDayData(
        date: DateTime(2026, 8, 16),
        calories: 1880,
        protein: 128,
        carbs: 216,
        fat: 57,
        meals: const [
          NutritionMealData(title: 'Breakfast', name: 'Granola Bowl', quantity: '1 bowl', calories: 370, protein: 17, carbs: 44, fat: 12),
          NutritionMealData(title: 'Lunch', name: 'Mediterranean Salad', quantity: '1 bowl', calories: 520, protein: 26, carbs: 38, fat: 24),
          NutritionMealData(title: 'Dinner', name: 'Chicken Stir Fry', quantity: '1 serving', calories: 690, protein: 34, carbs: 66, fat: 20),
          NutritionMealData(title: 'Snacks', name: 'Cheese Cubes', quantity: '1 serving', calories: 300, protein: 20, carbs: 8, fat: 24),
        ],
      ),
    ];
  }
}
