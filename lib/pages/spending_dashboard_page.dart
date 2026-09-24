import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/spending_chart_data.dart';
import '../repositories/spending_repository.dart';
import '../widgets/date_picker_tile.dart';
import '../widgets/spending_bar_chart.dart';

class SpendingDashboardPage extends StatefulWidget {
  const SpendingDashboardPage({super.key});

  @override
  State<SpendingDashboardPage> createState() => _SpendingDashboardPageState();
}

class _SpendingDashboardPageState extends State<SpendingDashboardPage> {
  DateTime _startDate = DateTime(2026, 8, 1);
  DateTime _endDate = DateTime(2026, 8, 31);
  final SpendingRepository _repository = SpendingRepository();

  List<SpendingChartDatum> _loadSpendingData() {
    return _repository.getSpendingDataForRange(_startDate, _endDate);
  }

  String _formatAmount(double value) {
    return NumberFormat.decimalPattern().format(value);
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      if (isStartDate) {
        _startDate = selected;
        if (_startDate.isAfter(_endDate)) {
          _endDate = selected;
        }
      } else {
        _endDate = selected;
        if (_endDate.isBefore(_startDate)) {
          _startDate = selected;
        }
        _processSelectedRange();
      }
    });
  }

  String _formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);

  void _processSelectedRange() {
    // Placeholder for future processing logic.
  }

  @override
  Widget build(BuildContext context) {
    final spendingData = _loadSpendingData();
    final totalAmount = spendingData.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFEAF5FF),
        elevation: 0,
        title: const Text(
          'Expenditure Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B1F5A),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 1,
            color: const Color.fromARGB(230, 92, 150, 238),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Analyze your total spend',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A5F8A),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: DatePickerTile(
                            label: 'Start Date',
                            value: _formatDate(_startDate),
                            onTap: () => _pickDate(isStartDate: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DatePickerTile(
                            label: 'End Date',
                            value: _formatDate(_endDate),
                            onTap: () => _pickDate(isStartDate: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF9FBFF), Color(0xFFEAF5FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: const Color.fromARGB(230, 92, 150, 238),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Spending by Category',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SpendingBarChart(data: spendingData),
                          const SizedBox(height: 2),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Total Spend: ${_formatAmount(totalAmount)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0B1F5A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
