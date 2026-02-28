import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../users/user_management_screen.dart';
import '../projects/project_monitoring_screen.dart';
import '../invoices/invoice_monitoring_screen.dart';
import '../reports/admin_reports_screen.dart';
import '../settings/admin_settings_screen.dart';
import '../notifications/admin_notifications_screen.dart';
import '../../../utils/constants.dart';
import '../../../widgets/illustration_header.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminNotificationsScreen()));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7A68), Color(0xFFFF9E8E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text('Admin Portal', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Users'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.work_outline),
              title: const Text('Projects'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProjectMonitoringScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Invoices'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoiceMonitoringScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Reports'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminReportsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingsScreen())),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IllustrationHeader(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Admin Overview',
              subtitle: 'Monitor platform health, users, and transactions.',
              gradientColors: [Color(0xFFFF7A68), Color(0xFFFF9E8E)],
            ),
            const SizedBox(height: 32),
            const Text('System Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(context, 'Total Users', dummyUsers.length.toString(), Icons.people, Colors.blue),
                _buildStatCard(context, 'Total Clients', dummyClients.length.toString(), Icons.business, Colors.purple),
                _buildStatCard(context, 'Total Projects', dummyProjects.length.toString(), Icons.work, Colors.orange),
                _buildStatCard(context, 'Total Invoices', dummyInvoices.length.toString(), Icons.receipt, const Color(0xFF03DAC6)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('System Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
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
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).dividerColor.withValues(alpha: 0.5), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final style = TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12);
                          Widget text;
                          switch (value.toInt()) {
                            case 0: text = Text('Mon', style: style); break;
                            case 2: text = Text('Wed', style: style); break;
                            case 4: text = Text('Fri', style: style); break;
                            case 6: text = Text('Sun', style: style); break;
                            default: text = Text('', style: style); break;
                          }
                          return SideTitleWidget(axisSide: meta.axisSide, child: text);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [const FlSpot(0, 1), const FlSpot(1, 1.5), const FlSpot(2, 1.4), const FlSpot(3, 3.4), const FlSpot(4, 2), const FlSpot(5, 2.2), const FlSpot(6, 1.8)],
                      isCurved: true,
                      color: const Color(0xFFFF7A68),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: Theme.of(context).cardTheme.color!, strokeWidth: 2, strokeColor: const Color(0xFFFF7A68))),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFFF7A68).withValues(alpha: 0.1),
                      ),
                    )
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
