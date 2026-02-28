import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/theme.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('System Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Monthly Income', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildIncomeChart(context),
            const SizedBox(height: 32),
            const Text('Invoices Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInvoicesChart(context),
            const SizedBox(height: 32),
            const Text('Projects Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildProjectsChart(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeChart(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).dividerColor.withValues(alpha: 0.5), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final style = TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12);
                  Widget text;
                  switch (value.toInt()) {
                    case 1: text = Text('Jan', style: style); break;
                    case 3: text = Text('Mar', style: style); break;
                    case 5: text = Text('May', style: style); break;
                    default: text = Text('', style: style); break;
                  }
                  return SideTitleWidget(axisSide: meta.axisSide, child: text);
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [FlSpot(1, 10000), FlSpot(2, 15000), FlSpot(3, 12000), FlSpot(4, 20000), FlSpot(5, 35000), FlSpot(6, 25000)],
              isCurved: true,
              color: const Color(0xFF03DAC6),
              barWidth: 4,
              dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: Theme.of(context).cardTheme.color!, strokeWidth: 2, strokeColor: const Color(0xFF03DAC6))),
              belowBarData: BarAreaData(show: true, color: const Color(0xFF03DAC6).withValues(alpha: 0.2)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesChart(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: [
            PieChartSectionData(value: 40, title: 'Paid\n40%', color: const Color(0xFF03DAC6), radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            PieChartSectionData(value: 30, title: 'Pending\n30%', color: secondaryColor, radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            PieChartSectionData(value: 30, title: 'Overdue\n30%', color: const Color(0xFFFF4B4B), radius: 60, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsChart(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).dividerColor.withValues(alpha: 0.5), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
              ),
            ),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) {
              final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7));
              switch (value.toInt()) {
                case 0: return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Active', style: style));
                case 1: return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Completed', style: style));
                case 2: return Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Pending', style: style));
                default: return const Text('');
              }
            })),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 15, color: primaryColor, width: 32, borderRadius: BorderRadius.circular(8), backDrawRodData: BackgroundBarChartRodData(show: true, toY: 30, color: primaryColor.withValues(alpha: 0.1)))]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 25, color: const Color(0xFF03DAC6), width: 32, borderRadius: BorderRadius.circular(8), backDrawRodData: BackgroundBarChartRodData(show: true, toY: 30, color: const Color(0xFF03DAC6).withValues(alpha: 0.1)))]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8, color: secondaryColor, width: 32, borderRadius: BorderRadius.circular(8), backDrawRodData: BackgroundBarChartRodData(show: true, toY: 30, color: secondaryColor.withValues(alpha: 0.1)))]),
          ],
        ),
      ),
    );
  }
}
