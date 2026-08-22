import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _selectedDate;
  late DateTime _displayMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  List<DateTime> _buildDaysForMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysBefore = firstDay.weekday - 1;
    final totalCells = daysBefore + lastDay.day;
    final days = <DateTime>[];

    for (var i = 0; i < totalCells; i++) {
      final day = firstDay.subtract(Duration(days: daysBefore - i));
      days.add(day);
    }
    return days;
  }

  List<DateTime> _buildWeekDates(DateTime date) {
    return List.generate(7, (index) => date.add(Duration(days: index - 3)));
  }

  void _openCalendar() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1)),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        DateFormat('MMMM yyyy').format(_displayMonth),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1)),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                      .map((label) => Expanded(child: Center(child: Text(label, style: const TextStyle(fontSize: 12)))) )
                      .toList(),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: _buildDaysForMonth(_displayMonth).length,
                  itemBuilder: (context, index) {
                    final day = _buildDaysForMonth(_displayMonth)[index];
                    final isCurrentMonth = day.month == _displayMonth.month;
                    final isSelected = day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day;

                    return GestureDetector(
                      onTap: isCurrentMonth
                          ? () {
                              setState(() => _selectedDate = day);
                              widget.onDateSelected(day);
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedDate = DateTime.now());
                        widget.onDateSelected(DateTime.now());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Today'),
                    ),
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(),
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
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = _buildWeekDates(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openCalendar,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    DateFormat('MMMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 78,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final day = weekDates[index];
              final isSelected = day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day;

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDate = day);
                  widget.onDateSelected(day);
                },
                child: Container(
                  width: 56,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(day).substring(0, 3),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
