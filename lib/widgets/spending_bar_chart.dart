import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/spending_chart_data.dart';

class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({super.key, required this.data});

  final List<SpendingChartDatum> data;

  @override
  Widget build(BuildContext context) {
    const barColors = [
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.yellow,
      Colors.blue,
      Colors.green,
      Colors.red,
    ];

    final maxAmount = data.isEmpty
        ? 1000.0
        : data.map((item) => item.amount).reduce((a, b) => a > b ? a : b);
    final chartMaxY = maxAmount > 0 ? maxAmount * 1.2 : 1000.0;

    final barGroups = data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.amount,
            fromY: 0,
            color: barColors[index % barColors.length],
            width: 22,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      height: 490,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 2),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: chartMaxY,
            minY: 0,
            barTouchData: BarTouchData(enabled: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 300,
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 300,
                  getTitlesWidget: (value, meta) =>
                      Text(value.toInt().toString()),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
                  getTitlesWidget: (value, meta) {
                    final item = data[value.toInt()];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.decimalPattern().format(item.amount),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0B1F5A),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }
}
