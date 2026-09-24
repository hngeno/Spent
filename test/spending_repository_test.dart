import 'package:flutter_test/flutter_test.dart';

import 'package:spent/data/local_spending_data.dart';
import 'package:spent/repositories/spending_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads default spending data from csv source', () async {
    await loadDefaultSpendingData();

    expect(defaultSpendingData.length, 12);
    expect(defaultSpendingData.first.category, 'Rent');
    expect(defaultSpendingData.first.amount, 950);
  });

  test('aggregates repeated categories into one bar per category', () async {
    await loadDefaultSpendingData();
    const repository = SpendingRepository();

    final filtered = repository.getSpendingDataForRange(
      DateTime(2026, 8, 1),
      DateTime(2026, 9, 30),
    );

    expect(filtered.length, 6);
    expect(
      filtered.map((entry) => entry.category),
      containsAll(['Rent', 'Fees', 'Bills', 'Shopping', 'Fuel', 'Other']),
    );
    expect(
      filtered.firstWhere((entry) => entry.category == 'Rent').amount,
      1900,
    );
  });

  test('filters spending entries within the selected date range', () async {
    await loadDefaultSpendingData();
    const repository = SpendingRepository();

    final filtered = repository.getSpendingDataForRange(
      DateTime(2026, 8, 5),
      DateTime(2026, 8, 15),
    );

    expect(filtered.length, 3);
    expect(
      filtered.map((entry) => entry.category),
      containsAll(['Fees', 'Bills', 'Other']),
    );
  });
}
