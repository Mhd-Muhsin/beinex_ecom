import 'package:auto_route/annotations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

@RoutePage()
class OrderSummaryPage extends StatelessWidget {
  final List<Product> products;
  final int topN;

  const OrderSummaryPage({
    super.key,
    required this.products,
    this.topN = 8,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, int> stockByCategory = {};
    final Map<String, int> countByCategory = {};
    for (final p in products) {
      stockByCategory[p.category] = (stockByCategory[p.category] ?? 0) + p.stock;
      countByCategory[p.category] = (countByCategory[p.category] ?? 0) + 1;
    }

    final topByPrice = List<Product>.from(products)
      ..sort((a, b) => b.price.compareTo(a.price));
    final showTop = topByPrice.take(topN).toList();

    final totalStock = stockByCategory.values.fold<int>(0, (s, v) => s + v);

    return Scaffold(
      appBar: AppBar(
        title: Text("OrderSummary", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products to display'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOverview(context, products.length, totalStock),
            const SizedBox(height: 20),
            Text('Stock distribution by category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildPieChart(context, stockByCategory, totalStock),
            const SizedBox(height: 30),
            Text('Top products by price', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildBarChart(context, showTop),
          ],
        ),
      ),
    );
  }

  Widget _buildOverview(BuildContext context, int productCount, int totalStock) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Products', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('$productCount', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total stock', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text('$totalStock', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, int> stockByCategory, int totalStock) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.brown.shade400,
    ];

    final entries = stockByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return const SizedBox(height: 180, child: Center(child: Text('No stock data')));
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 48,
              sectionsSpace: 4,
              sections: List.generate(entries.length, (i) {
                final e = entries[i];
                final value = e.value.toDouble();
                final percent = totalStock == 0 ? 0.0 : e.value / totalStock * 100;
                return PieChartSectionData(
                  color: colors[i % colors.length],
                  value: value,
                  title: '${percent.toStringAsFixed(1)}%',
                  radius: 70,
                  titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: List.generate(entries.length, (i) {
            final e = entries[i];
            return _LegendItem(color: colors[i % colors.length], label: e.key, value: e.value);
          }),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, List<Product> items) {
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.brown.shade400,
    ];

    if (items.isEmpty) {
      return const SizedBox(height: 180, child: Center(child: Text('No items to chart')));
    }

    final reversed = items.reversed.toList();
    final maxPrice = reversed.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    final maxY = (maxPrice * 1.2).clamp(1.0, double.infinity);

    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= reversed.length) return const SizedBox();
                  final label = reversed[idx].title;
                  final short = label.length > 10 ? '${label.substring(0, 10)}...' : label;
                  return SideTitleWidget(axisSide: meta.axisSide, child: Text(short, style: const TextStyle(fontSize: 10)));
                },
                reservedSize: 60,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(reversed.length, (i) {
            final p = reversed[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: p.price,
                  color: colors[i % colors.length],
                  width: 18,
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

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  const _LegendItem({required this.color, required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Text('($value)', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
