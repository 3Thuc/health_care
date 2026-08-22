import 'package:flutter/material.dart';

import '../../../core/services/local_storage.dart';
import 'widgets/date_selector.dart';
import 'widgets/meal_section_card.dart';
import 'widgets/nutrition_summary_card.dart';
import 'food_detail_page.dart';
import '../../nutrition/presentation/widgets/add_food_sheet.dart' as nutrition_add;

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  DateTime _selectedDate = DateTime.now();

  final Map<DateTime, List<Map<String, dynamic>>> _dayData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoredMeals();
  }

  Future<void> _loadStoredMeals() async {
    setState(() => _isLoading = true);
    final storage = LocalStorage.instance;
    final defaultData = {
      '2026-08-11': [
        {'meal': 'Breakfast', 'name': 'Chicken Sandwich', 'quantity': '1 serving', 'calories': 420, 'protein': 28, 'carbs': 42, 'fat': 14},
        {'meal': 'Lunch', 'name': 'Salmon Bowl', 'quantity': '1 bowl', 'calories': 560, 'protein': 34, 'carbs': 48, 'fat': 22},
        {'meal': 'Dinner', 'name': 'Pasta Primavera', 'quantity': '1 serving', 'calories': 620, 'protein': 24, 'carbs': 78, 'fat': 18},
        {'meal': 'Snacks', 'name': 'Greek Yogurt', 'quantity': '1 cup', 'calories': 180, 'protein': 15, 'carbs': 14, 'fat': 8},
      ],
      '2026-08-12': [
        {'meal': 'Breakfast', 'name': 'Avocado Toast', 'quantity': '2 slices', 'calories': 340, 'protein': 14, 'carbs': 30, 'fat': 16},
        {'meal': 'Lunch', 'name': 'Turkey Wrap', 'quantity': '1 wrap', 'calories': 470, 'protein': 27, 'carbs': 46, 'fat': 19},
      ],
    };
    await storage.seedIfEmpty(defaultData);
    final all = await storage.readAllMeals();
    all.forEach((k, v) {
      final parts = k.split('-');
      if (parts.length == 3) {
        final y = int.tryParse(parts[0]) ?? 1970;
        final m = int.tryParse(parts[1]) ?? 1;
        final d = int.tryParse(parts[2]) ?? 1;
        _dayData[DateTime(y, m, d)] = v;
      }
    });
    setState(() => _isLoading = false);
    if (!LocalStorage.pluginAvailable && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage plugin not registered — restart app to enable persistence')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = _dayData[_selectedDate] ?? [];
    final grouped = <String, List<FoodItem>>{};
    final groupedIndices = <String, List<int>>{};

    for (var i = 0; i < meals.length; i++) {
      final item = meals[i];
      final mealTitle = item['meal'] as String;
      grouped.putIfAbsent(mealTitle, () => []);
      groupedIndices.putIfAbsent(mealTitle, () => []);
      grouped[mealTitle]!.add(FoodItem(
        name: item['name'] as String,
        quantity: item['quantity'] as String,
        calories: item['calories'] as int,
        protein: item['protein'] as int,
        carbs: item['carbs'] as int,
        fat: item['fat'] as int,
      ));
      groupedIndices[mealTitle]!.add(i);
    }

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: [
                  Text('Nutrition & History', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 14),
                  DateSelector(
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() => _selectedDate = date);
                    },
                  ),
                  const SizedBox(height: 18),
                  NutritionSummaryCard(
                    calories: meals.fold<int>(0, (p, e) => p + (e['calories'] as int)),
                    protein: meals.fold<int>(0, (p, e) => p + (e['protein'] as int)),
                    carbs: meals.fold<int>(0, (p, e) => p + (e['carbs'] as int)),
                    fat: meals.fold<int>(0, (p, e) => p + (e['fat'] as int)),
                    targetCalories: 2200,
                    targetProtein: 150,
                    targetCarbs: 250,
                    targetFat: 70,
                  ),
                  const SizedBox(height: 18),
                  MealSectionCard(
                    title: 'Breakfast',
                    icon: Icons.wb_sunny_outlined,
                    items: grouped['Breakfast'] ?? [],
                    onAddFood: () => _showAddFoodOptions('Breakfast'),
                    onItemTap: (index) {
                      final global = groupedIndices['Breakfast']?[index];
                      if (global != null) _openFoodDetail(global);
                    },
                  ),
                  const SizedBox(height: 12),
                  MealSectionCard(
                    title: 'Lunch',
                    icon: Icons.lunch_dining_outlined,
                    items: grouped['Lunch'] ?? [],
                    onAddFood: () => _showAddFoodOptions('Lunch'),
                    onItemTap: (index) {
                      final global = groupedIndices['Lunch']?[index];
                      if (global != null) _openFoodDetail(global);
                    },
                  ),
                  const SizedBox(height: 12),
                  MealSectionCard(
                    title: 'Dinner',
                    icon: Icons.dinner_dining_outlined,
                    items: grouped['Dinner'] ?? [],
                    onAddFood: () => _showAddFoodOptions('Dinner'),
                    onItemTap: (index) {
                      final global = groupedIndices['Dinner']?[index];
                      if (global != null) _openFoodDetail(global);
                    },
                  ),
                  const SizedBox(height: 12),
                  MealSectionCard(
                    title: 'Snacks',
                    icon: Icons.cookie_outlined,
                    items: grouped['Snacks'] ?? [],
                    onAddFood: () => _showAddFoodOptions('Snacks'),
                    onItemTap: (index) {
                      final global = groupedIndices['Snacks']?[index];
                      if (global != null) _openFoodDetail(global);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _showAddFoodOptions(String meal) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => nutrition_add.AddFoodSheet(date: _selectedDate, meal: meal),
    );
    if (result == null) return;
    final list = _dayData[_selectedDate] ?? [];
    list.add(result);
    _dayData[_selectedDate] = list;
    await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
    setState(() {});
  }

  Future<void> _openFoodDetail(int index) async {
    final list = _dayData[_selectedDate] ?? [];
    if (index < 0 || index >= list.length) return;
    final item = list[index];
    final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => FoodDetailPage(item: item)));
    if (result == null) return;
    final action = result['action'] as String?;
    if (action == 'delete') {
      list.removeAt(index);
      await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
      setState(() {});
    } else if (action == 'update') {
      final updated = Map<String, dynamic>.from(result['item'] as Map);
      list[index] = updated;
      await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
      setState(() {});
    }
  }
}
