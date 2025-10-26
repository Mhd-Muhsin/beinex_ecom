import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  // You can later replace this with data from your OrderBloc
  List<_OrderSummaryData> _getMockData() {
    return [
      _OrderSummaryData(category: 'Electronics', totalOrders: 20, unitsSold: 100),
      _OrderSummaryData(category: 'Fashion', totalOrders: 10, unitsSold: 60),
      _OrderSummaryData(category: 'Home', totalOrders: 8, unitsSold: 40),
      _OrderSummaryData(category: 'Beauty', totalOrders: 5, unitsSold: 25),
      _OrderSummaryData(category: 'Sports', totalOrders: 7, unitsSold: 30),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final data = _getMockData();
    final totalUnits = data.fold<int>(0, (sum, e) => sum + e.unitsSold);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Orders by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPieChart(data, totalUnits, context),
            const SizedBox(height: 32),
            Text(
              'Units Sold per Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBarChart(data, context),
          ],
        ),
      ),
    );
  }

  /// Pie chart showing percentage of units sold
  Widget _buildPieChart(List<_OrderSummaryData> data, int totalUnits, BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.redAccent,
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 50,
          sections: List.generate(data.length, (i) {
            final percent = (data[i].unitsSold / totalUnits) * 100;
            return PieChartSectionData(
              color: colors[i % colors.length],
              value: data[i].unitsSold.toDouble(),
              title: '${percent.toStringAsFixed(1)}%',
              radius: 80,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            );
          }),
        ),
      ),
    );
  }

  /// Bar chart showing total orders
  Widget _buildBarChart(List<_OrderSummaryData> data, BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.redAccent,
    ];

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.map((e) => e.totalOrders).reduce((a, b) => a > b ? a : b) * 1.3),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(data[index].category, style: const TextStyle(fontSize: 11)),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(data.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: data[i].totalOrders.toDouble(),
                  color: colors[i % colors.length],
                  width: 24,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _OrderSummaryData {
  final String category;
  final int totalOrders;
  final int unitsSold;
  _OrderSummaryData({
    required this.category,
    required this.totalOrders,
    required this.unitsSold,
  });
}
