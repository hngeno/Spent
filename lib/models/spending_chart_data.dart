class SpendingChartDatum {
  const SpendingChartDatum(this.category, this.amount, {required this.date});

  final String category;
  final double amount;
  final DateTime date;

  bool isWithinRange(DateTime start, DateTime end) {
    final startOfDay = DateTime(start.year, start.month, start.day);
    final endOfDay = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    return !date.isBefore(startOfDay) && !date.isAfter(endOfDay);
  }
}
