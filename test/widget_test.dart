import 'package:flutter_test/flutter_test.dart';

import 'package:spent/data/local_spending_data.dart';
import 'package:spent/main.dart';
import 'package:spent/widgets/date_picker_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows date range inputs, chart, and start button', (
    tester,
  ) async {
    await loadDefaultSpendingData();
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Start Date'), findsOneWidget);
    expect(find.text('End Date'), findsOneWidget);
    expect(find.text('Spending by Category'), findsOneWidget);
    expect(find.byType(DatePickerTile), findsNWidgets(2));
    expect(find.textContaining(r'$'), findsNothing);
    expect(find.text('950'), findsOneWidget);
  });
}
