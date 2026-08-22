import 'package:flutter_test/flutter_test.dart';
import 'package:health_care/main.dart';

void main() {
  testWidgets('app shows the welcome screen', (tester) async {
    await tester.pumpWidget(const HealthCareApp());

    expect(find.text('HealthCare'), findsOneWidget);
    expect(find.text('Your wellness companion'), findsOneWidget);
  });
}
