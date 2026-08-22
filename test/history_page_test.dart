import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_care/features/history/presentation/history_page.dart';

void main() {
  testWidgets('history page shows monthly calendar and meal slots', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HistoryPage()));

    expect(find.text('Lịch sử'), findsOneWidget);
    expect(find.text('Bữa 1'), findsWidgets);
    expect(find.text('Bữa 2'), findsWidgets);
  });
}
