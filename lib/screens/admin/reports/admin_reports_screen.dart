import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('System Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System-Wide Revenue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50000,
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10000, color: Colors.blue, width: 20)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 25000, color: Colors.blue, width: 20)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15000, color: Colors.blue, width: 20)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 45000, color: Colors.blue, width: 20)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
