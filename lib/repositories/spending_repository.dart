import '../data/local_spending_data.dart';
import '../models/spending_chart_data.dart';

class SpendingRepository {
  const SpendingRepository();

  List<SpendingChartDatum> getSpendingData() {
    return defaultSpendingData;
  }

  List<SpendingChartDatum> getSpendingDataForRange(
    DateTime start,
    DateTime end,
  ) {
    final rowsInRange = getSpendingData()
        .where((entry) => entry.isWithinRange(start, end))
        .toList();

    final grouped = <String, SpendingChartDatum>{};

    for (final row in rowsInRange) {
      final existing = grouped[row.category];
      if (existing == null) {
        grouped[row.category] = SpendingChartDatum(
          row.category,
          row.amount,
          date: row.date,
        );
        continue;
      }

      grouped[row.category] = SpendingChartDatum(
        row.category,
        existing.amount + row.amount,
        date: row.date.isAfter(existing.date) ? row.date : existing.date,
      );
    }

    return grouped.values.toList();
  }
}
