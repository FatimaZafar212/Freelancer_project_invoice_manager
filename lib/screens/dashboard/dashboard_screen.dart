import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../clients/client_list_screen.dart';
import '../projects/project_list_screen.dart';
import '../invoices/invoice_list_screen.dart';
import '../../utils/constants.dart';
import '../../widgets/illustration_header.dart';
import '../../theme/theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=u1'),
            radius: 16,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IllustrationHeader(
              icon: Icons.waving_hand_rounded,
              title: 'Welcome back!',
              subtitle: 'Here is what is happening with your freelance business today.',
              gradientColors: [Color(0xFF6B48FF), Color(0xFF9075FF)],
            ),
            const SizedBox(height: 32),
            const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildVividSummaryCard(context, 'Clients', dummyClients.length.toString(), Icons.people, primaryColor)),
                const SizedBox(width: 12),
                Expanded(child: _buildVividSummaryCard(context, 'Projects', dummyProjects.length.toString(), Icons.work, secondaryColor)),
                const SizedBox(width: 12),
                Expanded(child: _buildVividSummaryCard(context, 'Invoices', dummyInvoices.length.toString(), Icons.receipt, const Color(0xFF03DAC6))),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Quick Access', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(context, 'Clients', Icons.people_outline, const ClientListScreen()),
                _buildQuickAction(context, 'Projects', Icons.work_outline, const ProjectListScreen()),
                _buildQuickAction(context, 'Invoices', Icons.receipt_long_outlined, const InvoiceListScreen()),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Monthly Income', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 300,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final style = TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold, fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Jan'; break;
                            case 1: text = 'Feb'; break;
                            case 2: text = 'Mar'; break;
                            case 3: text = 'Apr'; break;
                            case 4: text = 'May'; break;
                            case 5: text = 'Jun'; break;
                            default: text = ''; break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: Text(text, style: style));
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(0, 5000),
                    _buildBarGroup(1, 7000),
                    _buildBarGroup(2, 4000),
                    _buildBarGroup(3, 8000),
                    _buildBarGroup(4, 6000),
                    _buildBarGroup(5, 9000),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: primaryColor,
          width: 16,
          borderRadius: BorderRadius.circular(8),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 10000,
            color: primaryColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildVividSummaryCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(title, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String title, IconData icon, Widget screen) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 5))
              ],
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}