import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/spending_chart_data.dart';

const String defaultSpendingCsvAssetPath = 'assets/data/default_spending.csv';

String spendingDataAssetPath = defaultSpendingCsvAssetPath;

List<SpendingChartDatum> defaultSpendingData = const [];

Future<List<SpendingChartDatum>> loadDefaultSpendingData({
  String? assetPath,
}) async {
  final resolvedAssetPath = assetPath ?? spendingDataAssetPath;

  final csvString = await rootBundle.loadString(resolvedAssetPath);

  final lines = const LineSplitter()
      .convert(csvString)
      .where((line) => line.trim().isNotEmpty)
      .toList();

  if (lines.length < 2) {
    defaultSpendingData = const [];
    return defaultSpendingData;
  }

  final parsedData = <SpendingChartDatum>[];
  for (var i = 1; i < lines.length; i++) {
    final values = _parseCsvRow(lines[i]);
    if (values.length < 3) {
      continue;
    }

    final category = values[0].trim();
    final amount = double.tryParse(values[1].trim()) ?? 0;
    final date = DateTime.tryParse(values[2].trim()) ?? DateTime(2026, 1, 1);

    parsedData.add(SpendingChartDatum(category, amount, date: date));
  }

  defaultSpendingData = parsedData;
  return parsedData;
}

List<String> _parseCsvRow(String row) {
  final values = <String>[];
  final buffer = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < row.length; i++) {
    final char = row[i];

    if (char == '"') {
      if (inQuotes && i + 1 < row.length && row[i + 1] == '"') {
        buffer.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (char == ',' && !inQuotes) {
      values.add(buffer.toString());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }

  values.add(buffer.toString());
  return values;
}
