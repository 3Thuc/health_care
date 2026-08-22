import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/local_storage.dart';
import 'widgets/date_header_bar.dart';
import 'widgets/date_selector_strip.dart';
import '../../food/presentation/widgets/meal_section_card.dart';
import 'widgets/nutrition_summary_panel.dart';
import 'widgets/add_food_sheet.dart';
import '../../food/presentation/food_detail_page.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  // Legacy mock days removed; using LocalStorage for per-day meals
  late DateTime _selectedDate;
  late final DateTime _today;
  late DateTime _displayMonth;
  bool _isLoading = true;
  List<Map<String, dynamic>> _selectedMeals = [];

  @override
  void initState() {
    super.initState();
    _today = DateUtils.dateOnly(DateTime.now());
    _selectedDate = _today;
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _loadMealsForDate(_selectedDate);
  }

  Future<void> _loadMealsForDate(DateTime date) async {
    setState(() => _isLoading = true);
    final meals = await LocalStorage.instance.getMealsForDate(date);
    _selectedMeals = meals;
    setState(() => _isLoading = false);
  }

  List<DateTime> _buildWeekDates(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - DateTime.monday));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  List<FoodItem> _itemsForMeal(String mealTitle) {
    // helper to convert stored maps to FoodItem list used by MealSectionCard
    final list = _selectedMeals.where((m) {
      final t = (m['meal'] as String? ?? '').toLowerCase();
      final expected = mealTitle.toLowerCase();
      if (expected == 'extras') return t == 'extras' || t == 'snacks' || t == 'snack';
      return t == expected;
    }).toList();
      return list
          .map((e) => FoodItem(
                name: e['name'] ?? '',
                quantity: e['quantity'] ?? '',
                calories: e['calories'] ?? 0,
                protein: e['protein'] ?? 0,
                carbs: e['carbs'] ?? 0,
                fat: e['fat'] ?? 0,
              ))
          .toList();
  }

  Future<void> _openFoodDetailForSection(String mealTitle, int indexInSection) async {
    // find the global index for the n'th item in the given section
    final indices = <int>[];
    for (var i = 0; i < _selectedMeals.length; i++) {
      final t = (_selectedMeals[i]['meal'] as String? ?? '').toLowerCase();
      final expected = mealTitle.toLowerCase();
      if (expected == 'extras') {
        if (t == 'extras' || t == 'snacks' || t == 'snack') indices.add(i);
      } else {
        if (t == expected) indices.add(i);
      }
    }
    if (indexInSection < 0 || indexInSection >= indices.length) return;
    final globalIndex = indices[indexInSection];
    final item = _selectedMeals[globalIndex];
    final result = await Navigator.push<Map<String, dynamic>>(context, MaterialPageRoute(builder: (_) => FoodDetailPage(item: item)));
    if (result == null) return;
    final action = result['action'] as String?;
    if (action == 'delete') {
      _selectedMeals.removeAt(globalIndex);
      await LocalStorage.instance.saveMealsForDate(_selectedDate, _selectedMeals);
      setState(() {});
    } else if (action == 'update') {
      final updated = Map<String, dynamic>.from(result['item'] as Map);
      _selectedMeals[globalIndex] = updated;
      await LocalStorage.instance.saveMealsForDate(_selectedDate, _selectedMeals);
      setState(() {});
    }
  }

  List<DateTime?> _buildMonthGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final leadingEmptyCells = firstDayOfMonth.weekday - DateTime.monday;
    final totalCells = ((leadingEmptyCells + daysInMonth + 6) ~/ 7) * 7;

    return List.generate(totalCells, (index) {
      final dayOffset = index - leadingEmptyCells + 1;
      if (dayOffset < 1 || dayOffset > daysInMonth) {
        return null;
      }
      return DateTime(month.year, month.month, dayOffset);
    });
  }

  Future<void> _openMonthYearPicker(DateTime initialMonth) async {
    final chosenMonth = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        var month = initialMonth.month;
        var year = initialMonth.year;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Chọn tháng/năm'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              final years = List.generate(11, (index) => _today.year - 5 + index);

              return Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: month,
                      decoration: const InputDecoration(labelText: 'Tháng'),
                      items: List.generate(12, (index) {
                        final value = index + 1;
                        return DropdownMenuItem(
                          value: value,
                          child: Text('Tháng $value'),
                        );
                      }),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => month = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: year,
                      decoration: const InputDecoration(labelText: 'Năm'),
                      items: years
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setDialogState(() => year = value);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(context, DateTime(year, month)),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    if (chosenMonth != null) {
      setState(() {
        _displayMonth = chosenMonth;
      });
    }
  }

  // Using persisted meals via LocalStorage; keep legacy _days mock if needed.

  void _openCalendar() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final monthGrid = _buildMonthGrid(_displayMonth);

            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        await _openMonthYearPicker(_displayMonth);
                        if (!context.mounted) return;
                        setDialogState(() {});
                      },
                      icon: const Icon(Icons.event_note_outlined),
                      label: Text(
                        DateFormat('MMMM yyyy').format(_displayMonth),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(7, (index) {
                        const weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        final label = weekdayLabels[index];
                        return Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300,
                      child: GridView.builder(
                        itemCount: monthGrid.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          final day = monthGrid[index];
                          if (day == null) return const SizedBox.shrink();

                          final isCurrentMonth = day.month == _displayMonth.month;
                          final isSelected = day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day;

                          return GestureDetector(
                            onTap: isCurrentMonth
                                ? () {
                                    setState(() {
                                      _selectedDate = day;
                                      _displayMonth = DateTime(day.year, day.month);
                                    });
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : isCurrentMonth
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate = _today;
                              _displayMonth = DateTime(_today.year, _today.month);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Today'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nutrition', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('Track your daily nutrition', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.restaurant_rounded, color: theme.colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 14),
            DateHeaderBar(
              selectedDate: _selectedDate,
              onTap: _openCalendar,
              onPreviousDay: () {
                setState(() {
                  _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                  _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
                  _loadMealsForDate(_selectedDate);
                });
              },
              onNextDay: () {
                setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                  _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
                  _loadMealsForDate(_selectedDate);
                });
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : NutritionSummaryPanel(
                    calories: _selectedMeals.fold<int>(0, (p, e) => p + (e['calories'] as int)),
                    protein: _selectedMeals.fold<int>(0, (p, e) => p + (e['protein'] as int)),
                    carbs: _selectedMeals.fold<int>(0, (p, e) => p + (e['carbs'] as int)),
                    fat: _selectedMeals.fold<int>(0, (p, e) => p + (e['fat'] as int)),
                  ),
            const SizedBox(height: 20),
            Text('Meals', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            if (!_isLoading) ...[
              MealSectionCard(
                title: 'Breakfast',
                icon: Icons.wb_sunny_outlined,
                items: _itemsForMeal('Breakfast'),
                onAddFood: () async {
                  final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => AddFoodSheet(date: _selectedDate, meal: 'Breakfast'));
                  if (result != null) {
                    final list = _selectedMeals;
                    list.add(result);
                    await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
                    setState(() => _selectedMeals = list);
                  }
                },
                onItemTap: (index) => _openFoodDetailForSection('Breakfast', index),
              ),
              const SizedBox(height: 12),
              MealSectionCard(
                title: 'Lunch',
                icon: Icons.lunch_dining_outlined,
                items: _itemsForMeal('Lunch'),
                onAddFood: () async {
                  final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => AddFoodSheet(date: _selectedDate, meal: 'Lunch'));
                  if (result != null) {
                    final list = _selectedMeals;
                    list.add(result);
                    await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
                    setState(() => _selectedMeals = list);
                  }
                },
                onItemTap: (index) => _openFoodDetailForSection('Lunch', index),
              ),
              const SizedBox(height: 12),
              MealSectionCard(
                title: 'Dinner',
                icon: Icons.dinner_dining_outlined,
                items: _itemsForMeal('Dinner'),
                onAddFood: () async {
                  final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => AddFoodSheet(date: _selectedDate, meal: 'Dinner'));
                  if (result != null) {
                    final list = _selectedMeals;
                    list.add(result);
                    await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
                    setState(() => _selectedMeals = list);
                  }
                },
                onItemTap: (index) => _openFoodDetailForSection('Dinner', index),
              ),
              const SizedBox(height: 12),
              MealSectionCard(
                title: 'Extras',
                icon: Icons.local_cafe_outlined,
                items: _itemsForMeal('Extras'),
                onAddFood: () async {
                  final result = await showModalBottomSheet<Map<String, dynamic>>(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))), builder: (_) => AddFoodSheet(date: _selectedDate, meal: 'Extras'));
                  if (result != null) {
                    final list = _selectedMeals;
                    list.add(result);
                    await LocalStorage.instance.saveMealsForDate(_selectedDate, list);
                    setState(() => _selectedMeals = list);
                  }
                },
                onItemTap: (index) => _openFoodDetailForSection('Extras', index),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
